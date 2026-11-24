import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// The 76px tinted panel at the top of page 06, holding the design's inline
/// SVG: an outlined document with three rules and a ticked badge.
///
/// Drawn with a painter rather than shipped as an asset — it is four strokes
/// and a circle, and this way it takes its colours from the tokens.
class OtpVerifyIcon extends StatelessWidget {
  const OtpVerifyIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: HFColors.iconWash,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: SizedBox.square(dimension: 39, child: CustomPaint(painter: _Glyph())),
      ),
    );
  }
}

class _Glyph extends CustomPainter {
  const _Glyph();

  @override
  void paint(Canvas canvas, Size size) {
    // The design's SVG is drawn on a 48-unit grid.
    final k = size.width / 48;

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..color = HFColors.primary
      ..strokeWidth = 2.5 * k
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(8 * k, 5 * k, 32 * k, 38 * k),
        Radius.circular(7 * k),
      ),
      stroke,
    );

    for (final (y, right) in const [(17.0, 33.0), (24.0, 33.0), (31.0, 25.0)]) {
      canvas.drawLine(
        Offset(15 * k, y * k),
        Offset(right * k, y * k),
        stroke,
      );
    }

    // The badge sits over the document's lower-right corner and is filled,
    // so it has to be painted after the rules it covers.
    canvas.drawCircle(
      Offset(35 * k, 34 * k),
      7 * k,
      Paint()..color = HFColors.primary,
    );

    canvas.drawPath(
      Path()
        ..moveTo(32 * k, 34 * k)
        ..lineTo(34 * k, 36 * k)
        ..lineTo(38 * k, 32 * k),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white
        ..strokeWidth = 1.8 * k
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_Glyph oldDelegate) => false;
}
