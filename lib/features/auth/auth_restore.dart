import '../../core/network/api_result.dart';
import '../../core/storage/onboarding_store.dart';
import '../../core/storage/stored_identity.dart';
import '../../core/storage/token_store.dart';
import '../profile/data/profile_models.dart';
import '../profile/data/profile_repository.dart';
import 'auth_state.dart';
import 'data/auth_models.dart';

/// Decides the first screen on launch, and keeps a restored session alive.
///
/// The client's rule (24-11-2026): **once signed in, stay signed in.** Only
/// the server revoking the refresh token may end a session — never a flat
/// network, never a 500, never a slow first request. So launch reads the
/// keystore, draws the app from what it finds, and checks with the API
/// afterwards rather than waiting on it.
class SessionRestorer {
  const SessionRestorer({
    required TokenStore tokens,
    required OnboardingStore onboarding,
    required ProfileRepository profiles,
  })  : _tokens = tokens,
        _onboarding = onboarding,
        _profiles = profiles;

  final TokenStore _tokens;
  final OnboardingStore _onboarding;
  final ProfileRepository _profiles;

  /// The screen to show immediately, from storage alone — no network call, so
  /// a relaunch in a lift still lands on the home screen.
  Future<AuthState> firstState() async {
    final hasSession = await _tokens.readRefreshToken() != null;
    final identity = await _tokens.readIdentity();

    if (!hasSession || identity == null) {
      // Tokens without an identity means a session stored before the
      // snapshot existed: there is no way to name the person, so it costs
      // one more OTP and is then remembered properly.
      if (hasSession) return const AuthSignedOut();

      return await _onboarding.hasSeenOnboarding()
          ? const AuthSignedOut()
          : const AuthNeedsOnboarding();
    }

    final user = userFor(identity);

    return identity.profileComplete
        ? AuthSignedIn(user: user, mode: AppMode.customer)
        : AuthNeedsRegistration(user: user);
  }

  /// Confirms a restored session against the API. Returns the corrected state,
  /// or null to leave the one [firstState] drew alone.
  ///
  /// A token the server refused has already tripped `onSessionExpired` by the
  /// time this returns, so every failure reaching here is a connection or a
  /// server fault — and must change nothing.
  Future<AuthState?> reconcile(AuthUser user) async {
    final profile = await _profiles.profile();
    if (profile case ApiSuccess(:final data)) {
      await remember(user, profileComplete: data.isComplete);
      return stateFor(user, data.isComplete);
    }
    return null;
  }

  /// Writes the snapshot that [firstState] reads next launch.
  Future<void> remember(
    AuthUser user, {
    required bool profileComplete,
  }) {
    return _tokens.saveIdentity(
      StoredIdentity(
        userId: user.id,
        mobile: user.mobile,
        profileComplete: profileComplete,
      ),
    );
  }

  /// Page 07 until the profile has a name, the app itself afterwards. The
  /// backend creates the profile row during OTP verification and reports
  /// `isComplete: false` until a name is saved, which is the gate it
  /// documents.
  AuthState stateFor(AuthUser user, bool profileComplete) => profileComplete
      ? AuthSignedIn(user: user, mode: AppMode.customer)
      : AuthNeedsRegistration(user: user);

  /// Rebuilds the signed-in identity from the stored snapshot. This is the
  /// customer app, so the customer role is the one that matters — a dual-role
  /// account picks its mode again at its next OTP sign-in.
  AuthUser userFor(StoredIdentity identity) => AuthUser(
        id: identity.userId,
        mobile: identity.mobile,
        roles: const [UserRole.customer],
        language: 'en',
        isNewAccount: false,
        hasCustomerProfile: true,
        hasInstructorProfile: false,
      );

  /// The same, from a live profile — used right after verification, when the
  /// profile is already in hand.
  AuthUser userForProfile(CustomerProfile profile) => AuthUser(
        id: profile.userId,
        mobile: profile.mobile,
        roles: const [UserRole.customer],
        language: 'en',
        isNewAccount: false,
        hasCustomerProfile: true,
        hasInstructorProfile: false,
      );
}
