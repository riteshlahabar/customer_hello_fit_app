import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// One run of a display heading. The designs mix ink and orange inside a
/// single headline, and not always in the same order — page 05 is
/// `LET'S GET <span>MOVING.</span>` but page 03 is
/// `YOUR GOAL. <span>YOUR KIND</span> OF FIT.` — so the runs are listed
/// explicitly rather than guessed from a split.
class HFHeadingRun {
  const HFHeadingRun(this.text) : accent = false;
  const HFHeadingRun.accent(this.text) : accent = true;

  final String text;
  final bool accent;
}

/// The Anton headline that opens nearly every screen in the design set.
class HFDisplayHeading extends StatelessWidget {
  const HFDisplayHeading({
    super.key,
    required this.runs,
    this.fontSize = 35,
    this.align = TextAlign.left,
  });

  final List<HFHeadingRun> runs;

  /// 34-37px across the design set; the default matches the login screen.
  final double fontSize;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontFamily: HFFonts.display,
          fontWeight: FontWeight.w400,
          color: HFColors.ink,
          letterSpacing: 0.3,
          height: 1.05,
          fontSize: fontSize,
        ),
        children: [
          for (final run in runs)
            TextSpan(
              text: run.text,
              style: run.accent
                  ? const TextStyle(color: HFColors.primary)
                  : null,
            ),
        ],
      ),
      textAlign: align,
    );
  }
}

/// The small orange all-caps line above a heading — `.kicker` and `.step` in
/// the designs, which share one style at two sizes.
class HFKicker extends StatelessWidget {
  const HFKicker(this.text, {super.key, this.align = TextAlign.left});

  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: align,
      style: const TextStyle(
        fontFamily: HFFonts.body,
        fontSize: 9,
        height: 1.4,
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
        color: HFColors.primary,
      ),
    );
  }
}
