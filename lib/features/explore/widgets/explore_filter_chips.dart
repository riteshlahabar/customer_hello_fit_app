import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../catalog/catalog_providers.dart';
import '../explore_controller.dart';

/// Page 10's `.filters` rail.
///
/// The design hard-codes All Trainers / Personal Training / Yoga / Pilates /
/// Strength; the real chips are `GET /categories` in the admin's order, with
/// "All Trainers" first as the design's default. Picking one sends
/// `categoryId` to the search — so a chip filters server-side, not in the
/// list that is already on screen.
///
/// One chip at a time: `search` takes a list, but the design's rail shows a
/// single `.active`, and page 11 Search Filters is where multi-select belongs.
class ExploreFilterChips extends ConsumerWidget {
  const ExploreFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(serviceCategoriesProvider).value ?? const [];
    final active = ref.watch(exploreCategoryProvider);
    final select = ref.read(exploreCategoryProvider.notifier).select;

    return Container(
      margin: const EdgeInsets.only(top: 14, bottom: 13),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: BoxDecoration(
        color: HFColors.filterPanel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HFColors.cardBorder),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _Chip(
              label: 'All Trainers',
              selected: active == null,
              onTap: () => select(null),
            ),
            for (final category in categories)
              _Chip(
                label: category.name,
                selected: active == category.id,
                onTap: () => select(category.id),
              ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: Semantics(
        button: true,
        selected: selected,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? HFColors.primary : HFColors.panelSoft,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? HFColors.primary : HFColors.chipBorder,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : HFColors.chipInk,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
