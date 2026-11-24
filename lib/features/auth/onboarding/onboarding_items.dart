import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import 'onboarding_slides.dart';

/// The three boxes above the dots. Page 02 lists ticks in a row; pages 03
/// and 04 use a three-column grid of symbol tiles.
class OnboardingItems extends StatelessWidget {
  const OnboardingItems({super.key, required this.slide});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    if (!slide.itemsAreTiles) {
      return Wrap(
        spacing: 13,
        runSpacing: 8,
        children: [for (final item in slide.items) _TickChip(label: item.label)],
      );
    }

    return Row(
      children: [
        for (final item in slide.items) ...[
          if (item != slide.items.first) const SizedBox(width: 8),
          Expanded(child: _Tile(item: item)),
        ],
      ],
    );
  }
}

class _TickChip extends StatelessWidget {
  const _TickChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 17,
          height: 17,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: HFColors.checkWash,
            shape: BoxShape.circle,
          ),
          child: const Text(
            '✓',
            style: TextStyle(fontSize: 10, color: HFColors.primary),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: HFColors.labelInk,
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.item});

  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: HFColors.hairline),
        borderRadius: BorderRadius.circular(HFRadius.control),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.symbol ?? '',
            style: const TextStyle(
              fontSize: 18,
              height: 1,
              color: HFColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: HFColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
