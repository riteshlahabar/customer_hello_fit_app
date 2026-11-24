import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import '../../core/widgets/hf_logo.dart';

/// Page 01. The branded hold while [AuthController] decides where to go:
/// onboarding, login, the registration form, or straight into the app.
///
/// It owns no logic of its own — a splash that could route would be a second
/// place that decides, and the two would drift.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: HFColors.splashBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HFLogo(height: 190, shadow: true),
                  SizedBox(height: 28),
                  Text(
                    'YOUR TIME, YOUR PLACE',
                    style: TextStyle(
                      fontFamily: HFFonts.body,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 44,
              child: Column(
                children: [
                  _PulsingDots(),
                  SizedBox(height: 12),
                  Text(
                    'GETTING YOU MOVING',
                    style: TextStyle(
                      fontFamily: HFFonts.body,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: Color(0xD9FFFFFF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The three dots from the design, each delayed behind the last so the row
/// reads as a wave rather than a blink.
class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++) ...[
          if (i > 0) const SizedBox(width: 7),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              // 0.16s apart, matching the CSS animation-delay steps.
              final t = (_controller.value - i * 0.16) % 1.0;
              // Up over the first 40%, held small for the rest.
              final lift = t < 0.4 ? t / 0.4 : 0.0;
              final scale = 0.65 + 0.35 * lift;

              // Scaled by transform, not by size: the CSS does the same, and
              // resizing the boxes would make the row breathe sideways.
              return SizedBox.square(
                dimension: 7,
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: 0.35 + 0.65 * lift,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
