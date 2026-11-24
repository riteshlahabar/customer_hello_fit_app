import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Remembers that the three onboarding slides (pages 02-04) have been seen.
///
/// Deliberately not part of [TokenStore]: signing out clears tokens, and a
/// returning customer must not be walked through onboarding again. Keeping
/// the flag in its own store makes that impossible to get wrong, and avoids
/// pulling in a second storage package for one boolean.
class OnboardingStore {
  OnboardingStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _seenKey = 'hf_onboarding_seen';

  /// Treated as "not seen" when the read fails, so a storage error shows the
  /// slides rather than blocking the app on a blank screen.
  Future<bool> hasSeenOnboarding() async {
    try {
      return await _storage.read(key: _seenKey) == 'true';
    } catch (_) {
      return false;
    }
  }

  Future<void> markSeen() async {
    try {
      await _storage.write(key: _seenKey, value: 'true');
    } catch (_) {
      // Not worth failing the journey over; worst case it shows once more.
    }
  }
}
