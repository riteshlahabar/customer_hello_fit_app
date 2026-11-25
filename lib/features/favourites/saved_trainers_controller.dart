import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_result.dart';
import '../../core/providers.dart';

/// Which providers carry a filled heart, as a set of ids.
///
/// `GET /favourites/ids` rather than the full cards: page 10 paints a heart on
/// every result and does not need the saved providers' details. Page 43 reads
/// the full cards from `savedTrainersProvider` but shares this notifier, so
/// **every save and unsave in the app goes through [toggle]** — one write
/// path, and the two screens cannot drift apart.
///
/// Fails soft to an empty set — a dead favourites feed must not refuse the
/// search behind it. Both writes are idempotent on the backend, which is what
/// makes the optimistic flip safe: a double tap cannot desynchronise.
class SavedTrainerIds extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final result = await ref.watch(favouriteRepositoryProvider).ids();

    return switch (result) {
      ApiSuccess(:final data) => data.toSet(),
      ApiFailure() => <String>{},
    };
  }

  /// Flips one heart and reconciles with the server.
  ///
  /// The flip is applied first so the icon never lags the tap; a failed write
  /// puts the old set back rather than leaving a heart that lies.
  Future<void> toggle(String instructorId) async {
    final current = state.value ?? const <String>{};
    final wasSaved = current.contains(instructorId);
    final next = {...current};

    if (wasSaved) {
      next.remove(instructorId);
    } else {
      next.add(instructorId);
    }
    state = AsyncData(next);

    final favourites = ref.read(favouriteRepositoryProvider);
    final result = wasSaved
        ? await favourites.remove(instructorId)
        : await favourites.save(instructorId);

    switch (result) {
      case ApiSuccess(:final data):
        // The server's own answer wins: `saved` is the row's state after the
        // write, so an idempotent repeat still lands on the truth.
        final settled = {...next};
        if (data) {
          settled.add(instructorId);
        } else {
          settled.remove(instructorId);
        }
        state = AsyncData(settled);
      case ApiFailure():
        state = AsyncData(current);
    }
  }
}

final savedTrainerIdsProvider =
    AsyncNotifierProvider<SavedTrainerIds, Set<String>>(SavedTrainerIds.new);
