import 'data/booking_detail_models.dart';

/// Page 27's `.status` chip, and the orange action that goes with it.
///
/// A pure mapping with no Flutter in it, so it can be unit-tested: the four
/// chips the design draws are not four server states but a reading of the
/// booking's payment status and its sessions, and getting that wrong shows a
/// customer the wrong button.
enum BookingChip {
  confirmed('CONFIRMED', 'View', 'Page 32 Session Details'),
  pending('PENDING', 'Pay Now', 'Page 23 Payment Method'),
  completed('COMPLETED', 'Review', 'Page 53 Submit Review'),

  /// A cancelled booking has no second action in the design — only Details.
  cancelled('CANCELLED', null, null);

  const BookingChip(this.label, this.actionLabel, this.actionDesignPage);

  final String label;

  /// `.actions .primary`. Null when the design shows none.
  final String? actionLabel;

  /// The supplied design that action leads to. All four are unbuilt, so the
  /// card routes to a stand-in that names this page.
  final String? actionDesignPage;
}

/// Which chip a row carries.
///
/// Order matters. Cancellation is read first because a cancelled booking is
/// often also unpaid, and "PENDING" with a Pay Now button on something already
/// cancelled would invite a payment that cannot be honoured. Payment is read
/// next because §3.7 holds the slot only until payment settles — an unpaid
/// booking is not yet confirmed, whatever its sessions say.
BookingChip bookingChipFor(BookingSummary booking) {
  final sessions = booking.sessions;

  if (sessions.isNotEmpty && sessions.every((s) => s.isCancelled)) {
    return BookingChip.cancelled;
  }
  if (!booking.isPaid) return BookingChip.pending;
  if (sessions.isNotEmpty &&
      sessions.every((s) => s.status == 'COMPLETED' || s.isCancelled)) {
    return BookingChip.completed;
  }

  return BookingChip.confirmed;
}

/// `.trainer small` — the line under the provider's name.
///
/// **The design puts the trainer's job title there ("Certified Personal
/// Trainer"); no such field exists.** `BookingSessionRow` carries the
/// provider's id, name and photo and nothing else, and §3.6's payload has no
/// headline. The slot takes what the booking does know instead: how long a
/// session runs, and how many of them a package holds. Owed to the client.
String bookingSubtitle(BookingSummary booking) {
  final duration = '${booking.durationMin} minutes';

  return booking.sessions.length > 1
      ? '$duration · ${booking.sessions.length} sessions'
      : duration;
}
