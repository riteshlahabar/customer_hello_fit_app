import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import '../customer_tab.dart';

/// Page 09's `.bottom-nav`: a 72px white bar on a hairline, five evenly
/// spaced items, the active one orange.
///
/// Hand-drawn rather than a Material `NavigationBar` because the design has
/// no pill indicator, a 7px label and its own icon sizing — overriding all
/// three on `NavigationBar` is more code than the row itself.
class HFBottomNav extends StatelessWidget {
  const HFBottomNav({super.key, required this.current, required this.onSelect});

  final CustomerTab current;
  final ValueChanged<CustomerTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: HFColors.navBorder)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (final tab in CustomerTab.values)
                Expanded(
                  child: _NavItem(
                    tab: tab,
                    active: tab == current,
                    onTap: () => onSelect(tab),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final CustomerTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colour = active ? HFColors.primary : HFColors.navInactive;

    return InkWell(
      onTap: onTap,
      child: Semantics(
        selected: active,
        button: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tab.icon, size: 21, color: colour),
            const SizedBox(height: 4),
            Text(
              tab.label,
              style: TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: colour,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
