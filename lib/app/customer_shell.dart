import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/tokens.dart';
import '../features/booking/bookings_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/favourites/saved_screen.dart';
import '../features/home/home_screen.dart';
import '../features/profile/profile_screen.dart';
import 'customer_tab.dart';
import 'widgets/hf_bottom_nav.dart';

/// The customer app's internal shell — everything behind the OTP.
///
/// No `AppBar`: page 09 draws its own header (logo, bell, profile) and
/// scrolls it away with the rest of the content, which an AppBar cannot do.
/// Each later tab draws its own header the same way.
class CustomerShell extends ConsumerWidget {
  const CustomerShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(customerTabProvider);

    return Scaffold(
      backgroundColor: HFColors.ivory,
      // IndexedStack so a tab keeps its scroll offset and in-flight loads
      // across a switch — the bookings and explore lists depend on it.
      body: IndexedStack(
        index: current.index,
        children: [
          for (final tab in CustomerTab.values) _TabBody(tab),
        ],
      ),
      bottomNavigationBar: HFBottomNav(
        current: current,
        onSelect: ref.read(customerTabProvider.notifier).select,
      ),
    );
  }
}

class _TabBody extends StatelessWidget {
  const _TabBody(this.tab);

  final CustomerTab tab;

  @override
  Widget build(BuildContext context) {
    // Exhaustive since 24-11-2026: all five designed tabs are built, so
    // `PendingTab` is gone. `PendingScreen` stays for the pushed routes
    // whose designs are still outstanding.
    return switch (tab) {
      CustomerTab.home => const HomeScreen(),
      CustomerTab.explore => const ExploreScreen(),
      CustomerTab.bookings => const BookingsScreen(),
      CustomerTab.saved => const SavedScreen(),
      CustomerTab.profile => const ProfileScreen(),
    };
  }
}
