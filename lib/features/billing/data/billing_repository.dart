import '../../../core/dates/hf_date.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/json.dart';

/// §3.8's money trail: invoices and refunds, both read-only.
///
/// An invoice is raised when a payment settles and a refund when a session is
/// cancelled; a customer-facing create would be a second, competing source of
/// money records. Both lists are filtered by the owning booking server-side.
class BillingRepository {
  BillingRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  Future<ApiResult<List<Invoice>>> invoices({int? page, int? limit}) =>
      _api.get(
        '/app/customer/invoices',
        query: {
          'page': ?page,
          'limit': ?limit,
        },
        parse: (data) => asMapList(data).map(Invoice.fromJson).toList(),
      );

  /// One booking's invoice, for the download button on a booking screen.
  Future<ApiResult<Invoice>> invoiceForBooking(String bookingId) => _api.get(
        '/app/customer/invoices/$bookingId',
        parse: (data) => Invoice.fromJson(asMap(data)),
      );

  Future<ApiResult<List<RefundRecord>>> refunds({int? page, int? limit}) =>
      _api.get(
        '/app/customer/refunds',
        query: {
          'page': ?page,
          'limit': ?limit,
        },
        parse: (data) => asMapList(data).map(RefundRecord.fromJson).toList(),
      );
}

class Invoice {
  const Invoice({
    required this.id,
    required this.invoiceNo,
    required this.taxableValue,
    required this.total,
    required this.bookingCode,
    required this.serviceName,
    required this.taxBreakup,
    this.issuedAt,
    this.pdfUrl,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    final booking = asMap(json['booking']);

    return Invoice(
      id: asString(json['id']),
      invoiceNo: asString(json['invoiceNo']),
      taxableValue: asDouble(json['taxableValue']),
      total: asDouble(json['total']),
      bookingCode: asString(booking['code']),
      serviceName: asString(asMap(booking['service'])['name']),
      taxBreakup: asMap(json['taxBreakup'])
          .map((key, value) => MapEntry(key, asDouble(value))),
      issuedAt: HfDate.parse(json['issuedAt']),
      pdfUrl: json['pdfUrl'] as String?,
    );
  }

  final String id;

  /// `HF/2026-27/000001`.
  final String invoiceNo;
  final double taxableValue;
  final double total;
  final String bookingCode;
  final String serviceName;

  /// CGST/SGST/IGST lines. Passed through as stored, because the split varies
  /// by state and the app must not re-derive it.
  final Map<String, double> taxBreakup;
  final DateTime? issuedAt;
  final String? pdfUrl;

  double get tax => total - taxableValue;
}

class RefundRecord {
  const RefundRecord({
    required this.id,
    required this.amount,
    required this.mode,
    required this.status,
    required this.bookingCode,
    required this.serviceName,
    this.slabApplied,
    this.processedAt,
    this.createdAt,
  });

  factory RefundRecord.fromJson(Map<String, dynamic> json) {
    final booking = asMap(json['booking']);

    return RefundRecord(
      id: asString(json['id']),
      amount: asDouble(json['amount']),
      mode: asString(json['mode'], fallback: 'WALLET'),
      status: asString(json['status'], fallback: 'PENDING'),
      bookingCode: asString(booking['code']),
      serviceName: asString(asMap(booking['service'])['name']),
      slabApplied: json['slabApplied'] as String?,
      processedAt: HfDate.parse(json['processedAt']),
      createdAt: HfDate.parse(json['createdAt']),
    );
  }

  final String id;
  final double amount;

  /// WALLET or SOURCE.
  final String mode;

  /// PENDING, PROCESSING, COMPLETED or FAILED.
  final String status;
  final String bookingCode;
  final String serviceName;

  /// Which cancellation slab produced the amount, e.g. `MORE_THAN_24H`.
  final String? slabApplied;
  final DateTime? processedAt;
  final DateTime? createdAt;
}
