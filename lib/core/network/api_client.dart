import 'dart:async';

import 'package:dio/dio.dart';

import '../storage/token_store.dart';
import 'api_result.dart';
import 'network_errors.dart';
import 'token_refresher.dart';

/// Single Dio instance with the interceptors every request needs: bearer
/// token, one-shot refresh rotation on 401, and envelope-aware error mapping.
class ApiClient {
  ApiClient({required TokenStore tokenStore, String? baseUrl})
      : _tokenStore = tokenStore,
        _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? defaultBaseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 20),
            contentType: Headers.jsonContentType,
            // The backend signals failures through the envelope, so let every
            // status through and map it here instead of throwing on 4xx.
            validateStatus: (_) => true,
          ),
        ) {
    _refresher = TokenRefresher(dio: _dio, tokenStore: tokenStore);
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: _attachToken),
    );
  }

  /// 10.0.2.2 is the host machine as seen from the Android emulator;
  /// localhost there would be the emulator itself.
  static const defaultBaseUrl = 'http://10.0.2.2:3000/api/v1';

  final Dio _dio;
  final TokenStore _tokenStore;

  /// Set by the auth layer so a failed refresh can drop the session.
  void Function()? onSessionExpired;

  /// Owns the one-shot rotation and its single-flight guard.
  late final TokenRefresher _refresher;

  Future<void> _attachToken(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] != true) {
      final token = await _tokenStore.readAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(dynamic data)? parse,
    bool skipAuth = false,
  }) =>
      _send(
        () => _dio.get(
          path,
          queryParameters: query,
          options: Options(extra: {'skipAuth': skipAuth}),
        ),
        parse,
      );

  Future<ApiResult<T>> post<T>(
    String path, {
    Object? body,
    T Function(dynamic data)? parse,
    bool skipAuth = false,
  }) =>
      _send(
        () => _dio.post(
          path,
          data: body,
          options: Options(extra: {'skipAuth': skipAuth}),
        ),
        parse,
      );

  Future<ApiResult<T>> patch<T>(
    String path, {
    Object? body,
    T Function(dynamic data)? parse,
  }) =>
      _send(() => _dio.patch(path, data: body), parse);

  /// A replace, not a patch — notification preferences are the one PUT the
  /// customer surface has.
  Future<ApiResult<T>> put<T>(
    String path, {
    Object? body,
    T Function(dynamic data)? parse,
  }) =>
      _send(() => _dio.put(path, data: body), parse);

  Future<ApiResult<T>> delete<T>(
    String path, {
    Object? body,
    T Function(dynamic data)? parse,
  }) =>
      _send(() => _dio.delete(path, data: body), parse);

  /// Runs the request, retries once after a successful token refresh, and
  /// converts whatever comes back into an ApiResult.
  Future<ApiResult<T>> _send<T>(
    Future<Response<dynamic>> Function() request,
    T Function(dynamic data)? parse, {
    bool isRetry = false,
  }) async {
    try {
      final response = await request();
      final body = response.data;

      if (body is! Map<String, dynamic>) {
        return ApiFailure<T>(
          code: ApiErrorCode.unknown,
          message: 'Unexpected response from server',
          statusCode: response.statusCode,
        );
      }

      if (body['success'] == true) {
        final data = body['data'];
        return ApiSuccess<T>(
          parse != null ? parse(data) : data as T,
          message: body['message'] as String?,
          meta: body['meta'] as Map<String, dynamic>?,
        );
      }

      final error = (body['error'] as Map<String, dynamic>?) ?? const {};
      final code = (error['code'] as String?) ?? ApiErrorCode.unknown;

      // An expired access token is recoverable exactly once per request. A
      // renewal that could not be *attempted* leaves the session alone: only
      // the server refusing the refresh token signs anybody out.
      if (!isRetry && code == ApiErrorCode.tokenExpired) {
        switch (await _refresher.refreshOnce()) {
          case RefreshOutcome.renewed:
            return _send(request, parse, isRetry: true);
          case RefreshOutcome.refused:
            onSessionExpired?.call();
          case RefreshOutcome.unavailable:
            break;
        }
      }

      if (code == ApiErrorCode.tokenInvalid ||
          code == ApiErrorCode.unauthenticated) {
        onSessionExpired?.call();
      }

      return ApiFailure<T>(
        code: code,
        message: (error['message'] as String?) ?? 'Something went wrong',
        details: error['details'],
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiFailure<T>(
        code: ApiErrorCode.network,
        message: networkMessageFor(e.type),
      );
    }
  }

}
