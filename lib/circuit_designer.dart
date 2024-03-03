
import 'package:flutter/material.dart';

import 'components/resistor.dart';

class CircuitDesigner extends StatefulWidget {
  @override
  _CircuitDesignerState createState() => _CircuitDesignerState();
}

class _CircuitDesignerState extends State<CircuitDesigner> {
  List<Resistor> resistors = [];
  final double borderWidth = 10; // Width of the border for tap detection
  final double resistorRadius = 5;
  final double circuitWidth = 800; // Fixed width for the circuit
  final double circuitHeight = 300; // Fixed height for the circuit

  bool _isTapOnBorder(Offset tapPosition, Rect circuitRect) {
    // Modified checks for the border to exclude the right edge
    bool nearLeft = (tapPosition.dx - circuitRect.left).abs() < borderWidth;
    bool nearTopOrBottom =
        (tapPosition.dy - circuitRect.top).abs() < borderWidth ||
            (tapPosition.dy - circuitRect.bottom).abs() < borderWidth;

    // Check for the middle line
    double middleX = circuitRect.left + (circuitRect.width / 2);
    bool nearMiddleLine = (tapPosition.dx - middleX).abs() < borderWidth;

    bool toReturn = nearLeft || nearTopOrBottom || nearMiddleLine;
    if (!toReturn) {
      print("Touch outside the circuit");
    }
    return toReturn;
  }

  bool _isTapOnResistor(Offset tapPosition) {
    for (var resistor in resistors) {
      if ((tapPosition - resistor.position).distance < resistorRadius + borderWidth) {
        print("Tap is too close to an existing resistor.");
        return true;
      }
    }
    return false;
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
              90, 90, circuitWidth, circuitHeight);
          if (_isTapOnBorder(details.localPosition, circuitRect) && !_isTapOnResistor(details.localPosition)) {
            setState(() {
              resistors.add(Resistor(details.localPosition));
            });
          }
        },
        child: Container(
          height: 1300,
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

    // Calculate the rectangle parameters
    Rect circuitRect = Rect.fromLTWH(90, 90, 800, 300);

    // Draw the top line
    canvas.drawLine(
      Offset(circuitRect.left, circuitRect.top),
      Offset(circuitRect.right, circuitRect.top),
      paint,
    );

    // Draw the bottom line
    canvas.drawLine(
      Offset(circuitRect.left, circuitRect.bottom),
      Offset(circuitRect.right, circuitRect.bottom),
      paint,
    );

    // Draw the left vertical line
    canvas.drawLine(
      Offset(circuitRect.left, circuitRect.top),
      Offset(circuitRect.left, circuitRect.bottom),
      paint,
    );

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