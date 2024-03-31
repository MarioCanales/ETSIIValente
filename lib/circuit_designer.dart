import 'dart:math';

import 'package:ETSIIValente/components/CircuitLine.dart';
import 'package:ETSIIValente/components/current_source.dart';
import 'package:ETSIIValente/thevenin_window.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'components/CircuitMesh.dart';
import 'components/TwoMeshCircuit.dart';
import 'components/resistor.dart';
import 'components/voltage_source.dart';

enum Component { resistor, voltageSource, currentSource }

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

  static List<CircuitLine> CircuitLinesMesh1 = [
    // Top right line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 2,
          CircuitParameters.circuitPadding),
      const Offset(
          CircuitParameters.circuitPadding + CircuitParameters.circuitWidth,
          CircuitParameters.circuitPadding),
    )
  ];

  static List<CircuitLine> CircuitLinesMesh2 = [
    // Bottom right line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 2,
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
      const Offset(
          CircuitParameters.circuitPadding + CircuitParameters.circuitWidth,
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    )
  ];

  static List<CircuitLine> CircuitLinesMesh3 = [
    // Middle vertical line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding +
              (CircuitParameters.circuitWidth / 2),
          CircuitParameters.circuitPadding),
      const Offset(
          CircuitParameters.circuitPadding +
              (CircuitParameters.circuitWidth / 2),
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    )
  ];

  static List<CircuitLine> CircuitLinesMesh4 = [
    // Top left line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding, CircuitParameters.circuitPadding),
      const Offset(
          CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 2,
          CircuitParameters.circuitPadding),
    ),
    // Bottom left line
    CircuitLine(
      const Offset(CircuitParameters.circuitPadding,
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
      const Offset(
          CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 2,
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    ),
    // Left vertical line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding, CircuitParameters.circuitPadding),
      const Offset(CircuitParameters.circuitPadding,
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    ),
  ];

  static Map<TwoMeshCircuitIdentifier, List<CircuitLine>> MeshesLinesMap = {
    TwoMeshCircuitIdentifier.mesh1: CircuitLinesMesh1,
    TwoMeshCircuitIdentifier.mesh2: CircuitLinesMesh2,
    TwoMeshCircuitIdentifier.mesh3: CircuitLinesMesh3,
    TwoMeshCircuitIdentifier.mesh4: CircuitLinesMesh4
  };

  static List<CircuitLine> CircuitLines = [
    ...CircuitLinesMesh1,
    ...CircuitLinesMesh2,
    ...CircuitLinesMesh3,
    ...CircuitLinesMesh4
  ];
}

class CircuitDesigner extends StatefulWidget {
  @override
  _CircuitDesignerState createState() => _CircuitDesignerState();
}

class _CircuitDesignerState extends State<CircuitDesigner> {
  TwoMeshCircuit circuit = TwoMeshCircuit();
  // it makes sense to have a overall list of components though to simplify
  // Draw features
  List<Resistor> resistors = [];
  List<VoltageSource> voltageSources = [];
  List<CurrentSource> currentSources = [];
  // Variable for drawing components
  Component selectedComponent = Component.resistor;
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

  TwoMeshCircuitIdentifier? _isTapOnBorder(Offset tapPosition) {
    // Iterate map to return the specific mesh or "None"
    for (var mesh in CircuitParameters.MeshesLinesMap.entries) {
      for (CircuitLine line in mesh.value) {
        if (line.distanceToPoint(tapPosition) < CircuitParameters.tolerance) {
          return mesh.key;
        }
      }
    }
    return null; // No line is close enough to the tap position
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

  Future<bool> _validateCurrentSourceAddition(TwoMeshCircuit circuit, TwoMeshCircuitIdentifier target) async {
    String? message;
    if (target == TwoMeshCircuitIdentifier.mesh1 ||
        target == TwoMeshCircuitIdentifier.mesh2) {
      message = "No se puede colocar una fuente de intensidad en una rama abierta";
    } else if (circuit.getMesh(TwoMeshCircuitIdentifier.mesh3).currentSources.isNotEmpty ||
        circuit.getMesh(TwoMeshCircuitIdentifier.mesh4).currentSources.isNotEmpty) {
      message = "Ya existe una fuente de intensidad en el circuito. Para circuitos de 2 mallas solo se acepta una fuente de intensidad.";
    }
    if (message != null) {
      // Validation error
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error al añadir componente"),
              content: Text(message!),
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
      return false;
    }
    return true;
  }

  void _addComponentAtPosition(TapDownDetails details, CircuitMesh mesh) async {
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

    double value = double.tryParse(valueController.text) ??
        0.0; // Default to 0 if parse fails

    // Add component with value
    setState(() {
      if (selectedComponent == Component.resistor) {
        mesh.resistors.add(Resistor(adjustedPosition, value));
        resistors.add(Resistor(adjustedPosition, value));
      } else if (selectedComponent == Component.voltageSource) {
        mesh.voltageSources.add(VoltageSource(adjustedPosition, value));
        voltageSources.add(VoltageSource(adjustedPosition, value));
      } else {
        mesh.currentSources.add(CurrentSource(adjustedPosition, value));
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
                onTapDown: (TapDownDetails details) async {
                  TwoMeshCircuitIdentifier? meshIdentifier =
                      _isTapOnBorder(details.localPosition);
                  if ((meshIdentifier != null) &&
                      !_isTapOnComponent(details.localPosition)) {
                    print("Tap is on mesh $meshIdentifier");
                    // validate Current Sources by Alfonso doc
                    bool validAddition = true;
                    if (selectedComponent == Component.currentSource) {
                      validAddition = await _validateCurrentSourceAddition(
                          circuit, meshIdentifier);
                    }
                    if (validAddition) {
                      _addComponentAtPosition(
                          details, circuit.getMesh(meshIdentifier));
                    }
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
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(right: 40.0, bottom: 40.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TheveninWindow(circuit: circuit)));
                  },
                  child: const Text('Calcular equivalente Thevenin',
                      style: TextStyle(color: Colors.brown))
              ),
            )
          ],
        ),
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
      resistors.forEach((resistor) => _drawComponent(canvas, resistorImage!,
          resistor.position, resistor.resistance, Component.resistor));
      voltageSources.forEach((source) => _drawComponent(
          canvas,
          voltageSourceImage!,
          source.position,
          source.voltage,
          Component.voltageSource));
      currentSources.forEach((source) => _drawComponent(
          canvas,
          currentSourceImage!,
          source.position,
          source.current,
          Component.currentSource));
    }
  }

  void _drawComponent(Canvas canvas, ui.Image image, Offset position,
      double value, Component selectedComponent) {
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
    TextSpan span = TextSpan(
        style: const TextStyle(color: Colors.black),
        text: value.toString() +
            (selectedComponent == Component.resistor
                ? "Ω"
                : selectedComponent == Component.voltageSource
                    ? "V"
                    : "A")); // You might want to customize the unit based on the component type
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    // Calculate the offset to center the text above the component
    // Subtract half the text width from the component's center position
    double textX = position.dx - (tp.width / 2);
    // Adjust the y position to move the text above the component, modifying the offset as needed
    double textY = position.dy -
        CircuitParameters.imageHeight -
        tp.height; // You may need to adjust this based on your component size
    // Paint the text
    tp.paint(canvas, Offset(textX, textY));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
