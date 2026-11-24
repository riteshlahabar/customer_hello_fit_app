import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'stored_identity.dart';

/// Tokens live in the platform keystore, not SharedPreferences: a refresh
/// token is a long-lived credential and must survive neither a backup nor a
/// rooted-device dump in plain text.
class TokenStore {
  TokenStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              // v11 encrypts by default (AES-GCM with RSA-OAEP key wrapping),
              // so the old encryptedSharedPreferences flag no longer exists.
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  final FlutterSecureStorage _storage;

  static const _accessKey = 'hf_access_token';
  static const _refreshKey = 'hf_refresh_token';
  static const _modeKey = 'hf_active_mode';
  static const _userIdKey = 'hf_user_id';
  static const _mobileKey = 'hf_user_mobile';
  static const _profileDoneKey = 'hf_profile_complete';

  Future<String?> readAccessToken() => _storage.read(key: _accessKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshKey);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  /// Which shell the person last chose, for accounts holding both roles
  /// (spec 6.1).
  Future<String?> readActiveMode() => _storage.read(key: _modeKey);

  Future<void> saveActiveMode(String mode) =>
      _storage.write(key: _modeKey, value: mode);

  /// Who the stored tokens belong to. Null for a session saved before the
  /// snapshot existed, which costs one more OTP and then stores it.
  Future<StoredIdentity?> readIdentity() async {
    final userId = await _storage.read(key: _userIdKey);
    final mobile = await _storage.read(key: _mobileKey);
    if (userId == null || mobile == null) return null;

    return StoredIdentity(
      userId: userId,
      mobile: mobile,
      profileComplete: await _storage.read(key: _profileDoneKey) == 'true',
    );
  }

  Future<void> saveIdentity(StoredIdentity identity) async {
    await _storage.write(key: _userIdKey, value: identity.userId);
    await _storage.write(key: _mobileKey, value: identity.mobile);
    await _storage.write(
      key: _profileDoneKey,
      value: identity.profileComplete.toString(),
    );
  }

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
    await _storage.delete(key: _modeKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _mobileKey);
    await _storage.delete(key: _profileDoneKey);
  }
}
