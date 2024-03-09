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

class _CircuitDesignerState extends State<CircuitDesigner> {
  List<Resistor> resistors = [];
  List<VoltageSource> voltageSources = [];
  List<CurrentSource> currentSources = [];
  Component selectedComponent = Component.resistor;
  // Circuit params
  final double borderWidth =
      10; // Width of the border for tap detection (tolerance)
  final double resistorRadius = 40; // TODO: move to image width ?
  final double circuitWidth = 800; // Fixed width for the circuit
  final double circuitHeight = 300; // Fixed height for the circuit

  // Images
  ui.Image? resistorImage;
  ui.Image? voltageSourceImage;
  ui.Image? currentSourceImage;

  @override
  void initState() {
    super.initState();
    _loadResistorImage();
    _loadVoltageSourceImage();
    _loadCurrentSourceImage();
  }

  Future<void> _loadResistorImage() async {
    final ByteData data = await rootBundle.load('assets/resistor.jpg');
    final Uint8List bytes = data.buffer.asUint8List();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      setState(() {
        resistorImage = img;
      });
    });
  }

  Future<void> _loadVoltageSourceImage() async {
    final ByteData data = await rootBundle.load('assets/voltajeFuente.png');
    final Uint8List bytes = data.buffer.asUint8List();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      setState(() {
        voltageSourceImage = img;
      });
    });
  }

  Future<void> _loadCurrentSourceImage() async {
    final ByteData data = await rootBundle.load('assets/fuenteIntensidad.png');
    final Uint8List bytes = data.buffer.asUint8List();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      setState(() {
        currentSourceImage = img;
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

  bool _isTapOnComponent(Offset tapPosition) {
    bool toReturn = false;
    for (var resistor in resistors) {
      if ((tapPosition - resistor.position).distance <
          resistorRadius + borderWidth) {
        print("Tap is too close to an existing resistor.");
        return true;
      }
    }
    for (var source in voltageSources) {
      if ((tapPosition - source.position).distance <
          resistorRadius + borderWidth) {
        print("Tap is too close to an existing voltage source.");
        return true;
      }
    }
    for (var source in currentSources) {
      if ((tapPosition - source.position).distance <
          resistorRadius + borderWidth) {
        print("Tap is too close to an existing current source.");
        return true;
      }
    }
    return toReturn;
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
                  Rect circuitRect = Rect.fromLTWH(90, 90, circuitWidth, circuitHeight);
                  if (_isTapOnBorder(details.localPosition, circuitRect) &&
                      !_isTapOnComponent(details.localPosition)) {
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

    // Calculate the rectangle parameters
    // TODO: move to constants? calculate it in a separate method?
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
        bool isVerticalLine =
            resistor.position.dx == 90 || // Left vertical line
                resistor.position.dx == 90 + 800 / 2; // Middle vertical line

        final double imageWidth = 60.0;
        final double imageHeight = 30.0;
        Rect destRect = Rect.fromCenter(
          center: resistor.position,
          width: isVerticalLine
              ? imageHeight
              : imageWidth, // Swap dimensions if vertical
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
          Rect.fromLTRB(0, 0, resistorImage!.width.toDouble(),
              resistorImage!.height.toDouble()),
          destRect,
          Paint(),
        );

        // Restore the canvas to the previous state
        canvas.restore();
      }
    }

    // TODO: refactor -> extract common logic into a method
    if (voltageSourceImage != null) {
      for (final source in voltageSources) {
        bool isVerticalLine =
            source.position.dx == 90 || // Left vertical line
                source.position.dx == 90 + 800 / 2; // Middle vertical line

        final double imageWidth = 60.0;
        final double imageHeight = 30.0;
        Rect destRect = Rect.fromCenter(
          center: source.position,
          width: isVerticalLine
              ? imageHeight
              : imageWidth, // Swap dimensions if vertical
          height: isVerticalLine ? imageWidth : imageHeight,
        );
        // Save the current canvas state
        canvas.save();

        // If the resistor is on a vertical line, apply rotation
        if (isVerticalLine) {
          // Translate to the resistor's position to set the pivot point for rotation
          canvas.translate(source.position.dx, source.position.dy);
          // Rotate 90 degrees (π/2 radians)
          canvas.rotate(pi / 2);
          // Translate back
          canvas.translate(-source.position.dx, -source.position.dy);
        }

        // Draw the image
        canvas.drawImageRect(
          voltageSourceImage!,
          Rect.fromLTRB(0, 0, voltageSourceImage!.width.toDouble(),
              voltageSourceImage!.height.toDouble()),
          destRect,
          Paint(),
        );

        // Restore the canvas to the previous state
        canvas.restore();
      }
    }

    // TODO: refactor -> extract common logic into a method
    if (currentSourceImage != null) {
      for (final source in currentSources) {
        bool isVerticalLine =
            source.position.dx == 90 || // Left vertical line
                source.position.dx == 90 + 800 / 2; // Middle vertical line

        final double imageWidth = 60.0;
        final double imageHeight = 30.0;
        Rect destRect = Rect.fromCenter(
          center: source.position,
          width: isVerticalLine
              ? imageHeight
              : imageWidth, // Swap dimensions if vertical
          height: isVerticalLine ? imageWidth : imageHeight,
        );
        // Save the current canvas state
        canvas.save();

        // If the resistor is on a vertical line, apply rotation
        if (isVerticalLine) {
          // Translate to the resistor's position to set the pivot point for rotation
          canvas.translate(source.position.dx, source.position.dy);
          // Rotate 90 degrees (π/2 radians)
          canvas.rotate(pi / 2);
          // Translate back
          canvas.translate(-source.position.dx, -source.position.dy);
        }

        // Draw the image
        canvas.drawImageRect(
          currentSourceImage!,
          Rect.fromLTRB(0, 0, currentSourceImage!.width.toDouble(),
              currentSourceImage!.height.toDouble()),
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
