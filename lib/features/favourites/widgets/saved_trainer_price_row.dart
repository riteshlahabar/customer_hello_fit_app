import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// `.bottom` — the foot of page 43's card: the price and VIEW PROFILE.
///
/// Its own file to keep `saved_trainer_details.dart` inside the 200-line rule,
/// the same split page 10's card makes with `explore_trainer_price_row.dart`.
class SavedTrainerPriceRow extends StatelessWidget {
  const SavedTrainerPriceRow({
    super.key,
    required this.price,
    required this.onOpen,
  });

  /// `fromPrice`, the cheapest approved service, so the figure is a "from"
  /// and not a rate — the design's "/ session" keeps that qualifier. A row
  /// that came back without prices shows the button alone rather than a ₹0,
  /// which would read as free.
  final double? price;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (price != null)
          Expanded(
            child: Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: HFColors.ink,
                ),
                children: [
                  TextSpan(text: 'From ₹${price!.round()} '),
                  const TextSpan(
                    text: '/ session',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: HFColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          const Spacer(),
        InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(9),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: HFColors.searchFill,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Text(
              'VIEW PROFILE',
              style: TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: HFColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
