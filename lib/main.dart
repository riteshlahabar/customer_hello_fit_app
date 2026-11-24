import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/shells.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_controller.dart';
import 'features/auth/data/auth_models.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/onboarding/onboarding_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: HelloFitApp()));
}

class HelloFitApp extends StatelessWidget {
  const HelloFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HelloFit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const _AuthGate(),
    );
  }
}

/// The single place that decides which screen is the root. Pages 01-07 are
/// all reached from here except the OTP step, which the login screen pushes
/// so that "Edit" and the back gesture mean the same thing.
class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);

    return switch (state) {
      AuthLoading() => const SplashScreen(),
      AuthNeedsOnboarding() => const OnboardingScreen(),
      AuthSignedOut() => const LoginScreen(),
      AuthNeedsRegistration(:final user) =>
        RegisterScreen(mobile: user.mobile),
      AuthNeedsModeChoice() => const ModeChooserScreen(),
      AuthSignedIn(:final mode) => mode == AppMode.instructor
          ? const ScaffoldWithBottomNav(
              tabs: instructorTabs,
              title: 'HelloFit Teacher',
            )
          : const ScaffoldWithBottomNav(
              tabs: customerTabs,
              title: 'HelloFit',
            ),
    };
  }
}
