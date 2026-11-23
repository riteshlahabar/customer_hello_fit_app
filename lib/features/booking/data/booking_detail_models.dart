import '../../../core/dates/hf_date.dart';
import '../../../core/network/json.dart';
import 'booking_session_models.dart';

/// A row of `GET /app/customer/bookings` — "My Bookings" (US-C13).
///
/// The list is filtered server-side by `status=upcoming|completed|cancelled`;
/// the app must not re-derive those buckets from the session rows, because
/// "upcoming" means a future *session date*, not a booking state.
class BookingSummary {
  const BookingSummary({
    required this.id,
    required this.code,
    required this.type,
    required this.payable,
    required this.paymentStatus,
    required this.serviceName,
    required this.durationMin,
    required this.sessions,
    this.createdAt,
    this.addressLabel,
    this.cityName,
  });

  factory BookingSummary.fromJson(Map<String, dynamic> json) {
    final service = asMap(json['service']);
    final address = asMap(json['address']);

    return BookingSummary(
      id: asString(json['id']),
      code: asString(json['code']),
      type: asString(json['type'], fallback: 'SINGLE'),
      payable: asDouble(json['payable']),
      paymentStatus: asString(json['paymentStatus'], fallback: 'UNPAID'),
      serviceName: asString(service['name']),
      durationMin: asInt(service['durationMin']),
      sessions: asMapList(json['sessions'])
          .map(BookingSessionRow.fromJson)
          .toList(),
      createdAt: HfDate.parse(json['createdAt']),
      addressLabel: address['label'] as String?,
      cityName: asMap(address['city'])['name'] as String?,
    );
  }

  final String id;
  final String code;

  /// SINGLE or PACKAGE.
  final String type;
  final double payable;
  final String paymentStatus;
  final String serviceName;
  final int durationMin;
  final List<BookingSessionRow> sessions;
  final DateTime? createdAt;
  final String? addressLabel;
  final String? cityName;

  /// The occurrence a card leads with.
  BookingSessionRow? get firstSession =>
      sessions.isEmpty ? null : sessions.first;

  bool get isPaid => paymentStatus == 'PAID';
}

/// `GET /app/customer/bookings/:id` — the whole file for one booking.
class BookingDetail {
  const BookingDetail({
    required this.id,
    required this.code,
    required this.type,
    required this.payable,
    required this.tax,
    required this.discount,
    required this.paymentStatus,
    required this.sessionCount,
    required this.participantCount,
    required this.serviceName,
    required this.durationMin,
    required this.sessions,
    required this.addons,
    required this.source,
    this.serviceId,
    this.addressLine,
    this.cancelReason,
    this.holdExpiresAt,
    this.createdAt,
    this.preferences = const {},
  });

  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    final service = asMap(json['service']);
    final address = asMap(json['address']);

    return BookingDetail(
      id: asString(json['id']),
      code: asString(json['code']),
      type: asString(json['type'], fallback: 'SINGLE'),
      payable: asDouble(json['payable']),
      tax: asDouble(json['tax']),
      discount: asDouble(json['discount']),
      paymentStatus: asString(json['paymentStatus'], fallback: 'UNPAID'),
      sessionCount: asInt(json['sessionCount'], fallback: 1),
      participantCount: asInt(json['participantCount'], fallback: 1),
      serviceId: service['id'] as String?,
      serviceName: asString(service['name']),
      durationMin: asInt(service['durationMin']),
      sessions: asMapList(json['sessions'])
          .map(BookingSessionRow.fromJson)
          .toList(),
      addons: asMapList(json['addons'])
          .map(
            (a) => (
              name: asString(asMap(a['addon'])['name']),
              quantity: asInt(a['quantity'], fallback: 1),
              unitPrice: asDouble(a['unitPrice']),
            ),
          )
          .toList(),
      source: asString(json['source'], fallback: 'APP_CUSTOMER'),
      addressLine: [
        address['line1'],
        address['line2'],
        address['landmark'],
        address['pincode'],
      ].whereType<String>().where((p) => p.isNotEmpty).join(', '),
      cancelReason: json['cancelReason'] as String?,
      holdExpiresAt: HfDate.parse(json['holdExpiresAt']),
      createdAt: HfDate.parse(json['createdAt']),
      preferences: asMap(json['preferences']),
    );
  }

  final String id;
  final String code;
  final String type;
  final double payable;
  final double tax;
  final double discount;
  final String paymentStatus;
  final int sessionCount;

  /// How many people the session is for. Fixed by the package.
  final int participantCount;
  final String? serviceId;
  final String serviceName;
  final int durationMin;
  final List<BookingSessionRow> sessions;
  final List<({String name, int quantity, double unitPrice})> addons;

  /// APP_CUSTOMER or WEBSITE — which surface it was booked from.
  final String source;
  final String? addressLine;
  final String? cancelReason;
  final DateTime? holdExpiresAt;
  final DateTime? createdAt;

  /// Gender, language, "same teacher for all sessions" — free-form JSON the
  /// booking wizard wrote, so it is passed through rather than typed.
  final Map<String, dynamic> preferences;
}
