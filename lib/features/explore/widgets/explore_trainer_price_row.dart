import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../providers/data/provider_models.dart';

/// `.price-row` — the foot of page 10's result card.
///
/// The figure is `fromPrice`, the cheapest approved service, so it is a
/// "from" and not a rate; the design's "/ session" keeps that qualifier. A
/// row that came back without prices shows the button alone rather than a ₹0,
/// which would read as free.
class ExploreTrainerPriceRow extends StatelessWidget {
  const ExploreTrainerPriceRow({
    super.key,
    required this.trainer,
    required this.onOpen,
  });

  final ProviderSummary trainer;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final price = trainer.fromPrice;

    return Row(
      children: [
        if (price != null)
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: HFColors.ink,
                ),
                children: [
                  TextSpan(text: 'From ₹${price.round()} '),
                  const TextSpan(
                    text: '/ session',
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w400,
                      color: HFColors.softMuted,
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
          borderRadius: BorderRadius.circular(7),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: HFColors.viewWash,
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Text(
              'View Profile',
              style: TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: HFColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
