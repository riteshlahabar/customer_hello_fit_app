import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../providers/data/provider_models.dart';
import 'saved_trainer_price_row.dart';

/// `.details` — the right-hand column of page 43's card.
///
/// Split out of [SavedTrainerCard] to keep both files inside the 200-line
/// rule; it is only ever drawn inside that card.
class SavedTrainerDetails extends StatelessWidget {
  const SavedTrainerDetails({
    super.key,
    required this.trainer,
    required this.onUnsave,
    required this.onOpen,
  });

  final ProviderSummary trainer;
  final VoidCallback onUnsave;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TopRow(name: trainer.name, onUnsave: onUnsave),
        const SizedBox(height: 3),
        Text(
          _speciality,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 8,
            color: HFColors.muted,
          ),
        ),
        const SizedBox(height: 5),
        _Rating(trainer: trainer),
        const SizedBox(height: 9),
        SavedTrainerPriceRow(price: trainer.fromPrice, onOpen: onOpen),
      ],
    );
  }

  /// `.details small` — "Personal Trainer · Strength" in the design. The same
  /// fallback order page 10's card uses, so one provider reads the same on
  /// both screens.
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

class _TopRow extends StatelessWidget {
  const _TopRow({required this.name, required this.onUnsave});

  final String name;
  final VoidCallback onUnsave;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1.35,
              color: HFColors.ink,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Semantics(
          button: true,
          label: 'Remove from saved',
          child: InkWell(
            onTap: onUnsave,
            customBorder: const CircleBorder(),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.favorite,
                size: 18,
                color: HFColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// `.rating`. "New on HelloFit" rather than 0.0 before anyone has reviewed —
/// the same rule pages 09 and 10 apply, because `rating` is 0 until the first
/// published review and 0.0 reads as a bad score.
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
          color: HFColors.muted,
        ),
      );
    }

    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontFamily: HFFonts.body,
          fontSize: 8,
          color: HFColors.savedRatingInk,
        ),
        children: [
          TextSpan(text: '★ ${trainer.rating.toStringAsFixed(1)} '),
          TextSpan(
            text: '(${trainer.ratingCount} reviews)',
            style: const TextStyle(color: HFColors.muted),
          ),
        ],
      ),
    );
  }
}

