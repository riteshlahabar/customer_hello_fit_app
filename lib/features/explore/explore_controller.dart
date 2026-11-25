import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_result.dart';
import '../../core/network/json.dart';
import '../../core/providers.dart';
import '../providers/data/provider_models.dart';
import '../providers/data/provider_repository.dart';

/// Page 10's three controls and the one result feed they drive.
///
/// The query, the chip and the sort are separate providers so the results
/// provider can simply watch all three — changing any one re-runs the search
/// server-side. **No new backend** (client, 23-11-2026): this is
/// `GET /providers`, which already takes `q`, `categoryId` and `sort`.
///
/// Unlike the dashboard's feeds, a failed search is **shown**. A dashboard can
/// hide a dead section; a search that silently returns nothing would read as
/// "no trainers found", which is a different and wrong answer.

/// What the customer typed. The field debounces before writing here, so every
/// value in this provider is a search worth running.
class ExploreQuery extends Notifier<String> {
  @override
  String build() => '';

  void set(String value) => state = value;
}

final exploreQueryProvider =
    NotifierProvider<ExploreQuery, String>(ExploreQuery.new);

/// The active `.chip`. Null is "All Trainers", the design's default.
class ExploreCategory extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? categoryId) => state = categoryId;
}

final exploreCategoryProvider =
    NotifierProvider<ExploreCategory, String?>(ExploreCategory.new);

/// `.sort-row`. Null is the design's "Recommended" — no `sort` on the wire, so
/// the backend's own default order stands.
class ExploreSort extends Notifier<ProviderSort?> {
  @override
  ProviderSort? build() => null;

  void select(ProviderSort? sort) => state = sort;
}

final exploreSortProvider =
    NotifierProvider<ExploreSort, ProviderSort?>(ExploreSort.new);

/// A page of results, with the total the design's `.result-count` shows.
typedef ExploreResultPage = ({List<ProviderSummary> rows, int total});

/// Carries the backend's own message to the retry line, rather than a generic
/// "something went wrong".
class ExploreFailed implements Exception {
  const ExploreFailed(this.message);

  final String message;

  @override
  String toString() => message;
}

/// `GET /providers`. One page of 20 — the design scrolls a single list and has
/// no pager, so page 2 waits for a real "load more" in the design.
final exploreResultsProvider = FutureProvider<ExploreResultPage>((ref) async {
  final query = ref.watch(exploreQueryProvider).trim();
  final categoryId = ref.watch(exploreCategoryProvider);
  final sort = ref.watch(exploreSortProvider);

  final result = await ref.watch(providerRepositoryProvider).search(
        query: query.isEmpty ? null : query,
        categoryIds: categoryId == null ? const [] : [categoryId],
        sort: sort,
        limit: 20,
      );

  return switch (result) {
    // `meta.total` is the whole matching count, not this page's length.
    ApiSuccess(:final data, :final meta) => (
        rows: data,
        total: asInt(meta?['total'], fallback: data.length),
      ),
    ApiFailure(:final message) => throw ExploreFailed(message),
  };
});
