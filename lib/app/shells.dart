import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/tokens.dart';
import '../features/auth/auth_controller.dart';
import '../features/auth/data/auth_models.dart';

/// A tab definition, so both shells are built from data rather than two
/// hand-written copies of the same widget.
class ShellTab {
  const ShellTab({required this.label, required this.icon, required this.body});

  final String label;
  final IconData icon;
  final Widget body;
}

/// The five Customer tabs (spec 6.2).
const customerTabs = <ShellTab>[
  ShellTab(label: 'Home', icon: Icons.home_outlined, body: _Placeholder('Home')),
  ShellTab(label: 'Book', icon: Icons.search, body: _Placeholder('Book')),
  ShellTab(
    label: 'Bookings',
    icon: Icons.calendar_today_outlined,
    body: _Placeholder('Bookings'),
  ),
  ShellTab(
    label: 'Progress',
    icon: Icons.insights_outlined,
    body: _Placeholder('Progress'),
  ),
  ShellTab(
    label: 'Profile',
    icon: Icons.person_outline,
    body: _Placeholder('Profile'),
  ),
];

/// The five Instructor tabs (spec 6.3).
const instructorTabs = <ShellTab>[
  ShellTab(label: 'Today', icon: Icons.wb_sunny_outlined, body: _Placeholder('Today')),
  ShellTab(
    label: 'Schedule',
    icon: Icons.calendar_month_outlined,
    body: _Placeholder('Schedule'),
  ),
  ShellTab(
    label: 'Requests',
    icon: Icons.inbox_outlined,
    body: _Placeholder('Requests'),
  ),
  ShellTab(
    label: 'Earnings',
    icon: Icons.account_balance_wallet_outlined,
    body: _Placeholder('Earnings'),
  ),
  ShellTab(
    label: 'Profile',
    icon: Icons.person_outline,
    body: _Placeholder('Profile'),
  ),
];

/// One implementation over two tab lists — the tabs differ, every shared card,
/// chip and sheet does not (spec 6.1).
class ScaffoldWithBottomNav extends StatefulWidget {
  const ScaffoldWithBottomNav({
    required this.tabs,
    required this.title,
    super.key,
  });

  final List<ShellTab> tabs;
  final String title;

  @override
  State<ScaffoldWithBottomNav> createState() => _ScaffoldWithBottomNavState();
}

class _ScaffoldWithBottomNavState extends State<ScaffoldWithBottomNav> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      // IndexedStack keeps each tab's scroll position and state across
      // switches, which the schedule and booking lists rely on.
      body: IndexedStack(
        index: _index,
        children: widget.tabs.map((tab) => tab.body).toList(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: widget.tabs
            .map(
              (tab) => NavigationDestination(
                icon: Icon(tab.icon),
                label: tab.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Shown while the design is pending, so the shell and navigation can be
/// verified without inventing a visual design.
class _Placeholder extends StatelessWidget {
  const _Placeholder(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(HFSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: HFSpacing.sm),
            const Text(
              'Awaiting design',
              style: TextStyle(color: HFColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Continue as" chooser for an account that is both a customer and an
/// approved teacher (spec 6.1).
class ModeChooserScreen extends ConsumerWidget {
  const ModeChooserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(authControllerProvider.notifier);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(HFSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Continue as',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: HFSpacing.lg),
              ElevatedButton(
                onPressed: () => controller.setMode(AppMode.customer),
                child: const Text('Customer'),
              ),
              const SizedBox(height: HFSpacing.md),
              ElevatedButton(
                onPressed: () => controller.setMode(AppMode.instructor),
                child: const Text('Yoga Teacher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
