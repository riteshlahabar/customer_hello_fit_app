import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/widgets/pending_screen.dart';
import '../../../core/dates/hf_date.dart';
import '../data/profile_models.dart';
import '../profile_providers.dart';
import 'profile_info_card.dart';

/// Page 40's "Personal Information" card: mobile, home location, birthday.
///
/// **The mobile row does not lead anywhere.** It is the login identity; the
/// API changes it only by verifying a new number and there is no route for
/// that, so the row carries no chevron rather than a chevron that cannot
/// deliver. §3.2's `PATCH` deliberately omits `mobile`.
///
/// **The date of birth is `dd-mm-yyyy`** (hard rule 4), overriding the
/// design's "15 August 1998".
class ProfilePersonalInfo extends ConsumerWidget {
  const ProfilePersonalInfo({super.key, required this.profile});

  final CustomerProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The same feed page 09's and page 10's location rows read, so all three
    // name the default address identically.
    final location = ref.watch(defaultLocationLabelProvider).value;
    final dob = profile.dob;

    return ProfileInfoCard(
      heading: 'Personal Information',
      rows: [
        ProfileInfoRow(
          icon: Icons.call_outlined,
          subtitle: 'Mobile Number',
          title: profile.mobile,
        ),
        ProfileInfoRow(
          icon: Icons.place_outlined,
          subtitle: 'Home Location',
          // "Area, City" when the pincode maps to a service area. The label
          // is null with no saved address, or with one whose pincode is not
          // covered yet — the row then invites the address rather than
          // inventing a city.
          title: location ?? 'Add an address',
          onTap: () => PendingScreen.push(
            context,
            title: 'My Addresses',
            designPage: 'Page 42 My Addresses',
          ),
        ),
        ProfileInfoRow(
          icon: Icons.cake_outlined,
          subtitle: 'Date of Birth',
          title: dob == null ? 'Not added' : HfDate.format(dob),
          last: true,
          onTap: () => PendingScreen.push(
            context,
            title: 'Edit Profile',
            designPage: 'Page 41 Edit Profile',
          ),
        ),
      ],
    );
  }
}
