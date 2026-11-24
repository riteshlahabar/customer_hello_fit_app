import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/hf_display_heading.dart';
import 'onboarding_items.dart';
import 'onboarding_slides.dart';

/// One slide: the photograph with its gradient, and the ivory card over it.
///
/// The card's actions row (dots and button) is NOT built here — it is passed
/// in and stays fixed in [OnboardingScreen], so it does not slide away with
/// the page while the customer is reaching for it.
class OnboardingSlideView extends StatelessWidget {
  const OnboardingSlideView({
    super.key,
    required this.slide,
    required this.cardHeight,
    required this.actionsHeight,
  });

  final OnboardingSlide slide;
  final double cardHeight;

  /// Space left clear at the foot of the card for the fixed actions row.
  final double actionsHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _Photo(slide: slide, bottomInset: cardHeight - 28),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: cardHeight,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(25, 25, 25, 22 + actionsHeight),
            decoration: const BoxDecoration(
              color: HFColors.ivory,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HFKicker(slide.kicker),
                const SizedBox(height: 9),
                HFDisplayHeading(runs: slide.heading, fontSize: 36),
                const SizedBox(height: 10),
                Flexible(
                  child: Text(
                    slide.description,
                    style: const TextStyle(
                      fontFamily: HFFonts.body,
                      fontSize: 11.5,
                      height: 1.7,
                      color: HFColors.bodyMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OnboardingItems(slide: slide),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.slide, required this.bottomInset});

  final OnboardingSlide slide;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: bottomInset,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            slide.image,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.16),
            errorBuilder: (_, _, _) => const ColoredBox(color: HFColors.ink),
          ),
          // Darkened at the top so the white logo and Skip pill stay readable
          // whatever the photograph happens to do behind them.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x7A000000),
                  Color(0x05000000),
                  Color(0x40000000),
                ],
                stops: [0, 0.4, 1],
              ),
            ),
          ),
          if (slide.photoTag != null)
            Positioned(
              left: 24,
              right: 24,
              bottom: 27,
              child: Text(
                slide.photoTag!.toUpperCase(),
                style: const TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
