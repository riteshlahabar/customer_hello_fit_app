/// The least that has to be remembered to draw a signed-in app before the
/// network answers.
///
/// A refresh token in the keystore proves somebody signed in; it does not say
/// who, and `/auth/refresh` returns a token pair and nothing else. Saving this
/// beside the tokens is what lets a relaunch go straight to the home screen
/// instead of asking for another OTP (client, 24-11-2026).
class StoredIdentity {
  const StoredIdentity({
    required this.userId,
    required this.mobile,
    required this.profileComplete,
  });

  final String userId;

  /// The verified number, which page 07 shows locked.
  final String mobile;

  /// False while registration is still owed, so a relaunch lands on page 07
  /// rather than the login screen.
  final bool profileComplete;
}
