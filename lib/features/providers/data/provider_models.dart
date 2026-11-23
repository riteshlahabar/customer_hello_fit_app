import '../../../core/dates/hf_date.dart';
import '../../../core/network/json.dart';

/// A card in the provider list (§3.4, §5.5). The customer picks from these —
/// the platform never picks for them.
class ProviderSummary {
  const ProviderSummary({
    required this.id,
    required this.name,
    required this.experienceYears,
    required this.languages,
    required this.specialisations,
    required this.rating,
    required this.ratingCount,
    required this.serviceCount,
    required this.categories,
    this.photoUrl,
    this.headline,
    this.fromPrice,
    this.savedAt,
  });

  factory ProviderSummary.fromJson(Map<String, dynamic> json) =>
      ProviderSummary(
        id: asString(json['id']),
        name: asString(json['name']),
        experienceYears: asInt(json['experienceYears']),
        languages: asStringList(json['languages']),
        specialisations: asStringList(json['specialisations']),
        rating: asDouble(json['rating']),
        ratingCount: asInt(json['ratingCount']),
        serviceCount: asInt(json['serviceCount']),
        categories: asMapList(json['categories'])
            .map((c) => (id: asString(c['id']), name: asString(c['name'])))
            .toList(),
        photoUrl: json['photoUrl'] as String?,
        headline: json['headline'] as String?,
        fromPrice: asDoubleOrNull(json['fromPrice']),
        savedAt: HfDate.parse(json['savedAt']),
      );

  final String id;
  final String name;
  final int experienceYears;
  final List<String> languages;
  final List<String> specialisations;

  /// Published average, 0 when nobody has reviewed yet.
  final double rating;
  final int ratingCount;

  /// How many approved services this provider teaches.
  final int serviceCount;
  final List<({String id, String name})> categories;
  final String? photoUrl;
  final String? headline;

  /// Cheapest approved service, as a "from" figure. Null when the row came
  /// back without prices.
  final double? fromPrice;

  /// Only on a row from `GET /favourites` — when the heart was tapped.
  final DateTime? savedAt;

  bool get hasReviews => ratingCount > 0;
}

/// `GET /providers/:id` — US-C08. A provider not publicly visible (suspended,
/// KYC lapsed, no approved service) is a 404 here, never a 403.
class ProviderDetail {
  const ProviderDetail({
    required this.id,
    required this.name,
    required this.experienceYears,
    required this.languages,
    required this.specialisations,
    required this.rating,
    required this.ratingCount,
    required this.services,
    required this.areas,
    this.photoUrl,
    this.bio,
  });

  factory ProviderDetail.fromJson(Map<String, dynamic> json) => ProviderDetail(
        id: asString(json['id']),
        name: asString(json['name']),
        experienceYears: asInt(json['experienceYears']),
        languages: asStringList(json['languages']),
        specialisations: asStringList(json['specialisations']),
        rating: asDouble(json['rating']),
        ratingCount: asInt(json['ratingCount']),
        services: asMapList(json['services'])
            .map(ProviderService.fromJson)
            .toList(),
        areas: asMapList(json['areas']).map(ProviderArea.fromJson).toList(),
        photoUrl: json['photoUrl'] as String?,
        bio: json['bio'] as String?,
      );

  final String id;
  final String name;
  final int experienceYears;
  final List<String> languages;
  final List<String> specialisations;
  final double rating;
  final int ratingCount;

  /// What this provider is approved to teach, each with its own price.
  final List<ProviderService> services;

  /// Where they work. Written by nothing yet (PDF §4.2 puts it on the unbuilt
  /// provider app), so this is often empty and must not gate the booking.
  final List<ProviderArea> areas;
  final String? photoUrl;
  final String? bio;
}

/// One approved offering on a provider profile.
class ProviderService {
  const ProviderService({
    required this.id,
    required this.offeringId,
    required this.name,
    required this.durationMin,
    required this.price,
    required this.level,
    required this.categoryName,
  });

  factory ProviderService.fromJson(Map<String, dynamic> json) =>
      ProviderService(
        id: asString(json['id']),
        offeringId: asString(json['offeringId']),
        name: asString(json['name']),
        durationMin: asInt(json['durationMin']),
        price: asDouble(json['price']),
        level: asString(json['level'], fallback: 'ALL_LEVELS'),
        categoryName: asString(asMap(json['category'])['name']),
      );

  /// The **service** id — what a booking and a slot query take.
  final String id;

  /// The join row (`InstructorService`). Not used when booking; kept because
  /// it is what the admin approval acts on.
  final String offeringId;
  final String name;
  final int durationMin;
  final double price;

  /// BEGINNER, INTERMEDIATE, ADVANCED or ALL_LEVELS.
  final String level;
  final String categoryName;
}

class ProviderArea {
  const ProviderArea({required this.id, required this.name, this.cityName});

  factory ProviderArea.fromJson(Map<String, dynamic> json) => ProviderArea(
        id: asString(json['id']),
        name: asString(json['name']),
        cityName: asMap(json['city'])['name'] as String?,
      );

  final String id;
  final String name;
  final String? cityName;
}
