import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// The one way an auth screen reports a refusal: orange, small, under the
/// field it belongs to. A SnackBar would disappear while the customer is
/// still reading it.
class FormErrorText extends StatelessWidget {
  const FormErrorText(this.message, {super.key, this.align = TextAlign.left});

  final String message;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Text(
        message,
        textAlign: align,
        style: const TextStyle(
          fontFamily: HFFonts.body,
          fontSize: 11,
          height: 1.5,
          fontWeight: FontWeight.w500,
          color: HFColors.primary,
        ),
      ),
    );
  }
}
