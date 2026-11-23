import 'package:customer_app/core/network/json.dart';
import 'package:flutter_test/flutter_test.dart';

/// The backend sends the same concept two ways: a Postgres `Decimal` column
/// arrives as a string (`"900"`), anything it computes in JavaScript arrives
/// as a number (`900`). `basePrice` is the first, a quote's `payable` the
/// second. A cast would throw on whichever half was not expected, so every
/// money and rating field goes through these.
void main() {
  group('asDouble', () {
    test('takes a Decimal column sent as a string', () {
      expect(asDouble('900'), 900);
      expect(asDouble('810.50'), 810.5);
    });

    test('takes a computed number', () {
      expect(asDouble(1062), 1062);
      expect(asDouble(4.5), 4.5);
    });

    test('falls back rather than throwing on null or rubbish', () {
      expect(asDouble(null), 0);
      expect(asDouble('n/a'), 0);
      expect(asDouble(null, fallback: -1), -1);
    });

    test('asDoubleOrNull keeps a missing price missing', () {
      // `/packages` with no serviceId sends price: null on purpose — a package
      // has no price until a service is chosen.
      expect(asDoubleOrNull(null), isNull);
      expect(asDoubleOrNull('810'), 810);
    });
  });

  group('asInt', () {
    test('reads ints, numeric strings and rounds doubles', () {
      expect(asInt(5), 5);
      expect(asInt('12'), 12);
      expect(asInt(4.6), 5);
      expect(asInt(null, fallback: 1), 1);
    });
  });

  group('asBool', () {
    test('reads booleans and their string forms', () {
      expect(asBool(true), isTrue);
      expect(asBool('true'), isTrue);
      expect(asBool('false'), isFalse);
      expect(asBool(null), isFalse);
      expect(asBool(null, fallback: true), isTrue);
    });
  });

  group('collections', () {
    test('asMapList keeps only the maps', () {
      expect(
        asMapList([
          {'id': 'a'},
          'noise',
          {'id': 'b'},
        ]).length,
        2,
      );
      expect(asMapList(null), isEmpty);
      expect(asMapList('[]'), isEmpty);
    });

    test('asStringList stringifies every element', () {
      expect(asStringList(['en', 'mr']), ['en', 'mr']);
      expect(asStringList(null), isEmpty);
    });

    test('asIntList reads allowedWeekdays', () {
      expect(asIntList([0, 3, 6]), [0, 3, 6]);
      expect(asIntList(null), isEmpty);
    });

    test('asMap gives an empty map for a null relation', () {
      // `address.city` is null until the pincode resolves to one.
      expect(asMap(null), isEmpty);
      expect(asMap({'name': 'Pune'})['name'], 'Pune');
    });
  });
}
