import 'package:customer_app/core/dates/hf_date.dart';
import 'package:flutter_test/flutter_test.dart';

/// `HfDate` is the only place in the app that reads a server date, and it has
/// to cope with two formats at once while the backend finishes converting to
/// `dd-mm-yyyy`. These are the cases that actually go wrong: the day shifting
/// by one, and a time zone turning midnight into the previous evening.
void main() {
  group('HfDate.parse', () {
    test('reads the project format', () {
      final parsed = HfDate.parse('25-11-2026');

      expect(parsed, isNotNull);
      expect(parsed!.year, 2026);
      expect(parsed.month, 11);
      expect(parsed.day, 25);
    });

    test('reads the project format with a clock', () {
      final parsed = HfDate.parse('25-11-2026 09:30:05')!;

      expect(parsed.day, 25);
      expect(parsed.hour, 9);
      expect(parsed.minute, 30);
      expect(parsed.second, 5);
    });

    test('an ISO midnight keeps its calendar day', () {
      // The customer booking routes still send a `date` column this way.
      // Reading it in local time would move it to the 24th anywhere east of
      // Greenwich, which is every user this app has.
      final parsed = HfDate.parse('2026-11-25T00:00:00.000Z')!;

      expect(parsed.year, 2026);
      expect(parsed.month, 11);
      expect(parsed.day, 25);
    });

    test('a bare ISO day is read as that day', () {
      final parsed = HfDate.parse('2026-11-25')!;

      expect(parsed.day, 25);
      expect(parsed.month, 11);
    });

    test('a 01-prefixed day is not confused with a month', () {
      final parsed = HfDate.parse('08-03-1994')!;

      expect(parsed.day, 8);
      expect(parsed.month, 3);
      expect(parsed.year, 1994);
    });

    test('null, empty and nonsense give null rather than throwing', () {
      expect(HfDate.parse(null), isNull);
      expect(HfDate.parse(''), isNull);
      expect(HfDate.parse('   '), isNull);
      expect(HfDate.parse('not a date'), isNull);
    });

    test('a DateTime passes straight through', () {
      final now = DateTime(2026, 11, 25, 7, 30);

      expect(HfDate.parse(now), now);
    });
  });

  group('formatting', () {
    test('format is dd-mm-yyyy with both parts padded', () {
      expect(HfDate.format(DateTime(1994, 3, 8)), '08-03-1994');
      expect(HfDate.format(DateTime(2026, 11, 25)), '25-11-2026');
    });

    test('formatDateTime adds the clock', () {
      expect(
        HfDate.formatDateTime(DateTime(2026, 11, 19, 9, 5, 2)),
        '19-11-2026 09:05:02',
      );
    });

    test('wire is the ISO day the booking DTOs still validate', () {
      expect(HfDate.wire(DateTime(2026, 11, 5)), '2026-11-05');
    });

    test('a round trip through wire and parse keeps the day', () {
      final date = DateTime(2026, 11, 25);
      final back = HfDate.parse(HfDate.wire(date))!;

      expect(back.day, date.day);
      expect(back.month, date.month);
      expect(back.year, date.year);
    });

    test('clock turns a minute-of-day into HH:mm', () {
      expect(HfDate.clock(0), '00:00');
      expect(HfDate.clock(5 * 60), '05:00');
      expect(HfDate.clock(9 * 60 + 30), '09:30');
      expect(HfDate.clock(22 * 60), '22:00');
      expect(HfDate.clock(1439), '23:59');
    });
  });
}
