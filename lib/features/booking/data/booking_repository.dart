import '../../../core/dates/hf_date.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/json.dart';
import 'booking_detail_models.dart';
import 'booking_models.dart';
import 'booking_session_models.dart';
import 'cancellation_models.dart';

/// Which bucket of "My Bookings" to load. Server-side, because "upcoming"
/// means a future session date rather than a booking state.
enum BookingFilter {
  upcoming('upcoming'),
  completed('completed'),
  cancelled('cancelled');

  const BookingFilter(this.wire);

  final String wire;
}

/// §3.6 booking and §3.8 history.
class BookingRepository {
  BookingRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  /// US-C10 — the start times for one service, day and address.
  ///
  /// Pass `instructorId` once the customer has chosen a provider: it narrows
  /// the grid to that provider's own free slots instead of the union of every
  /// eligible teacher's.
  Future<ApiResult<List<SessionSlot>>> slots({
    required String serviceId,
    required DateTime date,
    required String addressId,
    String? instructorId,
  }) =>
      _api.get(
        '/app/customer/slots',
        query: {
          'serviceId': serviceId,
          'date': HfDate.wire(date),
          'addressId': addressId,
          'instructorId': ?instructorId,
        },
        parse: (data) => asMapList(data).map(SessionSlot.fromJson).toList(),
      );

  /// US-C09 / US-A09 — the breakup before payment. Creates nothing.
  ///
  /// `participantCount` may only be the package's own `persons`; anything else
  /// is a 400. With no package it is one person, one session, full price.
  Future<ApiResult<BookingQuote>> quote({
    required String serviceId,
    String? packageId,
    int? sessionCount,
    int? participantCount,
    List<String> addonIds = const [],
    double? distanceKm,
    String? couponCode,
    double? walletApplied,
  }) =>
      _api.post(
        '/app/customer/bookings/quote',
        body: _pricingBody(
          serviceId: serviceId,
          packageId: packageId,
          sessionCount: sessionCount,
          participantCount: participantCount,
          addonIds: addonIds,
          distanceKm: distanceKm,
          couponCode: couponCode,
          walletApplied: walletApplied,
        ),
        parse: (data) => BookingQuote.fromJson(asMap(data)),
      );

  /// US-C11 — submits the request. The slot is re-validated inside the
  /// transaction, so a slot taken in the meantime fails here rather than
  /// double-booking.
  ///
  /// `instructorId` is the customer's choice (§3.6): the provider is then
  /// asked to accept or reject (§4.7). Omit it to fall to the ranked
  /// auto-assign cascade.
  Future<ApiResult<BookingCreated>> create({
    required String serviceId,
    required String addressId,
    required DateTime sessionDate,
    required int fromMinute,
    required int toMinute,
    String? instructorId,
    String? packageId,
    int? sessionCount,
    int? participantCount,
    List<String> addonIds = const [],
    List<int> weekdays = const [],
    double? distanceKm,
    String? couponCode,
    double? walletApplied,
    Map<String, dynamic>? preferences,
  }) =>
      _api.post(
        '/app/customer/bookings',
        body: {
          ..._pricingBody(
            serviceId: serviceId,
            packageId: packageId,
            sessionCount: sessionCount,
            participantCount: participantCount,
            addonIds: addonIds,
            distanceKm: distanceKm,
            couponCode: couponCode,
            walletApplied: walletApplied,
          ),
          'addressId': addressId,
          'sessionDate': HfDate.wire(sessionDate),
          'fromMinute': fromMinute,
          'toMinute': toMinute,
          'instructorId': ?instructorId,
          if (weekdays.isNotEmpty) 'weekdays': weekdays,
          'preferences': ?preferences,
          // This app is the customer app; `ADMIN` is refused by the DTO.
          'source': 'APP_CUSTOMER',
        },
        parse: (data) => BookingCreated.fromJson(asMap(data)),
      );

  /// US-C13.
  Future<ApiResult<List<BookingSummary>>> bookings({BookingFilter? filter}) =>
      _api.get(
        '/app/customer/bookings',
        query: {if (filter != null) 'status': filter.wire},
        parse: (data) => asMapList(data).map(BookingSummary.fromJson).toList(),
      );

  Future<ApiResult<BookingDetail>> booking(String id) => _api.get(
        '/app/customer/bookings/$id',
        parse: (data) => BookingDetail.fromJson(asMap(data)),
      );

  /// What cancelling would refund, by policy slab. Read-only.
  Future<ApiResult<CancellationPreview>> cancellationPreview(
    String sessionId,
  ) =>
      _api.get(
        '/app/customer/sessions/$sessionId/cancellation-preview',
        parse: (data) => CancellationPreview.fromJson(asMap(data)),
      );

  /// Cancels one occurrence, not the whole booking. `mode` picks where the
  /// money goes — WALLET is instant, SOURCE goes back through the gateway.
  ///
  /// `reason` is **required** and must be at least 3 characters: it feeds the
  /// customer's reliability record, so the screen has to ask for one.
  Future<ApiResult<Map<String, dynamic>>> cancelSession(
    String sessionId, {
    required String reason,
    String? mode,
  }) =>
      _api.post(
        '/app/customer/sessions/$sessionId/cancel',
        body: {'reason': reason, 'mode': ?mode},
        parse: asMap,
      );

  /// The fields `quote` and `create` share, built once.
  Map<String, dynamic> _pricingBody({
    required String serviceId,
    String? packageId,
    int? sessionCount,
    int? participantCount,
    List<String> addonIds = const [],
    double? distanceKm,
    String? couponCode,
    double? walletApplied,
  }) =>
      {
        'serviceId': serviceId,
        'packageId': ?packageId,
        'sessionCount': ?sessionCount,
        'participantCount': ?participantCount,
        if (addonIds.isNotEmpty) 'addonIds': addonIds,
        'distanceKm': ?distanceKm,
        'couponCode': ?couponCode,
        'walletApplied': ?walletApplied,
      };
}
