import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/widgets/pending_screen.dart';
import '../../../core/theme/tokens.dart';
import '../saved_controller.dart';
import '../saved_trainers_controller.dart';
import 'saved_trainer_card.dart';

/// The cards and the `.empty` note under them.
///
/// Four states where the design draws two. Its `.empty` covers only "no
/// saved trainers match your search", so this adds the two the design cannot
/// express as static HTML: the first load, and a failed read with the
/// backend's own message and a retry. **A signed-in read cannot fail
/// silently** into what looks like "you have saved nobody".
///
/// The empty note also distinguishes "nothing saved yet" from "nothing
/// matches the filter" — the design's single sentence would be wrong in the
/// first case, where there is nothing to search.
class SavedList extends ConsumerWidget {
  const SavedList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(savedTrainersProvider);
    final rows = ref.watch(savedVisibleProvider);

    if (feed.hasError && rows == null) {
      return _Failed(
        message: feed.error.toString(),
        onRetry: () => ref.invalidate(savedTrainersProvider),
      );
    }
    if (rows == null) {
      return const Padding(
        padding: EdgeInsets.only(top: HFSpacing.xl),
        child: Center(child: CircularProgressIndicator(color: HFColors.primary)),
      );
    }
    if (rows.isEmpty) {
      final anySaved = (feed.value ?? const []).isNotEmpty;

      return _Empty(
        message: anySaved
            ? 'No saved trainers match your search.'
            : 'You have not saved any trainers yet. Tap the heart on a '
                'trainer to keep them here.',
      );
    }

    return Column(
      children: [
        for (final trainer in rows)
          SavedTrainerCard(
            trainer: trainer,
            // One write path for both screens: the ids notifier owns the
            // call, and its idempotent toggle is what makes a double tap
            // safe. `savedVisibleProvider` filters on that same set, so the
            // card leaves on the tap and comes back if the write is refused.
            //
            // The design's confirm dialog is deliberately not drawn: a
            // JS `confirm()` has no Material equivalent that is not a new
            // screen element, and the write is one tap to undo.
            onUnsave: () =>
                ref.read(savedTrainerIdsProvider.notifier).toggle(trainer.id),
            // Page 15 Trainer Profile is unbuilt, so the card and its
            // VIEW PROFILE button both say so rather than lead nowhere.
            onOpen: () => PendingScreen.push(
              context,
              title: trainer.name,
              designPage: 'Page 15 Trainer Profile',
            ),
          ),
      ],
    );
  }
}

/// `.empty`.
class _Empty extends StatelessWidget {
  const _Empty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: HFFonts.body,
          fontSize: 9,
          height: 1.7,
          color: HFColors.muted,
        ),
      ),
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: HFSpacing.md),
      padding: const EdgeInsets.all(HFSpacing.md),
      decoration: BoxDecoration(
        color: HFColors.panelSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HFColors.cardLine),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 10,
              height: 1.6,
              color: HFColors.muted,
            ),
          ),
          const SizedBox(height: HFSpacing.sm),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              'Try again',
              style: TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: HFColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
