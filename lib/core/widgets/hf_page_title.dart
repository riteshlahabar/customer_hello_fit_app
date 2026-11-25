import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// The `.eyebrow` / `h1` / `.sub` block under [HFBrandHeader], as pages 27,
/// 40 and 43 all draw it.
///
/// The three differ only in their copy and in whether they carry a button on
/// the title line — page 40's "EDIT PROFILE" — so [sub] and [trailing] are
/// optional rather than there being three near-identical widgets.
///
/// Anton has one weight, so the heading never asks for a bold.
class HFPageTitle extends StatelessWidget {
  const HFPageTitle({
    super.key,
    required this.eyebrow,
    required this.title,
    this.sub,
    this.trailing,
    this.titleSize = 32,
  });

  final String eyebrow;
  final String title;

  /// The design's `.sub` line. Page 40 has none.
  final String? sub;

  /// A control on the title row, right-aligned. Page 40's edit button.
  final Widget? trailing;

  /// Page 27 sets its `h1` a shade larger than pages 40 and 43 (31px).
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.7,
            color: HFColors.primary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontFamily: HFFonts.display,
            fontWeight: FontWeight.w400,
            fontSize: titleSize,
            color: HFColors.ink,
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        if (trailing == null)
          heading
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [Expanded(child: heading), trailing!],
          ),
        if (sub != null) ...[
          const SizedBox(height: 5),
          Text(
            sub!,
            style: const TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 11,
              height: 1.6,
              color: HFColors.muted,
            ),
          ),
        ],
        const SizedBox(height: 15),
      ],
    );
  }
}
