import '../../../core/network/json.dart';

/// One start time from `GET /app/customer/slots` (US-C10).
///
/// Minutes-of-day are the unit everywhere in this system; `fromTime`/`toTime`
/// are the same thing pre-formatted by the backend. The grid currently comes
/// from the institute window (05:00–22:00), because nothing writes provider
/// availability rules yet — a provider's real hours arrive with the unbuilt
/// provider app, page 67.
class SessionSlot {
  const SessionSlot({
    required this.fromMinute,
    required this.toMinute,
    required this.fromTime,
    required this.toTime,
    required this.availableInstructors,
  });

  factory SessionSlot.fromJson(Map<String, dynamic> json) => SessionSlot(
        fromMinute: asInt(json['fromMinute']),
        toMinute: asInt(json['toMinute']),
        fromTime: asString(json['fromTime']),
        toTime: asString(json['toTime']),
        availableInstructors: asInt(json['availableInstructors']),
      );

  final int fromMinute;
  final int toMinute;
  final String fromTime;
  final String toTime;

  /// How many teachers could take it. Zero never reaches the app — the grid
  /// only carries free slots — but a one-teacher slot is worth flagging.
  final int availableInstructors;

  String get label => '$fromTime – $toTime';
}

/// `POST /app/customer/bookings/quote` (US-C09, US-A09).
///
/// Creates nothing and holds nothing, so the screen may re-quote freely as the
/// customer changes add-ons or a coupon. The server computes every figure: a
/// `discount` the client sends is ignored when a coupon code is present.
class BookingQuote {
  const BookingQuote({
    required this.unitPrice,
    required this.sessionCount,
    required this.participantCount,
    required this.baseAmount,
    required this.percentAdjust,
    required this.percentAmount,
    required this.grossAmount,
    required this.addonAmount,
    required this.travelCharge,
    required this.discount,
    required this.taxableValue,
    required this.tax,
    required this.walletApplied,
    required this.payable,
    required this.sessionValue,
    required this.freeSessionCount,
    required this.currency,
    this.couponCode,
    this.couponDiscount,
  });

  factory BookingQuote.fromJson(Map<String, dynamic> json) {
    final coupon = asMap(json['coupon']);

    return BookingQuote(
      unitPrice: asDouble(json['unitPrice']),
      sessionCount: asInt(json['sessionCount'], fallback: 1),
      participantCount: asInt(json['participantCount'], fallback: 1),
      baseAmount: asDouble(json['baseAmount']),
      percentAdjust: asDouble(json['percentAdjust']),
      percentAmount: asDouble(json['percentAmount']),
      grossAmount: asDouble(json['grossAmount']),
      addonAmount: asDouble(json['addonAmount']),
      travelCharge: asDouble(json['travelCharge']),
      discount: asDouble(json['discount']),
      taxableValue: asDouble(json['taxableValue']),
      tax: asDouble(json['tax']),
      walletApplied: asDouble(json['walletApplied']),
      payable: asDouble(json['payable']),
      sessionValue: asDouble(json['sessionValue']),
      freeSessionCount: asInt(json['freeSessionCount']),
      currency: asString(json['currency'], fallback: 'INR'),
      couponCode: coupon['code'] as String?,
      couponDiscount: asDoubleOrNull(coupon['discount']),
    );
  }

  /// The admin-set service rate the whole quote is built from.
  final double unitPrice;
  final int sessionCount;
  final int participantCount;

  /// `unitPrice x participantCount x sessionCount`, before the package.
  final double baseAmount;

  /// Negative is a discount. The package percent is the only one there is.
  final double percentAdjust;
  final double percentAmount;
  final double grossAmount;
  final double addonAmount;
  final double travelCharge;
  final double discount;
  final double taxableValue;
  final double tax;
  final double walletApplied;

  /// What the gateway is asked for.
  final double payable;

  /// One occurrence's share, which becomes the teacher's earning base.
  final double sessionValue;

  /// Delivered free by the package: extra occurrences at zero value.
  final int freeSessionCount;
  final String currency;
  final String? couponCode;
  final double? couponDiscount;

  bool get hasCoupon => couponCode != null;
}
