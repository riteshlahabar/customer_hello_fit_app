import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/customer_tab.dart';
import '../../../core/theme/tokens.dart';
import '../../booking/bookings_controller.dart';
import '../../booking/data/booking_repository.dart';
import '../../favourites/saved_trainers_controller.dart';

/// Page 40's `.stats` — three tiles.
///
/// **Two of the design's three figures have no field behind them.** It asks
/// for Sessions, Active Time ("12h") and Day Streak ("5"):
///
/// * Sessions is real — the completed bucket, the same count page 27's tile
///   shows, so the two screens can never disagree.
/// * **Active Time is dropped.** Nothing sums session minutes; deriving it
///   from the rows on hand would only ever total the page the app happens to
///   hold, which is a wrong number rather than a missing one.
/// * **Day Streak is dropped.** A streak belongs to the workout programme
///   module (pages 34-39), which is bucket D — no PDF section, no tables, no
///   endpoints.
///
/// The two cells keep the designed grid and show the nearest real facts, the
/// way page 10's `.meta` kept its cell when "2.5 km away" turned out to have
/// no field: Upcoming (the other count page 27 reads) and Saved (the ids feed
/// page 43 and the hearts already share). Every tile is a read some other tab
/// makes anyway — no new request, and **no new backend**.
///
/// Each tile taps through to the tab it counts, which is what makes it worth
/// being a tile rather than a label.
class ProfileStats extends ConsumerWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedTrainerIdsProvider).value?.length;
    final select = ref.read(customerTabProvider.notifier).select;

    return Row(
      children: [
        _Tile(
          value: ref.watch(bookingCountProvider(BookingFilter.completed)),
          label: 'Sessions',
          onTap: () => _openBookings(ref, BookingFilter.completed),
        ),
        _Tile(
          value: ref.watch(bookingCountProvider(BookingFilter.upcoming)),
          label: 'Upcoming',
          onTap: () => _openBookings(ref, BookingFilter.upcoming),
        ),
        _Tile(
          value: saved,
          label: 'Saved',
          onTap: () => select(CustomerTab.saved),
          last: true,
        ),
      ],
    );
  }

  /// Switches tab *and* selects the matching bucket, so the number the
  /// customer tapped is the list they land on.
  static void _openBookings(WidgetRef ref, BookingFilter filter) {
    ref.read(bookingsFilterProvider.notifier).select(filter);
    ref.read(customerTabProvider.notifier).select(CustomerTab.bookings);
  }
}

/// `.stat`. "--" while the count is in flight or after it failed, never "0":
/// claiming no sessions when the request has not answered is the worse lie.
/// The same rule page 27's count tiles follow.
class _Tile extends StatelessWidget {
  const _Tile({
    required this.value,
    required this.label,
    required this.onTap,
    this.last = false,
  });

  final int? value;
  final String label;
  final VoidCallback onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: last ? 0 : 8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            decoration: BoxDecoration(
              color: HFColors.searchFill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  value?.toString() ?? '--',
                  style: const TextStyle(
                    fontFamily: HFFonts.display,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: HFColors.ink,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: HFFonts.body,
                    fontSize: 7,
                    color: HFColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
