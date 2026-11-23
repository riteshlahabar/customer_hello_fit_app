import '../../../core/network/json.dart';

/// `GET /app/customer/sessions/:id/cancellation-preview` — what cancelling
/// now would cost, before the customer commits to it.
class CancellationPreview {
  const CancellationPreview({
    required this.sessionId,
    required this.sessionValue,
    required this.cancellable,
    required this.refundPercent,
    required this.refundAmount,
    required this.mode,
    this.slab,
  });

  factory CancellationPreview.fromJson(Map<String, dynamic> json) =>
      CancellationPreview(
        sessionId: asString(json['sessionId']),
        sessionValue: asDouble(json['sessionValue']),
        cancellable: asBool(json['cancellable']),
        refundPercent: asDouble(json['refundPercent']),
        refundAmount: asDouble(json['refundAmount']),
        mode: asString(json['mode'], fallback: 'WALLET'),
        slab: json['slab'] as String?,
      );

  final String sessionId;
  final double sessionValue;

  /// False once the session is finished or already cancelled.
  final bool cancellable;

  /// Which policy slab applies, e.g. `MORE_THAN_24H`.
  final String? slab;
  final double refundPercent;

  /// Zero on an unpaid booking — there is nothing to give back.
  final double refundAmount;

  /// WALLET or SOURCE.
  final String mode;
}
