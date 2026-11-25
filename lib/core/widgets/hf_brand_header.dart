import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'hf_logo.dart';

/// The 66px brand bar pages 27, 40 and 43 all draw: the supplied mark beside
/// the word "Hello" in orange and "Fit" in ink, over a hairline.
///
/// A lockup drawn as text rather than page 09's wordmark image, which is what
/// those three designs specify. Extracted from `BookingsHeader` when pages 40
/// and 43 turned out to repeat it byte for byte.
///
/// **The design's `.back` circle is deliberately left out.** All three are
/// tabs of `CustomerShell`, so there is nothing behind them to go back to;
/// the designs drew them as pushed routes, which the bottom nav replaced.
class HFBrandHeader extends StatelessWidget {
  const HFBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: HFColors.cardLine)),
      ),
      child: const Row(
        children: [
          HFLogo(height: 29),
          SizedBox(width: HFSpacing.sm),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: HFColors.ink,
              ),
              children: [
                TextSpan(
                  text: 'Hello',
                  style: TextStyle(color: HFColors.primary),
                ),
                TextSpan(text: 'Fit'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
