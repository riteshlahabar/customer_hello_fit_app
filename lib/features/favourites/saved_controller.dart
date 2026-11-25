import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_result.dart';
import '../../core/providers.dart';
import '../providers/data/provider_models.dart';
import 'saved_trainers_controller.dart';

/// Page 43's feed and its two controls.
///
/// **The search and the chips filter locally, unlike page 10's.** That is the
/// design: `applyFilters()` hides cards over a `data-search` attribute and
/// never re-queries. It is also the only thing the API allows —
/// `GET /favourites` takes no `q` and no `categoryId`, and returns the whole
/// saved list in one response, so there is nothing to page and nothing to ask
/// the server. **Do not "fix" this into a server-side search**; it would need
/// new backend, which the client ruled out on 23-11-2026.
///
/// So there is no debounce here either: filtering a list already in memory on
/// every keystroke costs nothing, and the 350 ms page 10 waits exists only to
/// spare the API.

/// What the customer typed into `.search`.
class SavedQuery extends Notifier<String> {
  @override
  String build() => '';

  void set(String value) => state = value;
}

final savedQueryProvider =
    NotifierProvider<SavedQuery, String>(SavedQuery.new);

/// The active `.filter`. Null is "All Trainers", the design's default.
class SavedCategory extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? categoryId) => state = categoryId;
}

final savedCategoryProvider =
    NotifierProvider<SavedCategory, String?>(SavedCategory.new);

/// Carries the backend's own message to the retry line.
class SavedTrainersFailed implements Exception {
  const SavedTrainersFailed(this.message);

  final String message;

  @override
  String toString() => message;
}

/// `GET /favourites` — the saved cards, each with its `savedAt`.
///
/// **Shown on failure, not hidden.** A dashboard section may fail soft; this
/// screen is nothing but this list, and an empty list would claim the customer
/// has saved nobody.
///
/// It watches [savedTrainerIdsProvider] so that a heart tapped over on
/// Explore brings that trainer's card into this tab: `CustomerShell` is an
/// `IndexedStack` and keeps this list alive, so without the dependency the tab
/// would still be showing the list as it stood at launch. An unsave refetches
/// too, which is one spare request in exchange for never being stale — and the
/// card has already gone from view by then, because [savedVisibleProvider]
/// filters on the ids rather than waiting for the reply.
final savedTrainersProvider =
    FutureProvider<List<ProviderSummary>>((ref) async {
  ref.watch(savedTrainerIdsProvider);

  final result = await ref.watch(favouriteRepositoryProvider).list();

  return switch (result) {
    ApiSuccess(:final data) => data,
    ApiFailure(:final message) => throw SavedTrainersFailed(message),
  };
});

/// The `.filter` rail — **the categories the saved trainers actually teach**,
/// in first-seen order, not `GET /categories`.
///
/// The design hard-codes Strength / Yoga / Cardio. Drawing every live category
/// instead would put chips on screen that can only ever filter to nothing,
/// because this list is three or four people, not the whole catalogue.
final savedCategoryOptionsProvider =
    Provider<List<({String id, String name})>>((ref) {
  final rows = ref.watch(savedTrainersProvider).value ?? const [];
  final seen = <String>{};

  return [
    for (final trainer in rows)
      for (final category in trainer.categories)
        if (seen.add(category.id)) category,
  ];
});

/// The cards to draw: saved, matching the chip, matching the query.
///
/// Null while the first load is in flight, so the list can tell "not yet"
/// from "none match".
///
/// The ids filter is what makes an unsave instant — the row leaves on the tap
/// rather than on the server's reply — and self-correcting, because a refused
/// write puts the id back and the card returns with it.
final savedVisibleProvider = Provider<List<ProviderSummary>?>((ref) {
  final rows = ref.watch(savedTrainersProvider).value;
  if (rows == null) return null;

  final saved = ref.watch(savedTrainerIdsProvider).value;
  final categoryId = ref.watch(savedCategoryProvider);
  final query = ref.watch(savedQueryProvider).trim().toLowerCase();

  return [
    for (final trainer in rows)
      // A null ids set means that feed has not answered; every saved row is
      // then shown, since this list came from `/favourites` in the first place.
      if (saved == null || saved.contains(trainer.id))
        if (categoryId == null ||
            trainer.categories.any((c) => c.id == categoryId))
          if (query.isEmpty || _matches(trainer, query)) trainer,
  ];
});

/// The design's `data-search` attribute: the name plus the specialities and
/// categories under it, which is exactly what the card puts on screen.
bool _matches(ProviderSummary trainer, String query) {
  final haystack = [
    trainer.name,
    ...trainer.specialisations,
    ...trainer.categories.map((c) => c.name),
    if (trainer.headline != null) trainer.headline!,
  ].join(' ').toLowerCase();

  return haystack.contains(query);
}
