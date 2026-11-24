import '../../../core/dates/hf_date.dart';
import '../../../core/network/json.dart';

/// `GET /app/customer/profile` (§3.2).
///
/// The mobile and email sit on the `User` row and are flattened onto the
/// payload under `user`, because the screen shows them beside the name but
/// they are not columns of the profile.
class CustomerProfile {
  const CustomerProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.gender,
    required this.mobile,
    required this.trustBand,
    required this.referralCode,
    required this.isComplete,
    required this.isBlocked,
    this.email,
    this.dob,
    this.goal,
    this.healthNotes,
    this.blockReason,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    final user = asMap(json['user']);

    return CustomerProfile(
      id: asString(json['id']),
      userId: asString(json['userId']),
      name: asString(json['name']),
      gender: asString(json['gender'], fallback: 'UNDISCLOSED'),
      mobile: asString(user['mobile']),
      email: user['email'] as String?,
      trustBand: asString(json['trustBand'], fallback: 'NEW'),
      referralCode: asString(json['referralCode']),
      isComplete: asBool(json['isComplete']),
      isBlocked: asBool(json['isBlocked']),
      dob: HfDate.parse(json['dob']),
      goal: json['goal'] as String?,
      healthNotes: json['healthNotes'] as String?,
      blockReason: json['blockReason'] as String?,
    );
  }

  /// The CustomerProfile row's own id.
  final String id;

  /// The User row behind it — the subject of the access token, and what a
  /// restored session rebuilds its identity from.
  final String userId;

  final String name;

  /// MALE, FEMALE, OTHER or UNDISCLOSED — the backend enum.
  final String gender;
  final String mobile;
  final String? email;

  /// NEW, BUILDING, TRUSTED or WATCH. Derived server-side, never editable.
  final String trustBand;
  final String referralCode;

  /// False until the mandatory fields are filled; the backend decides which.
  final bool isComplete;

  /// A blocked customer can still sign in and read, but cannot book.
  final bool isBlocked;
  final String? blockReason;
  final DateTime? dob;
  final String? goal;
  final String? healthNotes;
}

/// One saved service address (§3.3). `areaId` and `cityId` are resolved by the
/// backend from the pincode — the app never sends them.
class Address {
  const Address({
    required this.id,
    required this.label,
    required this.line1,
    required this.pincode,
    required this.isDefault,
    this.line2,
    this.landmark,
    this.accessNotes,
    this.areaName,
    this.cityName,
    this.areaId,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: asString(json['id']),
        label: asString(json['label']),
        line1: asString(json['line1']),
        line2: json['line2'] as String?,
        landmark: json['landmark'] as String?,
        pincode: asString(json['pincode']),
        isDefault: asBool(json['isDefault']),
        accessNotes: json['accessNotes'] as String?,
        areaId: json['areaId'] as String?,
        areaName: asMap(json['area'])['name'] as String?,
        cityName: asMap(json['city'])['name'] as String?,
      );

  final String id;
  final String label;
  final String line1;
  final String? line2;
  final String? landmark;
  final String pincode;
  final bool isDefault;
  final String? accessNotes;

  /// Null when the pincode is not mapped to a service area yet — the
  /// "coming soon" state. The address still saves and still books.
  final String? areaId;
  final String? areaName;
  final String? cityName;

  /// What a card shows under the label.
  String get oneLine => [
        line1,
        if (line2 != null && line2!.isNotEmpty) line2,
        if (areaName != null) areaName,
        if (cityName != null) cityName,
        pincode,
      ].join(', ');
}
