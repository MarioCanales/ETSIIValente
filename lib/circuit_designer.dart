import 'dart:math';

import 'package:ETSIIValente/components/CircuitLine.dart';
import 'package:ETSIIValente/components/current_source.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'components/CircuitMesh.dart';
import 'components/resistor.dart';
import 'components/voltage_source.dart';

enum Component { resistor, voltageSource, currentSource }

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

  // Structuring mesh numbers according to Alfonso doc
  // (available on TFG documentation)

  static List<CircuitLine> CircuitLineMesh1 = [
    // Top right line
    CircuitLine(
      const Offset(CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 2, CircuitParameters.circuitPadding),
      const Offset(CircuitParameters.circuitPadding + CircuitParameters.circuitWidth, CircuitParameters.circuitPadding),
    )
  ];

  static List<CircuitLine> CircuitLineMesh2 = [
    // Bottom right line
    CircuitLine(
      const Offset(CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 2, CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
      const Offset(CircuitParameters.circuitPadding + CircuitParameters.circuitWidth, CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    )
  ];

  static List<CircuitLine> CircuitLinesMesh3 = [
    // Middle vertical line
    CircuitLine(
      const Offset(CircuitParameters.circuitPadding + (CircuitParameters.circuitWidth / 2), CircuitParameters.circuitPadding),
      const Offset(CircuitParameters.circuitPadding + (CircuitParameters.circuitWidth / 2), CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    )
  ];

  static List<CircuitLine> CircuitLinesMesh4 = [
    // Top left line
    CircuitLine(
      const Offset(CircuitParameters.circuitPadding, CircuitParameters.circuitPadding),
      const Offset(CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 2, CircuitParameters.circuitPadding),
    ),
    // Bottom left line
    CircuitLine(
      const Offset(CircuitParameters.circuitPadding, CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
      const Offset(CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 2, CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    ),
    // Left vertical line
    CircuitLine(
      const Offset(CircuitParameters.circuitPadding, CircuitParameters.circuitPadding),
      const Offset(CircuitParameters.circuitPadding, CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    ),
  ];

  static List<CircuitLine> CircuitLines  = [
      ...CircuitLineMesh1,
      ...CircuitLineMesh2,
      ...CircuitLinesMesh3,
      ...CircuitLinesMesh4
    ];
}

class _CircuitDesignerState extends State<CircuitDesigner> {
  List<Resistor> resistors = [];
  List<VoltageSource> voltageSources = [];
  List<CurrentSource> currentSources = [];
  Component selectedComponent = Component.resistor;

  // Mesh1
  CircuitMesh mesh1 = CircuitMesh();
  // Mesh2
  CircuitMesh mesh2 = CircuitMesh();
  // Mesh3
  CircuitMesh mesh3 = CircuitMesh();
  // Mesh 4
  CircuitMesh mesh4 = CircuitMesh();
  // TODO: split logic to add components here so we can validate numbers ->
  // it makes sense to have a overall list of components though to simplify
  // Draw features

  // Images
  ui.Image? resistorImage;
  ui.Image? voltageSourceImage;
  ui.Image? currentSourceImage;

  @override
  void initState() {
    super.initState();
    _loadImage(
        'assets/resistor.jpg', (img) => setState(() => resistorImage = img));
    _loadImage('assets/voltajeFuente.png',
        (img) => setState(() => voltageSourceImage = img));
    _loadImage('assets/fuenteIntensidad.png',
        (img) => setState(() => currentSourceImage = img));
  }

  Future<void> _loadImage(String assetPath, Function(ui.Image) callback) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    ui.decodeImageFromList(bytes, callback);
  }

  bool _isTapOnBorder(Offset tapPosition) {
    // First iteration: check all
    for (CircuitLine line in CircuitParameters.CircuitLines) {
      if (line.distanceToPoint(tapPosition) < CircuitParameters.tolerance) {
        return true; // Tap is close to this line
      }
    }
    print("Touch outside the circuit");
    return false; // No line is close enough to the tap position
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

  Offset _adjustComponentPosition(Offset tapPosition) {
    List<CircuitLine> circuitLines = CircuitParameters.CircuitLines;
    CircuitLine? closestLine;
    double closestDistance = double.infinity;

    for (CircuitLine line in circuitLines) {
      double distance = line.distanceToPoint(tapPosition);
      if (distance < closestDistance) {
        closestDistance = distance;
        closestLine = line;
      }
    }

    if (closestLine != null) {
      // Adjust tapPosition to be on the closestLine
      // For horizontal lines, adjust y; for vertical lines, adjust x
      if (closestLine.start.dy == closestLine.end.dy) {
        // Line is horizontal
        return Offset(tapPosition.dx, closestLine.start.dy);
      } else {
        // Line is vertical
        return Offset(closestLine.start.dx, tapPosition.dy);
      }
    }

    return tapPosition; // Return original position if no line is close enough
  }

  void _addComponentAtPosition(TapDownDetails details) async {
    Offset adjustedPosition = _adjustComponentPosition(details.localPosition);
    TextEditingController valueController = TextEditingController();

    // Show dialog to get the value
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter Value"),
            content: TextField(
              controller: valueController,
              decoration: InputDecoration(
                hintText: selectedComponent == Component.resistor
                    ? "Resistance (Ohms)"
                    : selectedComponent == Component.voltageSource
                    ? "Voltage (Volts)"
                    : "Current (Amperes)",
              ),
              keyboardType: TextInputType.number,
            ),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });

    double value = double.tryParse(valueController.text) ?? 0.0; // Default to 0 if parse fails

    // Add component with value
    setState(() {
      if (selectedComponent == Component.resistor) {
        resistors.add(Resistor(adjustedPosition, value));
      } else if (selectedComponent == Component.voltageSource) {
        voltageSources.add(VoltageSource(adjustedPosition, value));
      } else {
        currentSources.add(CurrentSource(adjustedPosition, value));
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
                  if (_isTapOnBorder(details.localPosition) &&
                      !_isTapOnComponent(details.localPosition)) {
                    _addComponentAtPosition(details);
                  }
                },
                child: Container(
                  height: 1300,
                  width: double.infinity,
                  color: Colors.white,
                  child: CustomPaint(
                    painter: CircuitPainter(
                        resistors,
                        voltageSources,
                        currentSources,
                        resistorImage,
                        voltageSourceImage,
                        currentSourceImage),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class CircuitPainter extends CustomPainter {
  final List<Resistor> resistors;
  final List<VoltageSource> voltageSources;
  final List<CurrentSource> currentSources;
  final ui.Image? resistorImage;
  final ui.Image? voltageSourceImage;
  final ui.Image? currentSourceImage;

  CircuitPainter(this.resistors, this.voltageSources, this.currentSources,
      this.resistorImage, this.voltageSourceImage, this.currentSourceImage);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke; // Draw only the outline

    // Define Lines of the circuit
    List<CircuitLine> lines = CircuitParameters.CircuitLines;
    // Draw each line
    for (var line in lines) {
      line.draw(canvas, paint);
    }
    // Draw the resistor image at each position
    if (resistorImage != null) {
      resistors.forEach((resistor) =>
          _drawComponent(canvas, resistorImage!, resistor.position, resistor.resistance, Component.resistor));
      voltageSources.forEach((source) =>
          _drawComponent(canvas, voltageSourceImage!, source.position, source.voltage, Component.voltageSource));
      currentSources.forEach((source) =>
          _drawComponent(canvas, currentSourceImage!, source.position, source.current, Component.currentSource));
    }
  }

  void _drawComponent(Canvas canvas, ui.Image image, Offset position, double value, Component selectedComponent) {
    bool isVerticalLine =
        position.dx == CircuitParameters.circuitPadding || // Left vertical line
            position.dx ==
                CircuitParameters.circuitPadding +
                    CircuitParameters.circuitWidth / 2;

    Rect destRect = Rect.fromCenter(
      center: position,
      width: isVerticalLine
          ? CircuitParameters.imageHeight
          : CircuitParameters.imageWidth, // Swap dimensions if vertical
      height: isVerticalLine
          ? CircuitParameters.imageWidth
          : CircuitParameters.imageHeight,
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
      Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
      destRect,
      Paint(),
    );
    // Restore the canvas to the previous state
    // Draw the value text above the component
    // Create a text painter to draw the value
    TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black), text: value.toString() + (selectedComponent == Component.resistor ? "Ω" : selectedComponent == Component.voltageSource ? "V" : "A")); // You might want to customize the unit based on the component type
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout();
    // Calculate the offset to center the text above the component
    // Subtract half the text width from the component's center position
    double textX = position.dx - (tp.width / 2);
    // Adjust the y position to move the text above the component, modifying the offset as needed
    double textY = position.dy - CircuitParameters.imageHeight - tp.height; // You may need to adjust this based on your component size
    // Paint the text
    tp.paint(canvas, Offset(textX, textY));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
