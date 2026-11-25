import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// Page 09's `.hero`.
///
/// The design lays its scrim over a stock photograph loaded from Unsplash.
/// **No hero image was supplied** in the asset set (only the logo and the
/// three onboarding slides), and the app must not fetch a stock photo at
/// runtime, so the scrim is drawn over ink on its own. Drop a bundled
/// `assets/home/hero.jpg` in behind it and nothing else here changes.
class HomeHero extends StatelessWidget {
  const HomeHero({super.key, required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 177,
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          gradient: const LinearGradient(
            colors: [
              HFColors.heroScrimStrong,
              HFColors.heroScrimMid,
              HFColors.heroScrimFaint,
            ],
            stops: [0, 0.5, 1],
          ),
          color: HFColors.ink,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MAKE TIME FOR YOU',
              style: TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.7,
                color: HFColors.heroKicker,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'YOUR FITNESS.\nYOUR WAY.',
              style: TextStyle(
                fontFamily: HFFonts.display,
                fontWeight: FontWeight.w400,
                fontSize: 27,
                height: 1.06,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(
              width: 210,
              child: Text(
                'Find a trainer who fits your goals and your schedule.',
                style: TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 9.5,
                  height: 1.5,
                  color: HFColors.heroBody,
                ),
              ),
            ),
            const Spacer(),
            _HeroButton(onPressed: onExplore),
          ],
        ),
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  const _HeroButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HFColors.primary,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          child: Text(
            'Explore Trainers  →',
            style: TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
