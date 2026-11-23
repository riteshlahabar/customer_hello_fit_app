/// Dates on the wire, in one place.
///
/// The project rule is `dd-mm-yyyy` for every date a person reads and every
/// date in an API body (client, 19 Nov 2026). The backend is part-way through
/// that: the trainer-app and admin routes already send `dd-mm-yyyy`, while the
/// customer booking routes still serialise a `date` column as an ISO instant
/// (`2026-11-25T00:00:00.000Z`) — the website copes by slicing the first ten
/// characters.
///
/// So [parse] accepts both, and this is the single file to simplify when the
/// backend finishes the conversion. Nothing else in the app may call
/// `DateTime.parse` on a server string.
abstract final class HfDate {
  /// `25-11-2026`, `25-11-2026 09:30:00` or an ISO instant. Null when the
  /// value is absent or unparseable — a bad date must not crash a list.
  static DateTime? parse(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;

    final text = value.toString().trim();
    if (text.isEmpty) return null;

    final ddmm = RegExp(r'^(\d{2})-(\d{2})-(\d{4})');
    final match = ddmm.firstMatch(text);

    if (match != null) {
      final day = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final year = int.parse(match.group(3)!);
      final clock = text.length > 10 ? text.substring(10).trim() : '';
      final parts = clock.split(':');

      return DateTime(
        year,
        month,
        day,
        parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0,
        parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
        parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0,
      );
    }

    // An ISO instant for a `date` column is midnight UTC. Reading it in local
    // time would shift the day backwards everywhere east of Greenwich, so the
    // calendar day is taken from the UTC fields, not the local ones.
    final iso = DateTime.tryParse(text);
    if (iso == null) return null;

    return text.length <= 10
        ? DateTime(iso.year, iso.month, iso.day)
        : DateTime(
            iso.toUtc().year,
            iso.toUtc().month,
            iso.toUtc().day,
            iso.toLocal().hour,
            iso.toLocal().minute,
            iso.toLocal().second,
          );
  }

  /// A calendar day as a person reads it: `25-11-2026`.
  static String format(DateTime date) =>
      '${_two(date.day)}-${_two(date.month)}-${date.year}';

  /// A day with the clock: `25-11-2026 09:30:00`.
  static String formatDateTime(DateTime at) =>
      '${format(at)} ${_two(at.hour)}:${_two(at.minute)}:${_two(at.second)}';

  /// What a request body carries for a session date.
  ///
  /// **`yyyy-MM-dd`, not `dd-mm-yyyy`** — `CreateBookingDto.sessionDate` and
  /// the slot query still validate with `@IsDateString()`, so sending the
  /// display format is a 400 today. Change this with the DTOs, not before.
  static String wire(DateTime date) =>
      '${date.year}-${_two(date.month)}-${_two(date.day)}';

  /// `09:30` from a minute-of-day, the unit every slot and session uses.
  static String clock(int minuteOfDay) =>
      '${_two(minuteOfDay ~/ 60)}:${_two(minuteOfDay % 60)}';

  static String _two(int value) => value.toString().padLeft(2, '0');
}
