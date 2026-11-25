import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/customer_tab.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/hf_logo.dart';
import '../home_controller.dart';

/// Page 09's `.header` — the logo, and the two circular buttons beside it.
///
/// The bell has no screen yet: page 44 Notifications is a tab of its own in
/// the design set, so the bell switches to Profile's neighbourhood only once
/// that is built. Until then it carries its badge and does nothing, which is
/// honest; it is not wired to an invented route.
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(homeUnreadCountProvider).value ?? 0;

    return Padding(
      padding: const EdgeInsets.only(top: 9, bottom: 17),
      child: Row(
        children: [
          const HFLogo(height: 43),
          const Spacer(),
          _RoundButton(
            icon: Icons.notifications_none,
            semanticLabel: unread > 0
                ? 'Notifications, $unread unread'
                : 'Notifications',
            showDot: unread > 0,
            onTap: null,
          ),
          const SizedBox(width: 9),
          _RoundButton(
            icon: Icons.person_outline,
            semanticLabel: 'Profile',
            onTap: () => ref
                .read(customerTabProvider.notifier)
                .select(CustomerTab.profile),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
    this.showDot = false,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: HFColors.roundBorder),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 18, color: HFColors.ink),
              if (showDot)
                Positioned(
                  right: 6,
                  top: 5,
                  child: Container(
                    height: 7,
                    width: 7,
                    decoration: BoxDecoration(
                      color: HFColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
