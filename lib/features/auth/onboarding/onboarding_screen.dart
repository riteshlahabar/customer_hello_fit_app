import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/hf_logo.dart';
import '../auth_controller.dart';
import 'onboarding_slide_view.dart';
import 'onboarding_slides.dart';

/// Pages 02, 03 and 04 — one carousel, not three screens: the designs share
/// a frame and differ only in content.
///
/// The logo, Skip, dots and button sit above the `PageView` so they stay put
/// while the slide moves underneath, which is how the design reads.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pages = PageController();
  int _index = 0;

  static const _cardHeight = 326.0;
  static const _actionsHeight = 46.0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _finish() => ref.read(authControllerProvider.notifier).completeOnboarding();

  void _next() {
    if (_index == onboardingSlides.length - 1) {
      _finish();
      return;
    }

    _pages.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final slide = onboardingSlides[_index];

    return Scaffold(
      backgroundColor: HFColors.ivory,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pages,
            itemCount: onboardingSlides.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) => OnboardingSlideView(
              slide: onboardingSlides[i],
              cardHeight: _cardHeight,
              actionsHeight: _actionsHeight,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const HFLogo(height: 46, shadow: true),
                  _SkipButton(onPressed: _finish),
                ],
              ),
            ),
          ),
          Positioned(
            left: 25,
            right: 25,
            bottom: 22,
            height: _actionsHeight,
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Dots(count: onboardingSlides.length, active: _index),
                  _NextButton(label: slide.buttonLabel, onPressed: _next),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0x38161614),
          border: Border.all(color: const Color(0xA6FFFFFF)),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Text(
          'Skip',
          style: TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 11,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// The active dot stretches into a 21px pill, as the design has it.
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: i == active ? 21 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == active ? HFColors.primary : HFColors.dotInactive,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ],
    );
  }
}

/// Shorter and self-sizing, unlike the full-width button the other screens
/// use, so it cannot be [HFPrimaryButton].
class _NextButton extends StatelessWidget {
  const _NextButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HFRadius.control),
        boxShadow: const [
          BoxShadow(
            color: Color(0x38E33E29),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: HFColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: Size.zero,
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HFRadius.control),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 12),
            const Text('→', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
