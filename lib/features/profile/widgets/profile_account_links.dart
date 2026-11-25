import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/customer_tab.dart';
import '../../../app/widgets/pending_screen.dart';
import 'profile_info_card.dart';

/// Page 40's "Account" card — Saved Trainers and My Addresses.
///
/// Saved Trainers is a tab of this shell rather than a pushed route, so the
/// row switches tab; it is the same destination the Saved stat tile uses.
/// My Addresses (page 42) is unbuilt and names itself.
class ProfileAccountLinks extends ConsumerWidget {
  const ProfileAccountLinks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfileInfoCard(
      heading: 'Account',
      rows: [
        ProfileInfoRow(
          icon: Icons.favorite_border,
          title: 'Saved Trainers',
          subtitle: 'Your favourite fitness experts',
          titleFirst: true,
          onTap: () =>
              ref.read(customerTabProvider.notifier).select(CustomerTab.saved),
        ),
        ProfileInfoRow(
          icon: Icons.home_outlined,
          title: 'My Addresses',
          subtitle: 'Manage your training locations',
          titleFirst: true,
          last: true,
          onTap: () => PendingScreen.push(
            context,
            title: 'My Addresses',
            designPage: 'Page 42 My Addresses',
          ),
        ),
      ],
    );
  }
}
