import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../saved_controller.dart';

/// Page 43's `.filters` rail.
///
/// **The chips are the categories the saved trainers teach**, not
/// `GET /categories` — see [savedCategoryOptionsProvider] for why. The rail
/// hides itself entirely while there is nothing saved, since a lone "All
/// Trainers" chip filters nothing.
///
/// A bare scrolling row, not page 10's panelled rail: this design has no
/// `.filters` plate behind the chips.
class SavedFilterChips extends ConsumerWidget {
  const SavedFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(savedCategoryOptionsProvider);
    if (categories.isEmpty) return const SizedBox.shrink();

    final active = ref.watch(savedCategoryProvider);
    final select = ref.read(savedCategoryProvider.notifier).select;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: selected ? HFColors.primary : HFColors.panelSoft,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? HFColors.primary : HFColors.cardLine,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : HFColors.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
