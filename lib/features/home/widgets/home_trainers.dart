import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../providers/data/provider_models.dart';
import '../home_controller.dart';
import 'trainer_card.dart';

/// Page 09's `.trainer-row` — "TOP TRAINERS", a horizontal rail of 126px
/// cards.
///
/// The design's cards are titled with a *service* ("Personal Training") over
/// a category line. The rail is `GET /providers?sort=rating`, whose rows are
/// **people**, so the card is titled with the provider's name and the
/// category line underneath is their real categories. Rating and review count
/// are the row's own `rating` / `ratingCount`.
class HomeTrainers extends ConsumerWidget {
  const HomeTrainers({super.key, required this.onSelect});

  /// Page 15 Trainer Profile is not built yet; a tap goes to Explore for now.
  final ValueChanged<ProviderSummary> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainers = ref.watch(homeTopTrainersProvider);
    final rows = trainers.value ?? const <ProviderSummary>[];

    if (rows.isEmpty) {
      return trainers.isLoading
          ? const _Rail(child: _Skeleton())
          : const SizedBox.shrink();
    }

    return _Rail(
      child: Row(
        children: [
          for (final trainer in rows)
            Padding(
              padding: const EdgeInsets.only(right: 11),
              child: TrainerCard(
                trainer: trainer,
                onTap: () => onSelect(trainer),
              ),
            ),
        ],
      ),
    );
  }
}

/// The scrolling strip itself. The design clips the row at the screen edge;
/// here it scrolls, since a phone has no hover to reveal the rest.
class _Rail extends StatelessWidget {
  const _Rail({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: child,
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < 3; i++)
          Container(
            height: 148,
            width: 126,
            margin: const EdgeInsets.only(right: 11),
            decoration: BoxDecoration(
              color: HFColors.cardFill,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: HFColors.cardBorder),
            ),
          ),
      ],
    );
  }
}
