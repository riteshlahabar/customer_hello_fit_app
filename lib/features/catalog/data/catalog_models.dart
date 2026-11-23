import '../../../core/network/json.dart';
import 'package_models.dart';

/// `GET /categories` — the specialisation tiles (§3.4).
class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.serviceCount,
    this.icon,
    this.imageUrl,
    this.description,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      ServiceCategory(
        id: asString(json['id']),
        name: asString(json['name']),
        slug: asString(json['slug']),
        serviceCount: asInt(asMap(json['_count'])['services']),
        icon: json['icon'] as String?,
        imageUrl: json['imageUrl'] as String?,
        description: json['description'] as String?,
      );

  final String id;
  final String name;
  final String slug;

  /// How many live services hang off it, so an empty tile can be hidden.
  final int serviceCount;
  final String? icon;
  final String? imageUrl;
  final String? description;
}

/// A row of `GET /services`.
class ServiceSummary {
  const ServiceSummary({
    required this.id,
    required this.name,
    required this.slug,
    required this.durationMin,
    required this.basePrice,
    required this.categoryId,
    required this.categoryName,
    this.description,
  });

  factory ServiceSummary.fromJson(Map<String, dynamic> json) {
    final category = asMap(json['category']);

    return ServiceSummary(
      id: asString(json['id']),
      name: asString(json['name']),
      slug: asString(json['slug']),
      durationMin: asInt(json['durationMin']),
      basePrice: asDouble(json['basePrice']),
      categoryId: asString(category['id']),
      categoryName: asString(category['name']),
      description: json['description'] as String?,
    );
  }

  final String id;
  final String name;
  final String slug;
  final int durationMin;

  /// Admin-set, and the only rate there is — a provider never prices
  /// (client, 17 Nov 2026, overriding PDF §4.5).
  final double basePrice;
  final String categoryId;
  final String categoryName;
  final String? description;
}

/// `GET /services/:id` — adds the packages the service is sold on.
class ServiceDetail {
  const ServiceDetail({
    required this.id,
    required this.name,
    required this.durationMin,
    required this.basePrice,
    required this.categoryId,
    required this.categoryName,
    required this.packages,
    required this.allowExtension,
    this.description,
    this.equipment,
    this.instructions,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    final category = asMap(json['category']);

    return ServiceDetail(
      id: asString(json['id']),
      name: asString(json['name']),
      durationMin: asInt(json['durationMin']),
      basePrice: asDouble(json['basePrice']),
      categoryId: asString(json['categoryId'], fallback: asString(category['id'])),
      categoryName: asString(category['name']),
      packages: asMapList(json['packages'])
          .map(ServicePackage.fromJson)
          .toList(),
      allowExtension: asBool(json['allowExtension']),
      description: json['description'] as String?,
      equipment: json['equipment'] as String?,
      instructions: json['instructions'] as String?,
    );
  }

  final String id;
  final String name;
  final int durationMin;
  final double basePrice;
  final String categoryId;
  final String categoryName;

  /// Only the packages linked to this service, each already priced for it.
  final List<ServicePackage> packages;
  final bool allowExtension;
  final String? description;
  final String? equipment;
  final String? instructions;
}

/// `GET /services/:id/addons` — optional extras priced per unit.
///
/// `applicableServiceIds` comes back but is not kept: the route has already
/// filtered to this service, and an empty list there means "every service".
class ServiceAddon {
  const ServiceAddon({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });

  factory ServiceAddon.fromJson(Map<String, dynamic> json) => ServiceAddon(
        id: asString(json['id']),
        name: asString(json['name']),
        price: asDouble(json['price']),
        description: json['description'] as String?,
      );

  final String id;
  final String name;
  final double price;
  final String? description;
}
