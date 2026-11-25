import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_result.dart';
import '../../core/providers.dart';
import 'data/booking_detail_models.dart';
import 'data/booking_repository.dart';

/// Page 27's four tabs and the three counts above them.
///
/// **Every bucket is a server-side read.** `BookingFilter` is `status=` on
/// `GET /app/customer/bookings`, and "upcoming" there means a future *session
/// date*, not a booking state — so the app must never re-derive the buckets
/// from the rows it already holds. That is also why the counts are three real
/// reads rather than a group-by over one list.
///
/// A null filter is the design's "All" tab: no `status` on the wire, so the
/// server's own unfiltered list answers. It is not the union of the three
/// buckets — a booking in none of them still belongs on All.

/// Which tab is showing. Null is "All".
class BookingsFilter extends Notifier<BookingFilter?> {
  @override
  BookingFilter? build() => null;

  void select(BookingFilter? filter) => state = filter;
}

final bookingsFilterProvider =
    NotifierProvider<BookingsFilter, BookingFilter?>(BookingsFilter.new);

/// Carries the backend's message to the retry line.
class BookingsFailed implements Exception {
  const BookingsFailed(this.message);

  final String message;

  @override
  String toString() => message;
}

/// One bucket. Keyed by filter so the four tabs cache independently and
/// switching back to a tab does not refetch it.
final bookingsProvider =
    FutureProvider.family<List<BookingSummary>, BookingFilter?>(
        (ref, filter) async {
  final result =
      await ref.watch(bookingRepositoryProvider).bookings(filter: filter);

  return switch (result) {
    ApiSuccess(:final data) => data,
    ApiFailure(:final message) => throw BookingsFailed(message),
  };
});

/// `.count strong`. Null while the bucket loads or after it failed — the tile
/// then shows a dash rather than a 0, which would claim there are none.
final bookingCountProvider = Provider.family<int?, BookingFilter>(
  (ref, filter) => ref.watch(bookingsProvider(filter)).value?.length,
);

/// Pull-to-refresh: the three counted buckets and the tab on screen.
Future<void> refreshBookings(WidgetRef ref) async {
  for (final filter in BookingFilter.values) {
    ref.invalidate(bookingsProvider(filter));
  }
  ref.invalidate(bookingsProvider(null));

  await ref.read(bookingsProvider(ref.read(bookingsFilterProvider)).future);
}
