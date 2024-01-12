import 'package:flutter/material.dart';

class CircuitPainter extends CustomPainter {
  final int meshes;

  CircuitPainter(this.meshes);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Drawing the outer rectangle
    double left = (size.width - size.width * 0.8) / 2;
    double top = (size.height - size.height * 0.6) / 2;
    double right = left + size.width * 0.8;
    double bottom = top + size.height * 0.6;
    Rect rect = Rect.fromLTRB(left, top, right, bottom);
    canvas.drawRect(rect, paint);

    // Drawing the vertical lines to divide the rectangle into meshes
    double meshWidth = rect.width / meshes;
    for (int i = 1; i < meshes; i++) {
      double x = left + meshWidth * i;
      canvas.drawLine(Offset(x, top), Offset(x, bottom), paint);
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}