import '../../../core/dates/hf_date.dart';
import '../../../core/network/json.dart';

/// `POST /app/customer/payments/order` — what the Razorpay sheet needs.
///
/// `gateway` is `RAZORPAY` when credentials are configured and `MANUAL`
/// otherwise. On a MANUAL order the `publicKey` is the placeholder `dev_key`,
/// which the real sheet rejects — that machine settles through `devSettle`
/// instead, and the app should branch on [isDevelopmentGateway].
class PaymentOrder {
  const PaymentOrder({
    required this.paymentId,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.gateway,
    this.publicKey,
  });

  factory PaymentOrder.fromJson(Map<String, dynamic> json) => PaymentOrder(
        paymentId: asString(json['paymentId']),
        orderId: asString(json['orderId']),
        amount: asDouble(json['amount']),
        currency: asString(json['currency'], fallback: 'INR'),
        gateway: asString(json['gateway'], fallback: 'MANUAL'),
        publicKey: json['publicKey'] as String?,
      );

  final String paymentId;
  final String orderId;
  final double amount;
  final String currency;
  final String gateway;
  final String? publicKey;

  bool get isDevelopmentGateway => gateway != 'RAZORPAY';
}

/// What a settlement answers with: the payment, the invoice it raised and the
/// offers the confirmation kicked off.
class PaymentResult {
  const PaymentResult({
    required this.paymentId,
    required this.status,
    required this.replayed,
    this.invoiceNo,
    this.paymentStatus,
    this.offeredSessions = 0,
    this.totalSessions = 0,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    final offers = asMapList(json['offers']);

    return PaymentResult(
      paymentId: asString(json['paymentId']),
      status: asString(json['status']),
      replayed: asBool(json['replayed']),
      invoiceNo: asMap(json['invoice'])['invoiceNo'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      offeredSessions:
          offers.where((o) => asBool(o['offered'])).length,
      totalSessions: offers.length,
    );
  }

  final String paymentId;

  /// CAPTURED on success.
  final String status;

  /// True when an idempotent retry returned the original result.
  final bool replayed;
  final String? invoiceNo;

  /// The booking's status after settlement — `PAID`.
  final String? paymentStatus;

  /// How many occurrences actually reached a provider. A shortfall is not an
  /// error: the money is taken and the rest sits in the admin queue.
  final int offeredSessions;
  final int totalSessions;

  bool get isCaptured => status == 'CAPTURED';
}

class WalletBalance {
  const WalletBalance({required this.balance, required this.currency});

  factory WalletBalance.fromJson(Map<String, dynamic> json) => WalletBalance(
        balance: asDouble(json['balance']),
        currency: asString(json['currency'], fallback: 'INR'),
      );

  final double balance;
  final String currency;
}

/// One line of the wallet ledger. `runningBalance` is stored, not computed by
/// the app — the ledger is the record.
class WalletTransaction {
  const WalletTransaction({
    required this.id,
    required this.direction,
    required this.amount,
    required this.source,
    required this.runningBalance,
    this.reason,
    this.referenceType,
    this.referenceId,
    this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      WalletTransaction(
        id: asString(json['id']),
        direction: asString(json['direction']),
        amount: asDouble(json['amount']),
        source: asString(json['source']),
        runningBalance: asDouble(json['runningBalance']),
        reason: json['reason'] as String?,
        referenceType: json['referenceType'] as String?,
        referenceId: json['referenceId'] as String?,
        createdAt: HfDate.parse(json['createdAt']),
      );

  final String id;

  /// CREDIT or DEBIT.
  final String direction;
  final double amount;

  /// REFUND, GOODWILL, CASHBACK, REFERRAL, BOOKING_PAYMENT …
  final String source;
  final double runningBalance;
  final String? reason;
  final String? referenceType;
  final String? referenceId;
  final DateTime? createdAt;

  bool get isCredit => direction == 'CREDIT';
}

/// `POST /app/customer/coupons/validate` — US-A09's "discount displayed
/// before payment". The server computes the figure; a `discount` the client
/// sends with a code is ignored.
class CouponCheck {
  const CouponCheck({
    required this.couponId,
    required this.code,
    required this.discountType,
    required this.discount,
    required this.payable,
    this.usageLimit,
  });

  factory CouponCheck.fromJson(Map<String, dynamic> json) => CouponCheck(
        couponId: asString(json['couponId']),
        code: asString(json['code']),
        discountType: asString(json['discountType'], fallback: 'FLAT'),
        discount: asDouble(json['discount']),
        payable: asDouble(json['payable']),
        usageLimit: json['usageLimit'] == null
            ? null
            : asInt(json['usageLimit']),
      );

  final String couponId;
  final String code;

  /// PERCENT or FLAT.
  final String discountType;
  final double discount;

  /// The amount after the discount, for the line the screen shows.
  final double payable;
  final int? usageLimit;
}
