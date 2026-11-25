import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../providers/data/provider_repository.dart';
import '../explore_controller.dart';

/// Page 10's `.sort-row` — "Recommended trainers" and the sort button.
///
/// The design's button toggles between two labels (Recommended / Top Rated).
/// `GET /providers` sorts by `rating`, `price` or `experience`, so the control
/// is a menu over those three plus the design's default rather than a toggle
/// that would reach only one of them. The orders are the API's; none is
/// invented.
///
/// `price` orders the page by a derived "from" figure, which is why the menu
/// says "from price" rather than implying a fixed rate.
class ExploreSortRow extends ConsumerWidget {
  const ExploreSortRow({super.key});

  static const _labels = {
    ProviderSort.rating: 'Top rated',
    ProviderSort.price: 'Lowest from price',
    ProviderSort.experience: 'Most experienced',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(exploreSortProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 1, right: 1, bottom: 11),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Recommended trainers',
              style: TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: HFColors.ink,
              ),
            ),
          ),
          PopupMenuButton<ProviderSort?>(
            initialValue: sort,
            tooltip: 'Sort results',
            color: HFColors.panelSoft,
            onSelected: ref.read(exploreSortProvider.notifier).select,
            itemBuilder: (_) => [
              const PopupMenuItem(value: null, child: Text('Recommended')),
              for (final entry in _labels.entries)
                PopupMenuItem(value: entry.key, child: Text(entry.value)),
            ],
            child: Row(
              children: [
                Text(
                  'Sort: ${sort == null ? 'Recommended' : _labels[sort]}',
                  style: const TextStyle(
                    fontFamily: HFFonts.body,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: HFColors.actionInk,
                  ),
                ),
                const Icon(
                  Icons.expand_more,
                  size: 14,
                  color: HFColors.actionInk,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
