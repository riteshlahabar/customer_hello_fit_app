import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// The mobile number on page 07, shown as a settled fact rather than an
/// input: it is the identity that was just verified by OTP, and changing it
/// means signing in with the other number.
class VerifiedMobileField extends StatelessWidget {
  const VerifiedMobileField({super.key, required this.mobile});

  final String mobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mobile number',
          style: TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: HFColors.labelInk,
          ),
        ),
        const SizedBox(height: HFSpacing.sm),
        Container(
          height: 51,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: HFColors.pageBackground,
            borderRadius: BorderRadius.circular(HFRadius.control),
            border: Border.all(color: HFColors.fieldBorder),
          ),
          child: Row(
            children: [
              const Text(
                '+91',
                style: TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 12,
                  color: HFColors.muted,
                ),
              ),
              const SizedBox(width: 10),
              Container(width: 1, height: 22, color: HFColors.fieldBorder),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  mobile,
                  style: const TextStyle(
                    fontFamily: HFFonts.body,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: HFColors.ink,
                  ),
                ),
              ),
              const Text(
                'Verified',
                style: TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: HFColors.success,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
