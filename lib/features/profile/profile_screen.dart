import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/widgets/pending_screen.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/hf_brand_header.dart';
import '../../core/widgets/hf_page_title.dart';
import 'data/profile_models.dart';
import 'profile_providers.dart';
import 'widgets/profile_account_links.dart';
import 'widgets/profile_edit_button.dart';
import 'widgets/profile_identity.dart';
import 'widgets/profile_personal_info.dart';
import 'widgets/profile_stats.dart';

/// Page 40, My Profile — the Profile tab.
///
/// Sections in the design's order: brand bar, title row with EDIT PROFILE,
/// the identity panel, the three stat tiles, Personal Information, Account.
///
/// **The design's "My Fitness" section is not drawn.** Its two rows are
/// Fitness Goals (page 34) and Workout Progress (page 38) — the workout
/// programme module, which the client ruled out of scope on 23-11-2026
/// (bucket D: no PDF section, no tables, no endpoints). There is nothing
/// behind either row and nothing to link them to.
///
/// **There is no sign-out here, because the design has none.** Page 48
/// Settings is where it would sit and that is bucket D too, so the app
/// currently cannot sign out — `AuthRepository.logout()` exists and is
/// wired to nothing. Raised with the client rather than invented (rule 2).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(customerProfileProvider);

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: HFColors.primary,
        onRefresh: () async {
          ref.invalidate(customerProfileProvider);
          ref.invalidate(defaultLocationLabelProvider);
          await ref.read(customerProfileProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, HFSpacing.lg),
          children: [
            const HFBrandHeader(),
            HFPageTitle(
              eyebrow: 'YOUR ACCOUNT',
              title: 'My Profile',
              titleSize: 31,
              // Page 41 Edit Profile is unbuilt; the button names it rather
              // than doing nothing.
              trailing: ProfileEditButton(
                onTap: () => PendingScreen.push(
                  context,
                  title: 'Edit Profile',
                  designPage: 'Page 41 Edit Profile',
                ),
              ),
            ),
            ...switch (profile) {
              AsyncData(:final value) => _body(value),
              AsyncError(:final error) => [
                  _Failed(
                    message: error.toString(),
                    onRetry: () => ref.invalidate(customerProfileProvider),
                  ),
                ],
              // The whole screen is this one payload, so it waits as a whole
              // rather than drawing empty rows that then fill in.
              _ => const [
                  Padding(
                    padding: EdgeInsets.only(top: HFSpacing.xl),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: HFColors.primary,
                      ),
                    ),
                  ),
                ],
            },
          ],
        ),
      ),
    );
  }

  List<Widget> _body(CustomerProfile profile) => [
        ProfileIdentity(profile: profile),
        const ProfileStats(),
        ProfilePersonalInfo(profile: profile),
        const ProfileAccountLinks(),
      ];
}

class _Failed extends StatelessWidget {
  const _Failed({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: HFSpacing.md),
      padding: const EdgeInsets.all(HFSpacing.md),
      decoration: BoxDecoration(
        color: HFColors.panelSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HFColors.cardLine),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 10,
              height: 1.6,
              color: HFColors.muted,
            ),
          ),
          const SizedBox(height: HFSpacing.sm),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              'Try again',
              style: TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: HFColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
