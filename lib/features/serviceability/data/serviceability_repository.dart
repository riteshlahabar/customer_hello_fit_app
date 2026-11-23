import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/json.dart';

/// Pincode → service area, and the city/area masters behind the filters.
///
/// Coverage stopped gating slots on 23-11-2026 (client): an unmapped PIN still
/// books, because nothing writes provider coverage yet. So a `serviceable:
/// false` here is information for the screen, never a reason to stop.
class ServiceabilityRepository {
  ServiceabilityRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  /// A 400 with `AREA_AMBIGUOUS` when one PIN maps to several areas; the
  /// candidates are in `error.details` for the customer to choose from.
  Future<ApiResult<PincodeCoverage>> pincode(String pincode) => _api.get(
        '/serviceability/$pincode',
        skipAuth: true,
        parse: (data) => PincodeCoverage.fromJson(asMap(data)),
      );

  Future<ApiResult<List<ServiceArea>>> areas({String? cityId}) => _api.get(
        '/serviceability/areas',
        skipAuth: true,
        query: {'cityId': ?cityId},
        parse: (data) => asMapList(data).map(ServiceArea.fromJson).toList(),
      );

  Future<ApiResult<List<ServiceCity>>> cities() => _api.get(
        '/serviceability/cities',
        skipAuth: true,
        parse: (data) => asMapList(data).map(ServiceCity.fromJson).toList(),
      );
}

class PincodeCoverage {
  const PincodeCoverage({
    required this.pincode,
    required this.serviceable,
    required this.areas,
  });

  factory PincodeCoverage.fromJson(Map<String, dynamic> json) =>
      PincodeCoverage(
        pincode: asString(json['pincode']),
        serviceable: asBool(json['serviceable']),
        areas: asMapList(json['areas']).map(ServiceArea.fromJson).toList(),
      );

  final String pincode;
  final bool serviceable;

  /// Exactly one area when the PIN resolves cleanly; empty when it is not
  /// mapped — the design's "coming soon" state.
  final List<ServiceArea> areas;
}

class ServiceArea {
  const ServiceArea({
    required this.id,
    required this.name,
    this.cityId,
    this.cityName,
    this.state,
  });

  factory ServiceArea.fromJson(Map<String, dynamic> json) => ServiceArea(
        id: asString(json['id']),
        name: asString(json['name']),
        cityId: json['cityId'] as String?,
        cityName: json['cityName'] as String?,
        state: json['state'] as String?,
      );

  final String id;
  final String name;
  final String? cityId;
  final String? cityName;
  final String? state;
}

class ServiceCity {
  const ServiceCity({required this.id, required this.name, this.state});

  factory ServiceCity.fromJson(Map<String, dynamic> json) => ServiceCity(
        id: asString(json['id']),
        name: asString(json['name']),
        state: json['state'] as String?,
      );

  final String id;
  final String name;
  final String? state;
}
