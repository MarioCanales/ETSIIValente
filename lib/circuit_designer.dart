import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/resistor.dart';

class CircuitDesigner extends StatefulWidget {
  @override
  _CircuitDesignerState createState() => _CircuitDesignerState();
}

class _CircuitDesignerState extends State<CircuitDesigner> {
  List<Resistor> resistors = [];
  final double borderWidth = 10; // Width of the border for tap detection
  final double resistorRadius = 40;
  final double circuitWidth = 800; // Fixed width for the circuit
  final double circuitHeight = 300; // Fixed height for the circuit


  ui.Image? resistorImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final ByteData data = await rootBundle.load('assets/resistor.jpg');
    final Uint8List bytes = data.buffer.asUint8List();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      setState(() {
        resistorImage = img;
      });
    });
  }

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

      // Check proximity to the left border
      bool nearLeft = (x - circuitRect.left).abs() < borderWidth;

      // Check proximity to the top or bottom border
      bool nearTop = (y - circuitRect.top).abs() < borderWidth;
      bool nearBottom = (y - circuitRect.bottom).abs() < borderWidth;

      // Adjust x, y to snap to the nearest line
      if (nearLeft) {
        x = circuitRect.left;
      }

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
            painter: CircuitPainter(resistors, resistorImage),
          ),
        ),
      ),
    );
  }
}

class CircuitPainter extends CustomPainter {
  final List<Resistor> resistors;
  final ui.Image? resistorImage;

  CircuitPainter(this.resistors, this.resistorImage);

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

    // Draw the resistor image at each position
    if (resistorImage != null) {
      for (final resistor in resistors) {
        bool isVerticalLine = resistor.position.dx == 90 || // Left vertical line
            resistor.position.dx == 90 + 800 / 2; // Middle vertical line

        final double imageWidth = 60.0;
        final double imageHeight = 30.0;
        Rect destRect = Rect.fromCenter(
          center: resistor.position,
          width: isVerticalLine ? imageHeight : imageWidth, // Swap dimensions if vertical
          height: isVerticalLine ? imageWidth : imageHeight,
        );
        // Save the current canvas state
        canvas.save();

        // If the resistor is on a vertical line, apply rotation
        if (isVerticalLine) {
          // Translate to the resistor's position to set the pivot point for rotation
          canvas.translate(resistor.position.dx, resistor.position.dy);
          // Rotate 90 degrees (π/2 radians)
          canvas.rotate(pi / 2);
          // Translate back
          canvas.translate(-resistor.position.dx, -resistor.position.dy);
        }

        // Draw the image
        canvas.drawImageRect(
          resistorImage!,
          Rect.fromLTRB(0, 0, resistorImage!.width.toDouble(), resistorImage!.height.toDouble()),
          destRect,
          Paint(),
        );

        // Restore the canvas to the previous state
        canvas.restore();
      }
    }
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}

