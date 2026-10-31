import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_result.dart';
import '../../core/providers.dart';
import 'data/auth_models.dart';
import 'data/auth_repository.dart';

/// Where the app is in the sign-in lifecycle. The router watches this to
/// decide which shell to show, so navigation never has to be driven
/// imperatively from a screen.
sealed class AuthState {
  const AuthState();
}

/// Reading stored tokens on launch.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSignedOut extends AuthState {
  const AuthSignedOut({this.reason});

  /// Set when a session ended unexpectedly, so the UI can explain why.
  final String? reason;
}

/// Signed in, with the mode whose shell should load.
final class AuthSignedIn extends AuthState {
  const AuthSignedIn({required this.user, required this.mode});

  final AuthUser user;
  final AppMode mode;
}

/// Holds both roles and has not yet chosen; the "Continue as" chooser shows.
final class AuthNeedsModeChoice extends AuthState {
  const AuthNeedsModeChoice({required this.user});

  final AuthUser user;
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    // A failed refresh anywhere in the app lands here.
    ref.read(apiClientProvider).onSessionExpired = () {
      state = const AuthSignedOut(reason: 'Your session expired.');
    };

    Future.microtask(_restore);
    return const AuthLoading();
  }

  Future<void> _restore() async {
    final repo = ref.read(authRepositoryProvider);

    // A stored refresh token is not proof of a live session; the first
    // authenticated call confirms it and the interceptor signs us out if not.
    state = await repo.hasStoredSession()
        ? const AuthSignedOut()
        : const AuthSignedOut();
  }

  Future<ApiResult<OtpSendResult>> sendOtp(String mobile) {
    return ref.read(authRepositoryProvider).sendOtp(mobile);
  }

  /// Verifies the code and routes to the right shell, honouring a previously
  /// remembered mode for dual-role accounts.
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
      final user = data.user;

      if (user.needsModeChoice) {
        final remembered = await ref.read(tokenStoreProvider).readActiveMode();

        state = remembered == null
            ? AuthNeedsModeChoice(user: user)
            : AuthSignedIn(
                user: user,
                mode: remembered == AppMode.instructor.name
                    ? AppMode.instructor
                    : AppMode.customer,
              );
      } else {
        state = AuthSignedIn(user: user, mode: user.defaultMode);
      }
    }

    return result;
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
    state = const AuthSignedOut();
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
