import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/json.dart';
import 'catalog_models.dart';
import 'package_models.dart';

/// §3.4 discovery: categories, services and the packages they are sold on.
///
/// Every route here is `@Public()` on the backend, so each call passes
/// `skipAuth` — browsing must work before the OTP screen, and sending a stale
/// bearer would otherwise trigger a pointless refresh attempt.
class CatalogRepository {
  CatalogRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  /// US-C06. Active rows in the admin's `sortOrder`.
  Future<ApiResult<List<ServiceCategory>>> categories() => _api.get(
        '/categories',
        skipAuth: true,
        parse: (data) =>
            asMapList(data).map(ServiceCategory.fromJson).toList(),
      );

  /// Services, optionally narrowed to one category or a free-text search.
  Future<ApiResult<List<ServiceSummary>>> services({
    String? categoryId,
    String? search,
  }) =>
      _api.get(
        '/services',
        skipAuth: true,
        query: {
          'categoryId': ?categoryId,
          if (search != null && search.isNotEmpty) 'search': search,
        },
        parse: (data) => asMapList(data).map(ServiceSummary.fromJson).toList(),
      );

  /// US-C09 — the service card, with the packages it can be booked on.
  Future<ApiResult<ServiceDetail>> service(String id) => _api.get(
        '/services/$id',
        skipAuth: true,
        parse: (data) => ServiceDetail.fromJson(asMap(data)),
      );

  Future<ApiResult<List<ServiceAddon>>> addons(String serviceId) => _api.get(
        '/services/$serviceId/addons',
        skipAuth: true,
        parse: (data) => asMapList(data).map(ServiceAddon.fromJson).toList(),
      );

  /// Every live package. With no `serviceId` the prices come back **null** —
  /// a package is not priced until a service is chosen. Pass the service to
  /// get `price` and `perSessionPrice` filled in.
  Future<ApiResult<List<ServicePackage>>> packages({String? serviceId}) =>
      _api.get(
        '/packages',
        skipAuth: true,
        query: {'serviceId': ?serviceId},
        parse: (data) => asMapList(data).map(ServicePackage.fromJson).toList(),
      );
}
