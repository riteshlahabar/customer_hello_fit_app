import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../providers/data/provider_models.dart';

/// Page 09's `.trainer` card. Lifted out of the rail because page 14 Trainer
/// Listing and page 43 Saved Trainers draw the same card.
class TrainerCard extends StatelessWidget {
  const TrainerCard({super.key, required this.trainer, required this.onTap});

  final ProviderSummary trainer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        width: 126,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: HFColors.cardFill,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: HFColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Photo(trainer: trainer),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trainer.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: HFFonts.body,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: HFColors.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: HFFonts.body,
                      fontSize: 8,
                      color: HFColors.softMuted,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _Rating(trainer: trainer),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// `.trainer-info small` — the design's "Strength · Fitness". The real
  /// categories when there are any; the headline, then the years, as the
  /// fallbacks, since a brand-new provider has no category line yet.
  String get _subtitle {
    if (trainer.categories.isNotEmpty) {
      return trainer.categories.take(2).map((c) => c.name).join(' · ');
    }
    if (trainer.headline case final headline? when headline.isNotEmpty) {
      return headline;
    }

    return '${trainer.experienceYears} yrs experience';
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.trainer});

  final ProviderSummary trainer;

  @override
  Widget build(BuildContext context) {
    final url = trainer.photoUrl;
    final placeholder = Container(
      color: HFColors.taupe,
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 32, color: Colors.white),
    );

    return SizedBox(
      height: 91,
      width: double.infinity,
      child: url == null || url.isEmpty
          ? placeholder
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => placeholder,
            ),
    );
  }
}

/// `.rating`. A provider with no published reviews shows "New" rather than a
/// 0.0 — `rating` is 0 until somebody reviews, and 0.0 reads as a bad score.
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
        const Icon(Icons.star_rounded, size: 11, color: HFColors.ratingStar),
        const SizedBox(width: 2),
        Text(
          trainer.rating.toStringAsFixed(1),
          style: const TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 8.5,
            fontWeight: FontWeight.w700,
            color: HFColors.ratingStar,
          ),
        ),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            '· ${trainer.ratingCount} reviews',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 8,
              color: HFColors.faintMuted,
            ),
          ),
        ),
      ],
    );
  }
}
