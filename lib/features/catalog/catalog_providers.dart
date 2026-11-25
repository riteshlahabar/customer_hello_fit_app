import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_result.dart';
import '../../core/providers.dart';
import 'data/catalog_models.dart';

/// `GET /categories`, live rows only — shared, because two tabs want the same
/// list: page 09's four tiles and page 10's filter chips.
///
/// It sits here rather than in either feature because `CustomerShell` keeps
/// every tab alive in an `IndexedStack`, so a copy per feature would fire the
/// same request twice on every launch.
///
/// Empty categories are dropped: a tile or a chip that leads to no services
/// is a dead end. Fails soft to an empty list — a dead master must not blank
/// the dashboard or refuse a search.
final serviceCategoriesProvider =
    FutureProvider<List<ServiceCategory>>((ref) async {
  final result = await ref.watch(catalogRepositoryProvider).categories();

  return switch (result) {
    ApiSuccess(:final data) =>
      data.where((c) => c.serviceCount > 0).toList(growable: false),
    ApiFailure() => const [],
  };
});
