
import 'package:flutter/material.dart';

import 'components/resistor.dart';

class CircuitDesigner extends StatefulWidget {
  @override
  _CircuitDesignerState createState() => _CircuitDesignerState();
}

class _CircuitDesignerState extends State<CircuitDesigner> {
  List<Resistor> resistors = [];
  final double borderWidth = 10; // Width of the border for tap detection

  bool _isTapOnBorder(Offset tapPosition, Rect circuitRect) {
    // Existing checks for the border
    bool nearLeftOrRight =
        (tapPosition.dx - circuitRect.left).abs() < borderWidth ||
            (tapPosition.dx - circuitRect.right).abs() < borderWidth;
    bool nearTopOrBottom =
        (tapPosition.dy - circuitRect.top).abs() < borderWidth ||
            (tapPosition.dy - circuitRect.bottom).abs() < borderWidth;

    // Check for the middle line (now vertical)
    double middleX = circuitRect.left + (circuitRect.width / 2);
    bool nearMiddleLine = (tapPosition.dx - middleX).abs() < borderWidth;

    return nearLeftOrRight || nearTopOrBottom || nearMiddleLine;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electric Circuit Designer'),
      ),
      body: GestureDetector(
        onTapDown: (TapDownDetails details) {
          Rect circuitRect = Rect.fromLTWH(
              50, 50, MediaQuery.of(context).size.width - 100, 200);
          if (_isTapOnBorder(details.localPosition, circuitRect)) {
            setState(() {
              resistors.add(Resistor(details.localPosition));
            });
          }
        },
        child: Container(
          height: 300,
          width: double.infinity,
          color: Colors.white,
          child: CustomPaint(
            painter: CircuitPainter(resistors),
          ),
        ),
      ),
    );
  }
}

class CircuitPainter extends CustomPainter {
  final List<Resistor> resistors;

  CircuitPainter(this.resistors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke; // Draw only the outline

    // Draw the outer rectangle
    Rect circuitRect = Rect.fromLTWH(50, 50, size.width - 100, 200);
    canvas.drawRect(circuitRect, paint);

    // Draw the subdividing line vertically in the middle
    double middleX = circuitRect.left + (circuitRect.width / 2);
    Offset startMiddleLine = Offset(middleX, circuitRect.top);
    Offset endMiddleLine = Offset(middleX, circuitRect.bottom);
    canvas.drawLine(startMiddleLine, endMiddleLine, paint);

    // Draw resistors as small circles on the circuit border
    final resistorPaint = Paint()..color = Colors.blue;
    for (var resistor in resistors) {
      canvas.drawCircle(resistor.position, 5, resistorPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}