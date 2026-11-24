import 'data/auth_models.dart';

/// Where the app is in the sign-in lifecycle. The root widget watches this to
/// decide which screen shows, so navigation is never driven imperatively from
/// inside a screen.
///
/// The one exception is Login -> OTP, which is a push inside the login route:
/// "Edit" and "Change mobile number" on page 06 are a back action, and a
/// Navigator pop is what gives them the right animation and gesture.
sealed class AuthState {
  const AuthState();
}

/// Reading stored tokens on launch — the splash screen (page 01) is showing.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// First run on this device: the three slides of pages 02-04 come before the
/// login screen.
final class AuthNeedsOnboarding extends AuthState {
  const AuthNeedsOnboarding();
}

final class AuthSignedOut extends AuthState {
  const AuthSignedOut({this.reason});

  /// Set when a session ended unexpectedly, so the UI can explain why.
  final String? reason;
}

/// Verified, but the customer profile has no name yet — page 07 collects it.
/// The backend creates the profile row during OTP verification and reports
/// `isComplete: false` until a name is saved, which is the gate it documents.
final class AuthNeedsRegistration extends AuthState {
  const AuthNeedsRegistration({required this.user});

  final AuthUser user;
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
