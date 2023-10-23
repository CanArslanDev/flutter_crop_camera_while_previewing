import 'package:flutter/material.dart';

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sh = size.height; // for convenient shortage
    final sw = size.width; // for convenient shortage
    final cornerSide = sh * 0.1; // desirable value for corners side
    final midSide = sh * 0.05;
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(cornerSide, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide)
      ..moveTo(0, sh - cornerSide)
      ..quadraticBezierTo(0, sh, cornerSide, sh)
      ..moveTo(sw - cornerSide, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
      ..moveTo(sw, cornerSide)
      ..quadraticBezierTo(sw, 0, sw - cornerSide, 0)
      // add the following lines to draw the middle sides
      ..moveTo(sw / 2 - midSide, 0)
      ..lineTo(sw / 2 + midSide, 0)
      ..moveTo(0, sh / 2 - midSide)
      ..lineTo(0, sh / 2 + midSide)
      ..moveTo(sw / 2 - midSide, sh)
      ..lineTo(sw / 2 + midSide, sh)
      ..moveTo(sw, sh / 2 - midSide)
      ..lineTo(sw, sh / 2 + midSide);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
