import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/json.dart';
import 'payment_models.dart';

/// §3.7 payment, the wallet, and the coupon check that precedes both.
class PaymentRepository {
  PaymentRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  /// Opens (or reuses) a gateway order for an unpaid booking. A customer who
  /// backgrounds the app and returns gets the same order, not a second one.
  Future<ApiResult<PaymentOrder>> createOrder(String bookingId) => _api.post(
        '/app/customer/payments/order',
        body: {'bookingId': bookingId},
        parse: (data) => PaymentOrder.fromJson(asMap(data)),
      );

  /// US-C12 — reports the gateway's result back for server-side verification.
  ///
  /// Always send an `idempotencyKey`: a retried verify then returns the
  /// original result instead of settling twice. The webhook does the same work
  /// independently, so whichever arrives first wins.
  Future<ApiResult<PaymentResult>> verify({
    required String bookingId,
    required String gatewayOrderId,
    required String gatewayPaymentId,
    required String signature,
    String? idempotencyKey,
  }) =>
      _api.post(
        '/app/customer/payments/verify',
        body: {
          'bookingId': bookingId,
          'gatewayOrderId': gatewayOrderId,
          'gatewayPaymentId': gatewayPaymentId,
          'signature': signature,
          'idempotencyKey': ?idempotencyKey,
        },
        parse: (data) => PaymentResult.fromJson(asMap(data)),
      );

  /// Settles with no gateway at all, for a machine with no Razorpay keys.
  /// **403 the moment a real gateway is configured**, so this is only ever a
  /// fallback for [PaymentOrder.isDevelopmentGateway].
  Future<ApiResult<PaymentResult>> devSettle(String bookingId) => _api.post(
        '/app/customer/payments/dev-settle',
        body: {'bookingId': bookingId},
        parse: (data) => PaymentResult.fromJson(asMap(data)),
      );

  /// Pays the whole booking from wallet credit. Fails if the balance is short
  /// — there is no partial wallet payment at the gateway step.
  Future<ApiResult<PaymentResult>> payFromWallet(String bookingId) => _api.post(
        '/app/customer/payments/wallet',
        body: {'bookingId': bookingId},
        parse: (data) => PaymentResult.fromJson(asMap(data)),
      );

  Future<ApiResult<WalletBalance>> wallet() => _api.get(
        '/app/customer/wallet',
        parse: (data) => WalletBalance.fromJson(asMap(data)),
      );

  Future<ApiResult<List<WalletTransaction>>> walletTransactions() => _api.get(
        '/app/customer/wallet/transactions',
        parse: (data) =>
            asMapList(data).map(WalletTransaction.fromJson).toList(),
      );

  /// Checks a promotional code against an amount before payment. A bad code is
  /// a 400 with `COUPON_INVALID`, which the screen shows rather than retries.
  Future<ApiResult<CouponCheck>> validateCoupon({
    required String code,
    required double amount,
  }) =>
      _api.post(
        '/app/customer/coupons/validate',
        body: {'code': code, 'amount': amount},
        parse: (data) => CouponCheck.fromJson(asMap(data)),
      );
}
