import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/hf_logo.dart';
import '../explore_controller.dart';

/// Page 10's `.header` and `.title-row`.
///
/// **The design's `.back` circle is left out.** Explore is a tab of
/// `CustomerShell`, so there is nothing behind it to go back to; the design
/// drew page 10 as a pushed route reached from page 09's search box, which
/// the shell's bottom nav replaced. The same omission page 09 makes.
class ExploreHeader extends ConsumerWidget {
  const ExploreHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(exploreResultsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 9, bottom: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: HFLogo(height: 40),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(child: _Title()),
              // `.result-count`. Blank while the first search is in flight —
              // a count that flickers from stale to new reads as a bug.
              Text(
                switch (results) {
                  AsyncData(:final value) => '${value.total} trainers',
                  _ => '',
                },
                style: const TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 9,
                  color: HFColors.faintMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FIND YOUR FIT',
          style: TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: HFColors.muted,
          ),
        ),
        const SizedBox(height: HFSpacing.xs),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: HFFonts.display,
              fontWeight: FontWeight.w400,
              fontSize: 28,
              height: 1.05,
              letterSpacing: 0.3,
              color: HFColors.ink,
            ),
            children: [
              TextSpan(text: 'SEARCH '),
              TextSpan(
                text: 'TRAINERS',
                style: TextStyle(color: HFColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
