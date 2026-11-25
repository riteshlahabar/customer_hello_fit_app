import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/widgets/pending_screen.dart';
import '../../../core/theme/tokens.dart';
import '../../favourites/saved_trainers_controller.dart';
import '../explore_controller.dart';
import 'explore_trainer_tile.dart';

/// `#trainerList` and the `.empty-note` under it.
///
/// Three states the design draws one of: the cards, "No trainers match your
/// search", and — added, because the design has no such state and a search
/// cannot stay silent — the backend's own message with a retry. A refiltered
/// search keeps the old cards on screen while the new page loads, so the
/// list does not blink on every chip tap.
class ExploreResults extends ConsumerWidget {
  const ExploreResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(exploreResultsProvider);
    final saved = ref.watch(savedTrainerIdsProvider).value ?? const <String>{};
    final rows = results.value?.rows;

    if (results.hasError && rows == null) {
      return _Failed(
        message: results.error.toString(),
        onRetry: () => ref.invalidate(exploreResultsProvider),
      );
    }
    if (rows == null) {
      return const Padding(
        padding: EdgeInsets.only(top: HFSpacing.xl),
        child: Center(
          child: CircularProgressIndicator(color: HFColors.primary),
        ),
      );
    }
    if (rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 24),
        child: Text(
          'No trainers match your search.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 9,
            color: HFColors.faintMuted,
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final trainer in rows)
          ExploreTrainerTile(
            trainer: trainer,
            saved: saved.contains(trainer.id),
            onToggleSaved: () => ref
                .read(savedTrainerIdsProvider.notifier)
                .toggle(trainer.id),
            // Page 15 Trainer Profile is unbuilt, so both the card and its
            // "View Profile" button say so rather than lead nowhere.
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
