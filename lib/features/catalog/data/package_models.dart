import '../../../core/network/json.dart';

/// A package as the customer picks it (`GET /packages`, and inside a service).
///
/// `price` and `perSessionPrice` are null on the unfiltered `/packages` list —
/// a package has no price until a service is chosen, because the rate is
/// `basePrice x persons x sessionCount` then the percent.
class ServicePackage {
  const ServicePackage({
    required this.id,
    required this.name,
    required this.sessionCount,
    required this.persons,
    required this.freeSessionCount,
    required this.validityDays,
    required this.percentAdjust,
    required this.allowedWeekdays,
    required this.fixedInstructorAllowed,
    this.icon,
    this.price,
    this.perSessionPrice,
    this.services = const [],
  });

  factory ServicePackage.fromJson(Map<String, dynamic> json) => ServicePackage(
        id: asString(json['id']),
        name: asString(json['name']),
        sessionCount: asInt(json['sessionCount'], fallback: 1),
        persons: asInt(json['persons'], fallback: 1),
        freeSessionCount: asInt(json['freeSessionCount']),
        validityDays: asInt(json['validityDays']),
        percentAdjust: asDouble(json['percentAdjust']),
        allowedWeekdays: asIntList(json['allowedWeekdays']),
        fixedInstructorAllowed: asBool(json['fixedInstructorAllowed']),
        icon: json['icon'] as String?,
        price: asDoubleOrNull(json['price']),
        perSessionPrice: asDoubleOrNull(json['perSessionPrice']),
        services: asMapList(json['services'])
            .map((s) => (id: asString(s['id']), name: asString(s['name'])))
            .toList(),
      );

  final String id;
  final String name;
  final int sessionCount;

  /// How many people the package covers. A quote may send `participantCount`
  /// only if it equals this.
  final int persons;

  /// Delivered, charged to nobody, paid to nobody.
  final int freeSessionCount;
  final int validityDays;

  /// Negative is a discount, positive a premium. The only discount there is.
  final double percentAdjust;

  /// 0 = Sunday. Empty means any day.
  final List<int> allowedWeekdays;
  final bool fixedInstructorAllowed;
  final String? icon;

  /// Null until a service narrows it.
  final double? price;
  final double? perSessionPrice;

  /// Which services this package is sold on.
  final List<({String id, String name})> services;
}

