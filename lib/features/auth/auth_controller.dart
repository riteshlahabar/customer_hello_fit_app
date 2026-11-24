import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_result.dart';
import '../../core/providers.dart';
import 'auth_restore.dart';
import 'auth_state.dart';
import 'data/auth_models.dart';
import 'data/auth_repository.dart';

export 'auth_state.dart';

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    // The server refusing the refresh token lands here. Nothing else does —
    // see `auth_restore.dart` for why.
    ref.read(apiClientProvider).onSessionExpired = () {
      state = const AuthSignedOut(
        reason: 'Your session has ended. Please sign in again.',
      );
    };

    Future.microtask(_restore);
    return const AuthLoading();
  }

  SessionRestorer get _restorer => ref.read(sessionRestorerProvider);

  /// Decides the first screen: the slides, the login screen, the registration
  /// form, or straight into the app — from the keystore, without waiting on
  /// the network.
  Future<void> _restore() async {
    state = await _restorer.firstState();

    final user = switch (state) {
      AuthSignedIn(:final user) => user,
      AuthNeedsRegistration(:final user) => user,
      _ => null,
    };
    // Nothing was restored; the login screen is already showing.
    if (user == null) return;

    // The app is drawn and usable. Confirm the snapshot against the API
    // behind it, and correct the screen only if an answer actually came
    // back: null means the check could not be made, and a connection fault
    // must never cost a signed-in customer another OTP.
    final corrected = await _restorer.reconcile(user);

    if (corrected != null && state is! AuthSignedOut) state = corrected;
  }

  /// Page 02-04 finished, or skipped: never shown again on this device.
  Future<void> completeOnboarding() async {
    await ref.read(onboardingStoreProvider).markSeen();
    state = const AuthSignedOut();
  }

  Future<ApiResult<OtpSendResult>> sendOtp(String mobile) {
    return ref.read(authRepositoryProvider).sendOtp(mobile);
  }

  /// Verifies the code and routes onward, honouring a previously remembered
  /// mode for dual-role accounts. A brand-new account lands on page 07: the
  /// backend creates the profile row here with an empty name.
  Future<ApiResult<AuthSession>> verifyOtp({
    required String mobile,
    required String code,
    DeviceInfo? device,
  }) async {
    final result = await ref.read(authRepositoryProvider).verifyOtp(
          mobile: mobile,
          code: code,
          device: device,
        );

    if (result case ApiSuccess<AuthSession>(:final data)) {
      state = await _afterVerify(data.user);
    }

    return result;
  }

  Future<AuthState> _afterVerify(AuthUser user) async {
    // Remembered either way, so no later launch asks for a second OTP. The
    // restored session opens the Customer shell: this is the customer app,
    // and `shells.dart`'s Instructor half is leftover, not the target.
    if (user.needsModeChoice) {
      final remembered = await ref.read(tokenStoreProvider).readActiveMode();

      if (remembered == AppMode.instructor.name) {
        await _restorer.remember(user, profileComplete: true);
        return AuthSignedIn(user: user, mode: AppMode.instructor);
      }
      if (remembered == null) return AuthNeedsModeChoice(user: user);
    }

    if (user.defaultMode == AppMode.instructor) {
      await _restorer.remember(user, profileComplete: true);
      return AuthSignedIn(user: user, mode: AppMode.instructor);
    }

    // The profile says whether the name was ever filled in; a new account's
    // is blank, which is page 07. A complete one goes straight to the home
    // screen — the OTP screen is the last gate there is.
    final profile = await ref.read(profileRepositoryProvider).profile();
    final complete = switch (profile) {
      ApiSuccess(:final data) => data.isComplete,
      // The sign-in worked and the profile read did not. Letting them in is
      // the long-standing behaviour; the snapshot matches it so a relaunch
      // does not disagree with itself.
      ApiFailure() => true,
    };

    await _restorer.remember(user, profileComplete: complete);
    return _restorer.stateFor(user, complete);
  }

  /// Page 07 saved a name, so the account is now usable: straight to the home
  /// screen, and remembered so no later launch asks again.
  Future<void> completeRegistration() async {
    if (state case AuthNeedsRegistration(:final user)) {
      await _restorer.remember(user, profileComplete: true);
      state = AuthSignedIn(user: user, mode: AppMode.customer);
    }
  }

  /// Chooses or switches mode and remembers it for next launch.
  Future<void> setMode(AppMode mode) async {
    final user = switch (state) {
      AuthSignedIn(:final user) => user,
      AuthNeedsModeChoice(:final user) => user,
      _ => null,
    };
    if (user == null) return;

    await ref.read(tokenStoreProvider).saveActiveMode(mode.name);
    state = AuthSignedIn(user: user, mode: mode);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    // Straight to the login screen, never back through onboarding.
    state = const AuthSignedOut();
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
