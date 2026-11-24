import 'package:dio/dio.dart';

import '../storage/token_store.dart';

/// What came of spending the refresh token.
///
/// The middle case is the one that matters: "could not renew" is not the same
/// as "you are signed out", and conflating the two is what makes an app ask
/// for an OTP every time the server hiccups.
enum RefreshOutcome {
  /// A new pair is stored; the caller may retry its request.
  renewed,

  /// The server refused the token, or there is none. The session is over.
  refused,

  /// Nothing could be established — a 5xx, a gateway page, a junk reply. The
  /// stored tokens are untouched and the session stands.
  unavailable,
}

/// Spends the refresh token for a new pair.
///
/// Split out of [ApiClient] so the one rule that decides whether a customer
/// keeps their session lives in a file of its own, and so the client stays
/// under the 200-line limit.
class TokenRefresher {
  TokenRefresher({required Dio dio, required TokenStore tokenStore})
      : _dio = dio,
        _tokenStore = tokenStore;

  final Dio _dio;
  final TokenStore _tokenStore;

  /// Guards against a burst of 401s each firing its own refresh.
  Future<RefreshOutcome>? _inFlight;

  /// Concurrent callers await the same attempt: the backend rotates the
  /// refresh token and treats a replayed one as stolen, so a second parallel
  /// rotation would revoke the chain it just renewed.
  Future<RefreshOutcome> refreshOnce() {
    return _inFlight ??= _perform().whenComplete(() {
      _inFlight = null;
    });
  }

  Future<RefreshOutcome> _perform() async {
    final refreshToken = await _tokenStore.readRefreshToken();
    if (refreshToken == null) return RefreshOutcome.refused;

    final response = await _dio.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
      options: Options(extra: {'skipAuth': true}),
    );

    final body = response.data;

    if (body is! Map<String, dynamic> || body['success'] != true) {
      // Only the server actually refusing the token ends the session. A 500,
      // a gateway page or a malformed reply must not cost a signed-in
      // customer their 30-day refresh token and another OTP — the caller
      // fails this one request and tries again later.
      final status = response.statusCode ?? 0;
      if (status != 401 && status != 403) return RefreshOutcome.unavailable;

      await _tokenStore.clear();
      return RefreshOutcome.refused;
    }

    final data = body['data'] as Map<String, dynamic>;
    await _tokenStore.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
    return RefreshOutcome.renewed;
  }
}
