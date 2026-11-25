import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// Page 09's `.section-head` — an Anton title with a small orange link on the
/// right. Used twice on the dashboard ("EXPLORE SERVICES / View all" and
/// "TOP TRAINERS / See all") and again by the later list screens.
class HomeSectionHead extends StatelessWidget {
  const HomeSectionHead({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: HFFonts.display,
                fontWeight: FontWeight.w400,
                fontSize: 19,
                letterSpacing: 0.2,
                color: HFColors.ink,
              ),
            ),
          ),
          InkWell(
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: HFSpacing.xs,
                vertical: HFSpacing.xs,
              ),
              child: Text(
                actionLabel,
                style: const TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: HFColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
