import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/tokens.dart';
import 'bookings_controller.dart';
import 'widgets/bookings_counts.dart';
import 'widgets/bookings_header.dart';
import 'widgets/bookings_list.dart';
import 'widgets/bookings_tabs.dart';

/// Page 27, My Bookings — the Bookings tab.
///
/// Sections in the design's order: brand header, title block, the four filter
/// tabs, the three counts, then the cards. No AppBar, for the same reason as
/// page 09: the design's header scrolls away with the content, and the shell
/// owns the bottom nav.
///
/// **Page 28 Upcoming Bookings is the Upcoming tab**, agreed 23-11-2026 —
/// the same list under `status=upcoming`. Page 28's two extra detail cells
/// (LOCATION, DURATION) belong to that design, not this one, so they arrive
/// if and when the client asks for a dedicated screen.
class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: HFColors.primary,
        onRefresh: () => refreshBookings(ref),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, HFSpacing.lg),
          children: const [
            BookingsHeader(),
            BookingsTabs(),
            BookingsCounts(),
            BookingsList(),
          ],
        ),
      ),
    );
  }
}
