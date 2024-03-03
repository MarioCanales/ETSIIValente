
import 'package:flutter/material.dart';

import 'components/resistor.dart';

class CircuitDesigner extends StatefulWidget {
  @override
  _CircuitDesignerState createState() => _CircuitDesignerState();
}

class _CircuitDesignerState extends State<CircuitDesigner> {
  List<Resistor> resistors = [];
  final double borderWidth = 10; // Width of the border for tap detection
  final double resistorRadius = 10;
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

    Offset _adjustResistorPosition(Offset tapPosition, Rect circuitRect) {
      // Snap to the closest horizontal or vertical line within the circuit
      double x = tapPosition.dx;
      double y = tapPosition.dy;

      // Check proximity to the left or right border (if it were included)
      bool nearLeft = (x - circuitRect.left).abs() < borderWidth;
      // bool nearRight = (x - circuitRect.right).abs() < borderWidth; // For future use if right border is included

      // Check proximity to the top or bottom border
      bool nearTop = (y - circuitRect.top).abs() < borderWidth;
      bool nearBottom = (y - circuitRect.bottom).abs() < borderWidth;

      // Adjust x, y to snap to the nearest line
      if (nearLeft) {
        x = circuitRect.left;
      } /* else if (nearRight) {
    x = circuitRect.right; // Uncomment if right border logic is included
  }*/

      if (nearTop) {
        y = circuitRect.top;
      } else if (nearBottom) {
        y = circuitRect.bottom;
      }

      // For the middle line, adjust x to be the middle of the circuit
      double middleX = circuitRect.left + (circuitRect.width / 2);
      if ((tapPosition.dx - middleX).abs() < borderWidth) {
        x = middleX;
      }

      return Offset(x, y);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Electric Circuit Designer'),
      ),
      body: GestureDetector(
        onTapDown: (TapDownDetails details) {
          Rect circuitRect = Rect.fromLTWH(
              90, 90, circuitWidth, circuitHeight);
          if (_isTapOnBorder(details.localPosition, circuitRect) && !_isTapOnResistor(details.localPosition)) {
            Offset adjustedPosition = _adjustResistorPosition(details.localPosition, circuitRect);
            setState(() {
              resistors.add(Resistor(adjustedPosition));
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
      canvas.drawCircle(resistor.position, 10, resistorPaint);
    }
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

