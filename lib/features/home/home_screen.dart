import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/customer_tab.dart';
import '../../core/theme/tokens.dart';
import 'home_controller.dart';
import 'widgets/home_categories.dart';
import 'widgets/home_greeting.dart';
import 'widgets/home_header.dart';
import 'widgets/home_hero.dart';
import 'widgets/home_promo.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/home_section_head.dart';
import 'widgets/home_trainers.dart';

/// Page 09, the home dashboard — the first screen behind the OTP.
///
/// The design's `.screen` scrolls the header away with the content, so there
/// is no AppBar; `CustomerShell` supplies the bottom nav and the ivory
/// ground. Every section is its own widget under `widgets/`, in the design's
/// order: header, greeting, location, search, hero, services, promo,
/// trainers.
///
/// **Six of the design's links have nowhere to go yet** — pages 10, 11, 12,
/// 14, 15 and 44 are unbuilt. Each one switches to the Explore tab rather
/// than opening a screen this flow invented; they get their real destination
/// as flow 2 lands.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void toExplore() =>
        ref.read(customerTabProvider.notifier).select(CustomerTab.explore);

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: HFColors.primary,
        onRefresh: () => refreshHome(ref),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(19, 0, 19, HFSpacing.lg),
          children: [
            const HomeHeader(),
            const HomeGreeting(),
            HomeSearchBar(onTap: toExplore),
            HomeHero(onExplore: toExplore),
            HomeSectionHead(
              title: 'EXPLORE SERVICES',
              actionLabel: 'View all',
              onAction: toExplore,
            ),
            HomeCategories(onSelect: (_) => toExplore()),
            HomePromo(onTap: toExplore),
            HomeSectionHead(
              title: 'TOP TRAINERS',
              actionLabel: 'See all',
              onAction: toExplore,
            ),
            HomeTrainers(onSelect: (_) => toExplore()),
          ],
        ),
      ),
    );
  }
}
