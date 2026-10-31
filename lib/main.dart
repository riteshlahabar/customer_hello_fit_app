import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/shells.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_controller.dart';
import 'features/auth/data/auth_models.dart';
import 'features/auth/login_screen.dart';

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

/// Picks the shell from the auth state (spec 6.1): the role on the token
/// decides which of the two bottom-navigation bars loads.
class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);

    return switch (state) {
      AuthLoading() => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      AuthSignedOut() => const LoginScreen(),
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
