/// Coercion helpers for the envelope's `data`.
///
/// Postgres `Decimal` columns reach the app as **strings** (`"900"`,
/// `"5"`), while anything the backend computes in JavaScript arrives as a
/// number (`900`, `5`). `basePrice` is a column and `payable` on a quote is
/// computed, so the same concept arrives both ways depending on the route.
/// Every money and rating field therefore goes through [asDouble] rather than
/// a cast, which would throw on whichever half of the pair was not expected.
library;

double asDouble(Object? value, {double fallback = 0}) => switch (value) {
      final num n => n.toDouble(),
      final String s => double.tryParse(s) ?? fallback,
      _ => fallback,
    };

double? asDoubleOrNull(Object? value) => switch (value) {
      final num n => n.toDouble(),
      final String s => double.tryParse(s),
      _ => null,
    };

int asInt(Object? value, {int fallback = 0}) => switch (value) {
      final int i => i,
      final num n => n.round(),
      final String s => int.tryParse(s) ?? fallback,
      _ => fallback,
    };

String asString(Object? value, {String fallback = ''}) =>
    value?.toString() ?? fallback;

bool asBool(Object? value, {bool fallback = false}) => switch (value) {
      final bool b => b,
      'true' => true,
      'false' => false,
      _ => fallback,
    };

/// A list of maps from a payload that may be absent or null.
List<Map<String, dynamic>> asMapList(Object? value) => switch (value) {
      final List<dynamic> list => list.whereType<Map<String, dynamic>>().toList(),
      _ => const [],
    };

/// A list of plain strings — `languages`, `specialisations`, `tags`.
List<String> asStringList(Object? value) => switch (value) {
      final List<dynamic> list => list.map((e) => e.toString()).toList(),
      _ => const [],
    };

/// A list of whole numbers — `allowedWeekdays`, where 0 is Sunday.
List<int> asIntList(Object? value) => switch (value) {
      final List<dynamic> list => list.map((e) => asInt(e)).toList(),
      _ => const [],
    };

Map<String, dynamic> asMap(Object? value) => switch (value) {
      final Map<String, dynamic> map => map,
      _ => const {},
    };
