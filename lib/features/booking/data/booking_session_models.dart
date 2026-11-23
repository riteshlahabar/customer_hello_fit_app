import '../../../core/dates/hf_date.dart';
import '../../../core/network/json.dart';
import 'booking_models.dart';

/// What `POST /app/customer/bookings` answers with (US-C11): the reference,
/// the hold and the occurrences it generated.
class BookingCreated {
  const BookingCreated({
    required this.id,
    required this.code,
    required this.payable,
    required this.paymentStatus,
    required this.sessions,
    required this.quote,
    this.holdExpiresAt,
  });

  factory BookingCreated.fromJson(Map<String, dynamic> json) => BookingCreated(
        id: asString(json['id']),
        code: asString(json['code']),
        payable: asDouble(json['payable']),
        paymentStatus: asString(json['paymentStatus'], fallback: 'UNPAID'),
        sessions: asMapList(json['sessions'])
            .map(BookingSessionRow.fromJson)
            .toList(),
        quote: BookingQuote.fromJson(asMap(json['breakup'])),
        holdExpiresAt: HfDate.parse(json['holdExpiresAt']),
      );

  final String id;

  /// The customer-facing reference, e.g. `HF-2026-000123`.
  final String code;
  final double payable;

  /// UNPAID until payment settles; FAILED when the hold ran out.
  final String paymentStatus;
  final List<BookingSessionRow> sessions;

  /// The same breakup the quote returned, frozen onto the booking.
  final BookingQuote quote;

  /// When the held slot is released if payment never arrives.
  final DateTime? holdExpiresAt;
}

/// One occurrence of a booking, in a list or on the detail screen.
class BookingSessionRow {
  const BookingSessionRow({
    required this.id,
    required this.sequence,
    required this.fromMinute,
    required this.toMinute,
    required this.status,
    this.sessionDate,
    this.sessionValue,
    this.instructorId,
    this.instructorName,
    this.instructorPhotoUrl,
    this.checkInOtp,
  });

  factory BookingSessionRow.fromJson(Map<String, dynamic> json) {
    final instructor = asMap(json['instructor']);

    return BookingSessionRow(
      id: asString(json['id']),
      sequence: asInt(json['sequence'], fallback: 1),
      fromMinute: asInt(json['fromMinute']),
      toMinute: asInt(json['toMinute']),
      status: asString(json['status']),
      sessionDate: HfDate.parse(json['sessionDate']),
      sessionValue: asDoubleOrNull(json['sessionValue']),
      instructorId: instructor['id'] as String?,
      instructorName: instructor['name'] as String?,
      instructorPhotoUrl: instructor['photoUrl'] as String?,
      checkInOtp: json['checkInOtp'] as String?,
    );
  }

  final String id;
  final int sequence;
  final int fromMinute;
  final int toMinute;

  /// PENDING_PAYMENT, CONFIRMED, ASSIGNED, REASSIGNMENT_NEEDED, IN_PROGRESS,
  /// COMPLETED or one of the CANCELLED_/NO_SHOW_ values.
  final String status;
  final DateTime? sessionDate;
  final double? sessionValue;

  /// Null until a provider accepts, or after one rejects a direct request.
  final String? instructorId;
  final String? instructorName;
  final String? instructorPhotoUrl;

  /// The 4-digit code shown to the teacher at the door.
  final String? checkInOtp;

  String get slotLabel =>
      '${HfDate.clock(fromMinute)} – ${HfDate.clock(toMinute)}';

  bool get isCancelled => status.startsWith('CANCELLED_');
  bool get isAwaitingProvider =>
      status == 'CONFIRMED' || status == 'REASSIGNMENT_NEEDED';
}
