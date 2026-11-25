import 'package:customer_app/features/booking/booking_status.dart';
import 'package:customer_app/features/booking/data/booking_detail_models.dart';
import 'package:flutter_test/flutter_test.dart';

/// Page 27's chip is a reading of the booking, not a server field, so the
/// order of its rules is the part worth pinning down.
BookingSummary summary({
  String paymentStatus = 'PAID',
  List<String> sessionStatuses = const ['CONFIRMED'],
  int durationMin = 60,
}) {
  return BookingSummary.fromJson({
    'id': 'b1',
    'code': 'HF-2026-000123',
    'type': sessionStatuses.length > 1 ? 'PACKAGE' : 'SINGLE',
    'payable': 1324,
    'paymentStatus': paymentStatus,
    'service': {'name': 'Personal Training', 'durationMin': durationMin},
    'sessions': [
      for (final (index, status) in sessionStatuses.indexed)
        {
          'id': 's$index',
          'sequence': index + 1,
          'fromMinute': 510,
          'toMinute': 570,
          'status': status,
          'sessionDate': '11-11-2026',
        },
    ],
  });
}

void main() {
  group('bookingChipFor', () {
    test('a paid booking with a future session is confirmed', () {
      expect(bookingChipFor(summary()), BookingChip.confirmed);
    });

    test('an unpaid booking is pending, whatever its sessions say', () {
      expect(
        bookingChipFor(
          summary(paymentStatus: 'UNPAID', sessionStatuses: ['CONFIRMED']),
        ),
        BookingChip.pending,
      );
    });

    test('every session cancelled wins over an unpaid booking', () {
      // The ordering that matters: this row must not offer "Pay Now".
      expect(
        bookingChipFor(
          summary(
            paymentStatus: 'UNPAID',
            sessionStatuses: ['CANCELLED_BY_CUSTOMER'],
          ),
        ),
        BookingChip.cancelled,
      );
    });

    test('every session completed is completed', () {
      expect(
        bookingChipFor(summary(sessionStatuses: ['COMPLETED', 'COMPLETED'])),
        BookingChip.completed,
      );
    });

    test('a package part-way through is still confirmed', () {
      expect(
        bookingChipFor(summary(sessionStatuses: ['COMPLETED', 'ASSIGNED'])),
        BookingChip.confirmed,
      );
    });

    test('a completed package with one cancelled occurrence is completed', () {
      expect(
        bookingChipFor(
          summary(sessionStatuses: ['COMPLETED', 'CANCELLED_BY_PROVIDER']),
        ),
        BookingChip.completed,
      );
    });

    test('a paid booking whose sessions have not generated is confirmed', () {
      expect(
        bookingChipFor(summary(sessionStatuses: const [])),
        BookingChip.confirmed,
      );
    });

    test('only the cancelled chip drops the second action', () {
      expect(BookingChip.cancelled.actionLabel, isNull);
      for (final chip in BookingChip.values.where((c) => c != BookingChip.cancelled)) {
        expect(chip.actionLabel, isNotNull);
        expect(chip.actionDesignPage, isNotNull);
      }
    });
  });

  group('bookingSubtitle', () {
    test('a single session is just its duration', () {
      expect(bookingSubtitle(summary()), '60 minutes');
    });

    test('a package names how many sessions it holds', () {
      expect(
        bookingSubtitle(
          summary(sessionStatuses: ['CONFIRMED', 'CONFIRMED', 'CONFIRMED']),
        ),
        '60 minutes · 3 sessions',
      );
    });
  });
}
