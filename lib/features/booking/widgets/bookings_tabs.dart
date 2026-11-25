import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../bookings_controller.dart';
import '../data/booking_repository.dart';

/// Page 27's `.tabs` — All / Upcoming / Completed / Cancelled on one track.
///
/// **Page 28 Upcoming Bookings is this screen's second tab, not a screen.**
/// It was agreed on 23-11-2026: the two designs differ only by the filter and
/// page 28's extra LOCATION and DURATION cells, and the bucket is already a
/// server-side `status=` parameter.
class BookingsTabs extends ConsumerWidget {
  const BookingsTabs({super.key});

  static const _labels = {
    null: 'All',
    BookingFilter.upcoming: 'Upcoming',
    BookingFilter.completed: 'Completed',
    BookingFilter.cancelled: 'Cancelled',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(bookingsFilterProvider);
    final select = ref.read(bookingsFilterProvider.notifier).select;

    return Container(
      margin: const EdgeInsets.only(bottom: 17),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: HFColors.tabTrack,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          for (final entry in _labels.entries)
            Expanded(
              child: _Tab(
                label: entry.value,
                selected: active == entry.key,
                onTap: () => select(entry.key),
              ),
            ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? HFColors.panelSoft : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            // `.tab.active` draws a far softer lift than `HFShadows.card`,
            // which is the full-card elevation.
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x0C4B3522),
                      blurRadius: 7,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: selected ? HFColors.primary : HFColors.actionInk,
            ),
          ),
        ),
      ),
    );
  }
}
