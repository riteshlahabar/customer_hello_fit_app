import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../bookings_controller.dart';
import '../data/booking_repository.dart';

/// Page 27's `.counts` — three tiles above the list.
///
/// The design shows two-digit figures ("02", "08", "01"), so a count under
/// ten is padded to keep the Anton line the designed width. A bucket that has
/// not answered yet shows "--" rather than "00": claiming zero sessions when
/// the request is still in flight is a worse lie than saying nothing.
///
/// Each tile is its own server-side count, which is why all three load even
/// when the All tab is showing.
class BookingsCounts extends ConsumerWidget {
  const BookingsCounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          for (final filter in BookingFilter.values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 9),
                child: _CountTile(
                  count: ref.watch(bookingCountProvider(filter)),
                  label: _label(filter),
                  onTap: () =>
                      ref.read(bookingsFilterProvider.notifier).select(filter),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static String _label(BookingFilter filter) => switch (filter) {
        BookingFilter.upcoming => 'Upcoming',
        BookingFilter.completed => 'Completed',
        BookingFilter.cancelled => 'Cancelled',
      };
}

class _CountTile extends StatelessWidget {
  const _CountTile({
    required this.count,
    required this.label,
    required this.onTap,
  });

  final int? count;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: HFColors.panelSoft,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: HFColors.cardLine),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count == null
                  ? '--'
                  : count!.toString().padLeft(2, '0'),
              style: const TextStyle(
                fontFamily: HFFonts.display,
                fontWeight: FontWeight.w400,
                fontSize: 22,
                color: HFColors.ink,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 8,
                color: HFColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
