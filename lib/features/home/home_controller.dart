import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_result.dart';
import '../../core/providers.dart';
import '../catalog/catalog_providers.dart';
import '../profile/profile_providers.dart';
import '../providers/data/provider_models.dart';
import '../providers/data/provider_repository.dart';

/// Page 09's own feeds, one provider each.
///
/// The profile and the location label are not here: both are shared with
/// another tab and live in `features/profile/profile_providers.dart`.
///
/// Separate rather than a single state object because the design's sections
/// are independent: a failed trainer rail must not blank the categories, and
/// each section carries its own skeleton. Every one of them is a read the
/// data layer already had — **no new backend** (client, 23-11-2026).
///
/// They all fail soft. A dashboard is not a form: a dead feed hides its
/// section, it does not put an error in front of the customer.

/// `.trainer-row` — "TOP TRAINERS", the rating-sorted first page.
///
/// Ten asked for, so the rail still fills when a few come back without a
/// photo; the design shows three at a time and scrolls.
final homeTopTrainersProvider =
    FutureProvider<List<ProviderSummary>>((ref) async {
  final result = await ref.watch(providerRepositoryProvider).search(
        sort: ProviderSort.rating,
        limit: 10,
      );

  return switch (result) {
    ApiSuccess(:final data) => data,
    ApiFailure() => const [],
  };
});

/// `.dot` — the bell's unread pip. Zero on failure, so a flaky feed never
/// shows a badge that is not there.
final homeUnreadCountProvider = FutureProvider<int>((ref) async {
  final result = await ref.watch(notificationRepositoryProvider).unreadCount();

  return switch (result) {
    ApiSuccess(:final data) => data,
    ApiFailure() => 0,
  };
});

/// Pull-to-refresh: every feed at once.
Future<void> refreshHome(WidgetRef ref) async {
  ref.invalidate(serviceCategoriesProvider);
  ref.invalidate(homeTopTrainersProvider);
  ref.invalidate(customerProfileProvider);
  ref.invalidate(defaultLocationLabelProvider);
  ref.invalidate(homeUnreadCountProvider);

  await Future.wait([
    ref.read(serviceCategoriesProvider.future),
    ref.read(homeTopTrainersProvider.future),
  ]);
}
