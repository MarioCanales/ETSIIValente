import 'dart:math';

import 'package:ETSIIValente/components/current_source.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'components/resistor.dart';
import 'components/voltage_source.dart';

enum Component { resistor, voltageSource, currentSource}

class CircuitDesigner extends StatefulWidget {
  @override
  _CircuitDesignerState createState() => _CircuitDesignerState();
}

class CircuitParameters {
  static const double tolerance = 10.0;
  static const double componentRange = 40.0;
  static const double circuitWidth = 800.0;
  static const double circuitHeight = 300.0;
  static const double circuitPadding = 90.0;
  static const double imageWidth = 60.0;
  static const double imageHeight = 30.0;
}

class _CircuitDesignerState extends State<CircuitDesigner> {
  List<Resistor> resistors = [];
  List<VoltageSource> voltageSources = [];
  List<CurrentSource> currentSources = [];
  Component selectedComponent = Component.resistor;

  // Images
  ui.Image? resistorImage;
  ui.Image? voltageSourceImage;
  ui.Image? currentSourceImage;

  @override
  void initState() {
    super.initState();
    _loadImage('assets/resistor.jpg', (img) => setState(() => resistorImage = img));
    _loadImage('assets/voltajeFuente.png', (img) => setState(() => voltageSourceImage = img));
    _loadImage('assets/fuenteIntensidad.png', (img) => setState(() => currentSourceImage = img));
  }

  Future<void> _loadImage(String assetPath, Function(ui.Image) callback) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    ui.decodeImageFromList(bytes, callback);
  }

  bool _isTapOnBorder(Offset tapPosition, Rect circuitRect) {
    // Modified checks for the border to exclude the right edge
    bool nearLeft = (tapPosition.dx - circuitRect.left).abs() < CircuitParameters.tolerance;
    bool nearTopOrBottom =
        (tapPosition.dy - circuitRect.top).abs() < CircuitParameters.tolerance ||
            (tapPosition.dy - circuitRect.bottom).abs() < CircuitParameters.tolerance;

    // Check for the middle line
    double middleX = circuitRect.left + (circuitRect.width / 2);
    bool nearMiddleLine = (tapPosition.dx - middleX).abs() < CircuitParameters.tolerance;

    bool toReturn = nearLeft || nearTopOrBottom || nearMiddleLine;
    if (!toReturn) {
      print("Touch outside the circuit");
    }
    return toReturn;
  }

  bool _isTapOnComponent(Offset tapPosition) {
    bool toReturn = false;
    for (var resistor in resistors) {
      if ((tapPosition - resistor.position).distance <
          CircuitParameters.componentRange + CircuitParameters.tolerance) {
        print("Tap is too close to an existing resistor.");
        return true;
      }
    }
    for (var source in voltageSources) {
      if ((tapPosition - source.position).distance <
          CircuitParameters.componentRange + CircuitParameters.tolerance) {
        print("Tap is too close to an existing voltage source.");
        return true;
      }
    }
    for (var source in currentSources) {
      if ((tapPosition - source.position).distance <
          CircuitParameters.componentRange + CircuitParameters.tolerance) {
        print("Tap is too close to an existing current source.");
        return true;
      }
    }
    return toReturn;
  }

  Offset _adjustResistorPosition(Offset tapPosition, Rect circuitRect) {
    // Snap to the closest horizontal or vertical line within the circuit
    double x = tapPosition.dx;
    double y = tapPosition.dy;

    // Check proximity to the left border
    bool nearLeft = (x - circuitRect.left).abs() < CircuitParameters.tolerance;

    // Check proximity to the top or bottom border
    bool nearTop = (y - circuitRect.top).abs() < CircuitParameters.tolerance;
    bool nearBottom = (y - circuitRect.bottom).abs() < CircuitParameters.tolerance;

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
    if ((tapPosition.dx - middleX).abs() < CircuitParameters.tolerance) {
      x = middleX;
    }

    return Offset(x, y);
  }

  void _addComponentAtPosition(TapDownDetails details, Rect circuitRect) {
    Offset adjustedPosition =
    _adjustResistorPosition(details.localPosition, circuitRect);
    setState(() {
      if (selectedComponent == Component.resistor) {
        resistors.add(Resistor(adjustedPosition));
      } else if (selectedComponent == Component.voltageSource) {
        voltageSources.add(VoltageSource(adjustedPosition));
      } else {
        currentSources.add(CurrentSource(adjustedPosition));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diseña tu circuito'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.electrical_services),
                onPressed: () => setState(() {
                  selectedComponent = Component.resistor;
                }),
              ),
              IconButton(
                icon: Icon(Icons.battery_charging_full),
                onPressed: () => setState(() {
                  selectedComponent = Component.voltageSource;
                }),
              ),
              IconButton(
                icon: Icon(Icons.bike_scooter),
                onPressed: () => setState(() {
                  selectedComponent = Component.currentSource;
                }),
              )
            ],
          ),
          Expanded(
              child: GestureDetector(
                onTapDown: (TapDownDetails details) {
                  Rect circuitRect = const Rect.fromLTWH(CircuitParameters.circuitPadding, CircuitParameters.circuitPadding, CircuitParameters.circuitWidth, CircuitParameters.circuitHeight);
                  if (_isTapOnBorder(details.localPosition, circuitRect) &&
                      !_isTapOnComponent(details.localPosition)) {
                    _addComponentAtPosition(details, circuitRect);
                  }
                },
                child: Container(
                  height: 1300,
                  width: double.infinity,
                  color: Colors.white,
                  child: CustomPaint(
                    painter: CircuitPainter(resistors, voltageSources, currentSources, resistorImage, voltageSourceImage, currentSourceImage),
                  ),
                ),
              ),
          )
        ],
      )
    );
  }
}

class CircuitPainter extends CustomPainter {
  final List<Resistor> resistors;
  final List<VoltageSource> voltageSources;
  final List<CurrentSource> currentSources;
  final ui.Image? resistorImage;
  final ui.Image? voltageSourceImage;
  final ui.Image? currentSourceImage;

  CircuitPainter(this.resistors, this.voltageSources, this.currentSources, this.resistorImage, this.voltageSourceImage, this.currentSourceImage);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke; // Draw only the outline

    Rect circuitRect = const Rect.fromLTWH(CircuitParameters.circuitPadding, CircuitParameters.circuitPadding, CircuitParameters.circuitWidth, CircuitParameters.circuitHeight);

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
      resistors.forEach((resistor) => _drawComponent(canvas, resistorImage!, resistor.position));
      voltageSources.forEach((source) => _drawComponent(canvas, voltageSourceImage!, source.position));
      currentSources.forEach((source) => _drawComponent(canvas, currentSourceImage!, source.position));
    }
  }

  void _drawComponent(Canvas canvas, ui.Image image, Offset position) {
    bool isVerticalLine =
        position.dx == CircuitParameters.circuitPadding || // Left vertical line
            position.dx == CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 2;

    Rect destRect = Rect.fromCenter(
      center: position,
      width: isVerticalLine
          ? CircuitParameters.imageHeight
          : CircuitParameters.imageWidth, // Swap dimensions if vertical
      height: isVerticalLine ? CircuitParameters.imageWidth : CircuitParameters.imageHeight,
    );
    canvas.save();

    // If the resistor is on a vertical line, apply rotation
    if (isVerticalLine) {
      canvas.translate(position.dx, position.dy);
      canvas.rotate(pi / 2);
      canvas.translate(-position.dx, -position.dy);
    }
    // Draw the image
    canvas.drawImageRect(
      image,
      Rect.fromLTRB(0, 0, image.width.toDouble(),
          image.height.toDouble()),
      destRect,
      Paint(),
    );
    // Restore the canvas to the previous state
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
