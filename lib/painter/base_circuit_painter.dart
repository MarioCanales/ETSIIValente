import 'package:flutter/material.dart';

abstract class BaseCircuitPainter extends CustomPainter {
  final int meshes;
  BaseCircuitPainter(this.meshes);

  late double left;
  late double top;
  late double right;
  late double bottom;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Drawing the outer rectangle
    assignBorders(size);
    Rect rect = Rect.fromLTRB(left, top, right, bottom);
    canvas.drawRect(rect, paint);

    // Drawing the vertical lines to divide the rectangle into meshes
    double meshWidth = rect.width / meshes;
    for (int i = 1; i < meshes; i++) {
      double x = left + meshWidth * i;
      canvas.drawLine(Offset(x, top), Offset(x, bottom), paint);
    }

  }

  void assignBorders(Size size) {
    left = (size.width - size.width * 0.8) / 2;
    top = (size.height - size.height * 0.6) / 2;
    right = left + size.width * 0.8;
    bottom = top + size.height * 0.6;
  }



  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}