import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// The HelloFit mark as the client supplied it — one square badge used on
/// every screen of the design set.
///
/// The artwork carries its own orange ground, so it is never tinted and never
/// sits on a coloured plate; [height] is the only thing a screen chooses.
class HFLogo extends StatelessWidget {
  const HFLogo({super.key, this.height = 48, this.shadow = false});

  final double height;

  /// Page 02-04 drop a soft shadow under the mark because it sits on a
  /// photograph; on a white screen it is drawn flat.
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      HFAssets.logo,
      height: height,
      width: height,
      fit: BoxFit.contain,
      // A missing asset must not take the whole screen down with it.
      errorBuilder: (_, _, _) => SizedBox(height: height, width: height),
    );

    if (!shadow) return image;

    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Color(0x88000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: image,
    );
  }
}
