/// Which shell the person sees (spec 6.1).
enum AppMode { customer, instructor }

/// Account roles as the backend sends them.
enum UserRole {
  customer,
  instructor;

  static UserRole? tryParse(String value) => switch (value.toUpperCase()) {
        'CUSTOMER' => UserRole.customer,
        'INSTRUCTOR' => UserRole.instructor,
        _ => null,
      };
}

/// The session payload returned by POST /auth/otp/verify. Carries exactly what
/// the app needs to decide which shell loads and whether onboarding is pending.
class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      );

  final String accessToken;
  final String refreshToken;
  final AuthUser user;
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.mobile,
    required this.roles,
    required this.language,
    required this.isNewAccount,
    required this.hasCustomerProfile,
    required this.hasInstructorProfile,
    this.instructorOnboardingStage,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String,
        mobile: json['mobile'] as String,
        roles: ((json['roles'] as List<dynamic>?) ?? const [])
            .map((r) => UserRole.tryParse(r.toString()))
            .whereType<UserRole>()
            .toList(),
        language: (json['language'] as String?) ?? 'en',
        isNewAccount: (json['isNewAccount'] as bool?) ?? false,
        hasCustomerProfile: (json['hasCustomerProfile'] as bool?) ?? false,
        hasInstructorProfile: (json['hasInstructorProfile'] as bool?) ?? false,
        instructorOnboardingStage: json['instructorOnboardingStage'] as String?,
      );

  final String id;
  final String mobile;
  final List<UserRole> roles;
  final String language;
  final bool isNewAccount;
  final bool hasCustomerProfile;
  final bool hasInstructorProfile;

  /// Non-null once the person has applied to teach; `APPROVED` is the only
  /// stage that unlocks the Instructor shell (spec 6.1).
  final String? instructorOnboardingStage;

  bool get isApprovedInstructor =>
      roles.contains(UserRole.instructor) &&
      instructorOnboardingStage == 'APPROVED';

  /// An applicant who is not yet approved gets the Customer shell plus an
  /// application-status card, rather than the Instructor shell.
  bool get isPendingInstructorApplicant =>
      instructorOnboardingStage != null && !isApprovedInstructor;

  /// True when the person must be asked which mode to continue in.
  bool get needsModeChoice =>
      roles.contains(UserRole.customer) && isApprovedInstructor;

  AppMode get defaultMode =>
      isApprovedInstructor && !roles.contains(UserRole.customer)
          ? AppMode.instructor
          : AppMode.customer;
}

/// Device registration sent with the OTP verification so push and per-device
/// revocation work from first login.
class DeviceInfo {
  const DeviceInfo({
    required this.platform,
    required this.deviceId,
    this.fcmToken,
    this.appVersion,
  });

  /// ANDROID, IOS or WEB — must match the backend enum.
  final String platform;
  final String deviceId;
  final String? fcmToken;
  final String? appVersion;

  Map<String, dynamic> toJson() => {
        'platform': platform,
        'deviceId': deviceId,
        if (fcmToken != null) 'fcmToken': fcmToken,
        if (appVersion != null) 'appVersion': appVersion,
      };
}
