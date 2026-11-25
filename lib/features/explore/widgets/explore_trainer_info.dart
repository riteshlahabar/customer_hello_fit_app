import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../providers/data/provider_models.dart';
import 'explore_trainer_price_row.dart';

/// `.card-info` — the right-hand column of page 10's result card.
///
/// Split out of `ExploreTrainerTile` to keep both files inside the 200-line
/// rule; it is only ever drawn inside that card.
class ExploreTrainerInfo extends StatelessWidget {
  const ExploreTrainerInfo({
    super.key,
    required this.trainer,
    required this.saved,
    required this.onToggleSaved,
    required this.onOpen,
  });

  final ProviderSummary trainer;
  final bool saved;
  final VoidCallback onToggleSaved;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NameRow(
            trainer: trainer,
            saved: saved,
            onToggleSaved: onToggleSaved,
          ),
          const SizedBox(height: 3),
          Text(
            _speciality,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 8,
              color: HFColors.softMuted,
            ),
          ),
          const SizedBox(height: 7),
          _Rating(trainer: trainer),
          const SizedBox(height: 6),
          // `.meta`. The design's second cell, "2.5 km away", has no field
          // behind it; the years are the one fact the card can state.
          Text(
            '${trainer.experienceYears} yrs exp. · '
            '${trainer.serviceCount} services',
            style: const TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 7,
              color: HFColors.softMuted,
            ),
          ),
          const SizedBox(height: 9),
          ExploreTrainerPriceRow(trainer: trainer, onOpen: onOpen),
        ],
      ),
    );
  }

  /// `.speciality` — "Personal Trainer · Strength" in the design.
  String get _speciality {
    if (trainer.specialisations.isNotEmpty) {
      return trainer.specialisations.take(2).join(' · ');
    }
    if (trainer.categories.isNotEmpty) {
      return trainer.categories.take(2).map((c) => c.name).join(' · ');
    }

    return trainer.headline ?? 'HelloFit trainer';
  }
}

class _NameRow extends StatelessWidget {
  const _NameRow({
    required this.trainer,
    required this.saved,
    required this.onToggleSaved,
  });

  final ProviderSummary trainer;
  final bool saved;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            trainer.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1.35,
              color: HFColors.ink,
            ),
          ),
        ),
        Semantics(
          button: true,
          label: saved ? 'Remove from saved' : 'Save trainer',
          child: InkWell(
            onTap: onToggleSaved,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(
                saved ? Icons.favorite : Icons.favorite_border,
                size: 17,
                color: saved ? HFColors.primary : HFColors.faintMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// `.rating`. "New" rather than 0.0 before anyone has reviewed — the same
/// rule page 09's rail card applies.
class _Rating extends StatelessWidget {
  const _Rating({required this.trainer});

  final ProviderSummary trainer;

  @override
  Widget build(BuildContext context) {
    if (!trainer.hasReviews) {
      return const Text(
        'New on HelloFit',
        style: TextStyle(
          fontFamily: HFFonts.body,
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: HFColors.softMuted,
        ),
      );
    }

    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 10, color: HFColors.ratingStar),
        const SizedBox(width: 2),
        Text(
          trainer.rating.toStringAsFixed(1),
          style: const TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: HFColors.ratingStar,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          '(${trainer.ratingCount} reviews)',
          style: const TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 8,
            color: HFColors.faintMuted,
          ),
        ),
      ],
    );
  }
}

