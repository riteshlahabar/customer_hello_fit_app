import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// The orange call-to-action the designs repeat on every screen: full width,
/// 52 high, 13 radius, a soft orange shadow and a trailing arrow.
///
/// [busy] swaps the label for a spinner and disables the press, which is what
/// every network-backed screen here needs; it is not a separate widget
/// because a disabled button and a working button must not move the layout.
class HFPrimaryButton extends StatelessWidget {
  const HFPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.arrow = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final bool arrow;

  @override
  Widget build(BuildContext context) {
    final enabled = !busy && onPressed != null;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        boxShadow: enabled
            ? const [
                BoxShadow(
                  color: Color(0x33E33E29),
                  blurRadius: 20,
                  offset: Offset(0, 9),
                ),
              ]
            : null,
      ),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: HFColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: HFColors.primary.withValues(alpha: 0.45),
            disabledForegroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          child: busy
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: HFFonts.body,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (arrow) ...[
                      const SizedBox(width: 9),
                      const Text('→', style: TextStyle(fontSize: 17)),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
