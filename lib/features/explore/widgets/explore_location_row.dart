import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../profile/profile_providers.dart';

/// Page 10's `.location` — "Near **your selected location**".
///
/// **The design's orange chevron is left out**, exactly as on page 09: it
/// implies a city picker that exists nowhere in the app (page 17 Location
/// Selection sits inside the booking flow and picks a saved *address*, not a
/// search city), and `GET /providers` filters by `cityId`/`areaId` that only
/// the address book supplies. Already raised with the client.
///
/// The row hides when there is no saved address rather than naming a city the
/// customer never chose.
class ExploreLocationRow extends ConsumerWidget {
  const ExploreLocationRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(defaultLocationLabelProvider).value;

    if (location == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 11, left: 2, right: 2),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 13,
            color: HFColors.primary,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 9,
                  color: HFColors.muted,
                ),
                children: [
                  const TextSpan(text: 'Near '),
                  TextSpan(
                    text: location,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: HFColors.locationInk,
                    ),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
