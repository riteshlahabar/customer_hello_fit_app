import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// The number under the heading on page 06, with its Edit link.
class OtpNumberLine extends StatelessWidget {
  const OtpNumberLine({super.key, required this.mobile, required this.onEdit});

  final String mobile;
  final VoidCallback? onEdit;

  /// `9876543210` reads as `+91 98765 43210`, as the design shows it.
  String get _pretty => mobile.length == 10
      ? '+91 ${mobile.substring(0, 5)} ${mobile.substring(5)}'
      : '+91 $mobile';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _pretty,
          style: const TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: HFColors.ink,
          ),
        ),
        const SizedBox(width: 7),
        GestureDetector(
          onTap: onEdit,
          child: const Text(
            'Edit',
            style: TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: HFColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

/// "Didn't receive the code? Resend OTP" — with the countdown that keeps the
/// five-a-minute send limit from turning into a wall of 429s.
class OtpResendLine extends StatelessWidget {
  const OtpResendLine({
    super.key,
    required this.canResend,
    required this.secondsLeft,
    required this.notice,
    required this.onResend,
  });

  final bool canResend;
  final int secondsLeft;
  final String? notice;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    if (notice != null && !canResend) {
      return Text(
        '$notice Resend again in ${secondsLeft}s.',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: HFFonts.body,
          fontSize: 10.5,
          color: HFColors.success,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Didn't receive the code? ",
          style: TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 10.5,
            color: HFColors.softMuted,
          ),
        ),
        GestureDetector(
          onTap: canResend ? onResend : null,
          child: Text(
            canResend ? 'Resend OTP' : 'Resend in ${secondsLeft}s',
            style: TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: canResend ? HFColors.primary : HFColors.faintMuted,
            ),
          ),
        ),
      ],
    );
  }
}

/// "Wrong number? Change mobile number" — a pop back to the login screen.
class OtpChangeNumberLine extends StatelessWidget {
  const OtpChangeNumberLine({super.key, required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Wrong number? ',
          style: TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 10.5,
            color: HFColors.softMuted,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'Change mobile number',
            style: TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: HFColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}
