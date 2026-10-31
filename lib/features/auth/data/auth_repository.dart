import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../core/storage/token_store.dart';
import 'auth_models.dart';

/// All auth calls in one place. Returns ApiResult so the controller decides
/// what the user sees — the repository never throws for an expected failure
/// such as a wrong OTP.
class AuthRepository {
  AuthRepository({required ApiClient api, required TokenStore tokenStore})
      : _api = api,
        _tokenStore = tokenStore;

  final ApiClient _api;
  final TokenStore _tokenStore;

  /// The backend returns the same shape whether or not the number is
  /// registered, so this cannot be used to discover customers.
  Future<ApiResult<OtpSendResult>> sendOtp(String mobile) => _api.post(
        '/auth/otp/send',
        body: {'mobile': mobile},
        skipAuth: true,
        parse: (data) =>
            OtpSendResult.fromJson(data as Map<String, dynamic>),
      );

  /// Verifies the code and persists the token pair on success.
  Future<ApiResult<AuthSession>> verifyOtp({
    required String mobile,
    required String code,
    DeviceInfo? device,
  }) async {
    final result = await _api.post<AuthSession>(
      '/auth/otp/verify',
      skipAuth: true,
      body: {
        'mobile': mobile,
        'code': code,
        if (device != null) 'device': device.toJson(),
      },
      parse: (data) => AuthSession.fromJson(data as Map<String, dynamic>),
    );

    if (result case ApiSuccess<AuthSession>(:final data)) {
      await _tokenStore.saveTokens(
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
      );
    }

    return result;
  }

  /// Revokes the refresh token server-side, then clears local storage even if
  /// the call fails — the user asked to sign out and must end up signed out.
  Future<void> logout() async {
    final refreshToken = await _tokenStore.readRefreshToken();

    if (refreshToken != null) {
      await _api.post<dynamic>(
        '/auth/logout',
        body: {'refreshToken': refreshToken},
      );
    }

    await _tokenStore.clear();
  }

  Future<bool> hasStoredSession() async =>
      await _tokenStore.readRefreshToken() != null;
}

class OtpSendResult {
  const OtpSendResult({required this.sent, this.expiresAt, this.devCode});

  factory OtpSendResult.fromJson(Map<String, dynamic> json) => OtpSendResult(
        sent: (json['sent'] as bool?) ?? false,
        expiresAt: json['expiresAt'] == null
            ? null
            : DateTime.tryParse(json['expiresAt'] as String),
        devCode: json['devCode'] as String?,
      );

  final bool sent;
  final DateTime? expiresAt;

  /// Present only while the backend runs in development, before the SMS
  /// provider is wired up. Never populated in production.
  final String? devCode;
}
