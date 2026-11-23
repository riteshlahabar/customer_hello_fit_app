import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/json.dart';
import 'provider_models.dart';
import 'provider_review_models.dart';

/// How a result page is ordered. `price` orders **the page only** — the figure
/// is a derived "from" price, not a column, and the backend says so in `meta`.
enum ProviderSort {
  rating('rating'),
  price('price'),
  experience('experience');

  const ProviderSort(this.wire);

  final String wire;
}

/// §3.4 search and §3.5 profiles — the marketplace half of the PDF, where the
/// customer filters and chooses. Both routes are public.
class ProviderRepository {
  ProviderRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  /// US-C07.
  ///
  /// `serviceId` is the narrow filter and wins over `categoryId`: a category
  /// holds several services, and a provider approved for one must not surface
  /// for another. Pass it as soon as the customer has chosen a service.
  ///
  /// An empty list is a valid answer, not a failure — §3.4 asks for empty
  /// results to be handled, not refused.
  Future<ApiResult<List<ProviderSummary>>> search({
    String? serviceId,
    List<String> categoryIds = const [],
    String? cityId,
    String? areaId,
    double? maxPrice,
    double? minRating,
    String? query,
    ProviderSort? sort,
    int? page,
    int? limit,
  }) =>
      _api.get(
        '/providers',
        skipAuth: true,
        query: {
          'serviceId': ?serviceId,
          // Repeated values are sent comma-separated; the DTO splits them.
          if (categoryIds.isNotEmpty) 'categoryId': categoryIds.join(','),
          'cityId': ?cityId,
          'areaId': ?areaId,
          'maxPrice': ?maxPrice,
          'minRating': ?minRating,
          if (query != null && query.isNotEmpty) 'q': query,
          'sort': ?sort?.wire,
          'page': ?page,
          'limit': ?limit,
        },
        parse: (data) => asMapList(data).map(ProviderSummary.fromJson).toList(),
      );

  /// US-C08. 404 when the provider is not publicly visible.
  Future<ApiResult<ProviderDetail>> provider(String id) => _api.get(
        '/providers/$id',
        skipAuth: true,
        parse: (data) => ProviderDetail.fromJson(asMap(data)),
      );

  Future<ApiResult<ProviderReviews>> reviews(String id, {int? limit}) =>
      _api.get(
        '/instructors/$id/reviews',
        skipAuth: true,
        query: {'limit': ?limit},
        parse: (data) => ProviderReviews.fromJson(asMap(data)),
      );
}
