import 'package:flutter/material.dart';

import '../../../core/text/initials.dart';
import '../../../core/theme/tokens.dart';
import '../data/profile_models.dart';

/// Page 40's `.profile` panel — avatar, name, email, verified line.
///
/// **The design's `.avatar` is a photograph and there is no photo column.**
/// §3.2's payload is name, gender, mobile, email, dob, goal and health notes,
/// and there is no customer upload route, so the slot is drawn with initials —
/// the same substitution page 09's header makes, in this design's rounded
/// square rather than a circle. Owed to the client with pages 05/07/09.
///
/// **"✓ Verified Member" is read as mobile-verified**, which is true by
/// construction rather than a column: auth is OTP-only, so an account cannot
/// exist without a verified mobile. The same reasoning as page 10's
/// `.verified` badge. There is no membership in this product — "membership"
/// appears nowhere in the PDF and pages 45/46 are bucket D — so the word is
/// not repeated, which would claim a tier that does not exist.
///
/// A **blocked** customer gets the block notice on that line instead.
/// `isBlocked` and `blockReason` are real fields and a blocked customer
/// cannot book, so the one place that states the account's standing has to
/// say so rather than read "verified".
class ProfileIdentity extends StatelessWidget {
  const ProfileIdentity({super.key, required this.profile});

  final CustomerProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: HFColors.searchFill,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          _Avatar(name: profile.name),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name.isEmpty ? 'HelloFit customer' : profile.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: HFFonts.body,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: HFColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  // `.who small` is the email in the design. It is optional
                  // on the profile, so the mobile stands in rather than the
                  // line collapsing — the identity panel always says who.
                  profile.email?.isNotEmpty == true
                      ? profile.email!
                      : profile.mobile,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: HFFonts.body,
                    fontSize: 9,
                    color: HFColors.muted,
                  ),
                ),
                const SizedBox(height: 5),
                _Standing(profile: profile),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `.verified`, or the block notice in its place.
class _Standing extends StatelessWidget {
  const _Standing({required this.profile});

  final CustomerProfile profile;

  @override
  Widget build(BuildContext context) {
    final blocked = profile.isBlocked;
    final reason = profile.blockReason;

    return Text(
      blocked
          ? (reason == null || reason.isEmpty
              ? 'Account on hold — you cannot book right now'
              : 'Account on hold — $reason')
          : '✓ Mobile verified',
      style: TextStyle(
        fontFamily: HFFonts.body,
        fontSize: 8,
        fontWeight: blocked ? FontWeight.w600 : FontWeight.w400,
        height: 1.5,
        color: blocked ? HFColors.bookingCancelInk : HFColors.memberVerifiedInk,
      ),
    );
  }
}

/// `.avatar` — 65px, 18px radius, a 3px `--soft` ring, drawn with initials.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = hfInitials(name);

    return Container(
      height: 65,
      width: 65,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: HFColors.iconWash,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: HFColors.panelSoft, width: 3),
      ),
      child: initials.isEmpty
          ? const Icon(Icons.person_outline, size: 28, color: HFColors.primary)
          : Text(
              initials,
              style: const TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: HFColors.primary,
              ),
            ),
    );
  }
}
