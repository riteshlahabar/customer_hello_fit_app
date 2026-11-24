import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// `.checkline` on page 07 — the agreement tick above Create Account.
///
/// Terms of Service and Privacy Policy are named in orange but not tappable:
/// §5.3 puts those pages on the website, and a link to nothing is worse than
/// plain text. Wire them up when the client supplies the URLs.
class TermsCheckline extends StatelessWidget {
  const TermsCheckline({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      borderRadius: BorderRadius.circular(HFSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: value,
                onChanged: onChanged == null
                    ? null
                    : (v) => onChanged!(v ?? false),
                activeColor: HFColors.primary,
                side: const BorderSide(color: HFColors.fieldBorder, width: 1.5),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: HFSpacing.sm),
            const Expanded(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontFamily: HFFonts.body,
                    fontSize: 10,
                    height: 1.6,
                    color: HFColors.muted,
                  ),
                  children: [
                    TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: HFColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: HFColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
