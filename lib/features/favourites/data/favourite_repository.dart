import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/json.dart';
import '../../providers/data/provider_models.dart';

/// Saved providers — the heart on a search result.
///
/// **Client instruction, 13 Nov 2026; not in the v3 PDF.** Both writes are
/// idempotent because a heart gets tapped twice, and the list applies the same
/// visibility rule as the search: a suspended provider drops out without the
/// row being deleted, so reinstating them brings it back.
class FavouriteRepository {
  FavouriteRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  /// The full cards, each carrying `savedAt`.
  Future<ApiResult<List<ProviderSummary>>> list() => _api.get(
        '/favourites',
        parse: (data) => asMapList(data).map(ProviderSummary.fromJson).toList(),
      );

  /// Just the ids, for painting hearts on a list of search results without
  /// pulling every saved card.
  Future<ApiResult<List<String>>> ids() => _api.get(
        '/favourites/ids',
        parse: asStringList,
      );

  Future<ApiResult<bool>> save(String instructorId) => _api.post(
        '/favourites/$instructorId',
        parse: (data) => asBool(asMap(data)['saved'], fallback: true),
      );

  Future<ApiResult<bool>> remove(String instructorId) => _api.delete(
        '/favourites/$instructorId',
        parse: (data) => asBool(asMap(data)['saved']),
      );
}
