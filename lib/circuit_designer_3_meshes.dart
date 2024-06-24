import 'dart:math';

import 'package:ETSIIValente/circuitComponents/CircuitLine.dart';
import 'package:ETSIIValente/circuits/ThreeMeshCircuit.dart';
import 'package:ETSIIValente/electricComponents/current_source.dart';
import 'package:ETSIIValente/electricComponents/electric_component.dart';
import 'package:ETSIIValente/thevenin_window.dart';
import 'package:ETSIIValente/utils/circuitUtils.dart';
import 'package:ETSIIValente/utils/fileUtils.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_color/flutter_color.dart';
import 'circuitComponents/CircuitBranch.dart';
import 'circuits/CircuitManager.dart';
import 'electricComponents/resistor.dart';
import 'electricComponents/voltage_source.dart';

enum SelectedComponent { resistor, voltageSource, currentSource, edit }

class CircuitParameters {
  static const double tolerance = 10.0; // Tolerancia del click
  static const double componentRange = 40.0; // Separacion entre componentes
  static const double circuitWidth = 800.0;
  static const double circuitHeight = 300.0;
  static const double circuitPadding = 90.0;
  static const double imageWidth = 50.0;
  static const double imageHeight = 50.0;

  // Structuring branch numbers according to Alfonso doc
  // (available on TFG documentation)

  static List<CircuitLine> CircuitLinesBranch1 = [
    // Top right line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding + (2*CircuitParameters.circuitWidth) / 3,
          CircuitParameters.circuitPadding),
      const Offset(
          CircuitParameters.circuitPadding + CircuitParameters.circuitWidth,
          CircuitParameters.circuitPadding),
    )
  ];

  static List<CircuitLine> CircuitLinesBranch2 = [
    // Bottom right line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding + (2*CircuitParameters.circuitWidth) / 3,
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
      const Offset(
          CircuitParameters.circuitPadding + CircuitParameters.circuitWidth,
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    )
  ];

  static List<CircuitLine> CircuitLinesBranch3 = [
    // right Middle vertical line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding +
              2*(CircuitParameters.circuitWidth / 3),
          CircuitParameters.circuitPadding),
      const Offset(
          CircuitParameters.circuitPadding +
              2*(CircuitParameters.circuitWidth / 3),
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    )
  ];

  static List<CircuitLine> CircuitLinesBranch4 = [
    // middle top line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 3,
          CircuitParameters.circuitPadding),
      const Offset(
          CircuitParameters.circuitPadding + 2*(CircuitParameters.circuitWidth/3),
          CircuitParameters.circuitPadding),
    ),
  ];

  static List<CircuitLine> CircuitLinesBranch5 = [
    // middle bottom line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 3,
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
      const Offset(
          CircuitParameters.circuitPadding + 2*(CircuitParameters.circuitWidth/3),
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    ),
  ];

  static List<CircuitLine> CircuitLinesBranch6 = [
    // left Middle vertical line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding +
              (CircuitParameters.circuitWidth / 3),
          CircuitParameters.circuitPadding),
      const Offset(
          CircuitParameters.circuitPadding +
              (CircuitParameters.circuitWidth / 3),
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    )
  ];

  static List<CircuitLine> CircuitLinesBranch7 = [
    // Top left line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding, CircuitParameters.circuitPadding),
      const Offset(
          CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 3,
          CircuitParameters.circuitPadding),
    ),
    // Bottom left line
    CircuitLine(
      const Offset(CircuitParameters.circuitPadding,
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
      const Offset(
          CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 3,
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

  static Map<ThreeMeshCircuitIdentifier, List<CircuitLine>> BranchsLinesMap = {
    ThreeMeshCircuitIdentifier.branch6: CircuitLinesBranch6,
    ThreeMeshCircuitIdentifier.branch3: CircuitLinesBranch3,
    ThreeMeshCircuitIdentifier.branch1: CircuitLinesBranch1,
    ThreeMeshCircuitIdentifier.branch2: CircuitLinesBranch2,
    ThreeMeshCircuitIdentifier.branch4: CircuitLinesBranch4,
    ThreeMeshCircuitIdentifier.branch5: CircuitLinesBranch5,
    ThreeMeshCircuitIdentifier.branch7: CircuitLinesBranch7
  };

  static List<CircuitLine> CircuitLines = [
    ...CircuitLinesBranch1,
    ...CircuitLinesBranch2,
    ...CircuitLinesBranch3,
    ...CircuitLinesBranch4,
    ...CircuitLinesBranch5,
    ...CircuitLinesBranch6,
    ...CircuitLinesBranch7
  ];
}

class CircuitDesigner3Meshes extends StatefulWidget {
  ThreeMeshCircuit circuit;

  CircuitDesigner3Meshes({Key? key, required this.circuit})
      : super(key: key);

  @override
  _CircuitDesigner3MeshesState createState() =>
      _CircuitDesigner3MeshesState(circuit);
}

class _CircuitDesigner3MeshesState extends State<CircuitDesigner3Meshes> {
  ThreeMeshCircuit circuit;

  _CircuitDesigner3MeshesState(this.circuit);
  // it makes sense to have a overall list of components to simplify rendering
  List<Resistor> resistors = [];
  List<VoltageSource> voltageSources = [];
  List<CurrentSource> currentSources = [];
  // Variable for drawing/editing components
  SelectedComponent selectedComponent = SelectedComponent.edit;
  // Images
  ui.Image? resistorImage;
  ui.Image? voltageSourceImage;
  ui.Image? currentSourceImage;

  @override
  void initState() {
    super.initState();
    resistors = circuit.getResistors();
    voltageSources = circuit.getVoltageSources();
    currentSources = circuit.getCurrentSources();
    _loadImage(
        'assets/resistor.png', (img) => setState(() => resistorImage = img));
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

  ThreeMeshCircuitIdentifier? _isTapOnBorder(Offset tapPosition) {
    // Iterate map to return the specific branch or "None"
    for (var branch in CircuitParameters.BranchsLinesMap.entries) {
      for (CircuitLine line in branch.value) {
        if (line.distanceToPoint(tapPosition) < CircuitParameters.tolerance) {
          return branch.key;
        }
      }
    }
    return null; // Line is not close enough to the tap position
  }

  ElectricComponent? _isTapOnComponent(Offset tapPosition) {
    // Tolerance = tap tolerance + component size
    double tolerance =
        CircuitParameters.componentRange + CircuitParameters.tolerance;
    for (var resistor in resistors) {
      if (resistor.isTapOnComponent(tapPosition, tolerance)) {
        print("Tap is too close to an existing resistor.");
        return resistor;
      }
    }
    for (var source in voltageSources) {
      if (source.isTapOnComponent(tapPosition, tolerance)) {
        print("Tap is too close to an existing voltage source.");
        return source;
      }
    }
    for (var source in currentSources) {
      if (source.isTapOnComponent(tapPosition, tolerance)) {
        print("Tap is too close to an existing current source.");
        return source;
      }
    }
    return null;
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
      if (closestLine.start.dy == closestLine.end.dy) {
        // Line is horizontal
        return Offset(tapPosition.dx, closestLine.start.dy);
      } else {
        // Line is vertical
        return Offset(closestLine.start.dx, tapPosition.dy);
      }
    }

    return tapPosition;
  }

  void _updateComponentValue(ElectricComponent component, double newValue,
      ThreeMeshCircuitIdentifier meshCircuitIdentifier) {
    CircuitBranch branch = circuit.getBranch(meshCircuitIdentifier);
    branch.deleteComponent(component);
    setState(() {
      if (component is Resistor) {
        component.resistance = newValue;
        branch.resistors.add(component); // new values
      } else if (component is CurrentSource) {
        // If value < 0 change sign
        int sign = newValue > 0
            ? component.sign
            : (-1 * component.sign);
        component.current = newValue.abs();
        component.sign = sign;
        branch.currentSources.add(component);
      } else if (component is VoltageSource) {
        int sign = newValue > 0
            ? component.sign
            : (-1 * component.sign);
        component.voltage = newValue.abs();
        component.sign = sign;
        branch.voltageSources.add(component);
      }
    });
  }

  void _rotateComponent(ElectricComponent component,
      ThreeMeshCircuitIdentifier meshCircuitIdentifier) {
    CircuitBranch branch = circuit.getBranch(meshCircuitIdentifier);
    branch.deleteComponent(component);
    setState(() {
      if (component is CurrentSource) {
        component.sign = -1 * component.sign;
        branch.currentSources.add(component);
      } else if (component is VoltageSource) {
        component.sign = -1 * component.sign;
        branch.voltageSources.add(component);
      }
    });
  }

  void _deleteComponent(ElectricComponent component,
      ThreeMeshCircuitIdentifier meshCircuitIdentifier) {
    CircuitBranch branch = circuit.getBranch(meshCircuitIdentifier);
    print("List2 - Before delete: ${branch.currentSources.length} sources");
    // List used for calculation
    branch.deleteComponent(component);
    print("List 1 - After delete: ${branch.currentSources.length} sources");
    setState(() {
      // List used for render
      if (component is Resistor) {
        resistors.remove(component);
      } else if (component is CurrentSource) {
        currentSources.remove(component);
      } else if (component is VoltageSource) {
        voltageSources.remove(component);
      }
    });
  }

  Future<bool> _validateCurrentSourceAddition(
      ThreeMeshCircuit circuit, ThreeMeshCircuitIdentifier target) async {
    String? message;
    if (target == ThreeMeshCircuitIdentifier.branch1 ||
        target == ThreeMeshCircuitIdentifier.branch2) {
      message =
      "No se puede colocar una fuente de intensidad en una rama abierta";
    } else if (circuit.hasCurrentSource(target)) {
      message = "Ya hay una fuente de intensidad en esta rama";
    } else if (currentSources.length == 2) {
      message =
      "No se pueden colocar más fuentes de intensidad. El máximo de fuentes de intensidad en este circuito es de 2.";
    } else if ((target == ThreeMeshCircuitIdentifier.branch3 ||target == ThreeMeshCircuitIdentifier.branch4 || target == ThreeMeshCircuitIdentifier.branch5)
        && (circuit.hasCurrentSource(ThreeMeshCircuitIdentifier.branch3) || circuit.hasCurrentSource(ThreeMeshCircuitIdentifier.branch4) || circuit.hasCurrentSource(ThreeMeshCircuitIdentifier.branch5))
    ) {
      message =
      "No se puede colocar una fuente de intensidad aquí. Hay una fuente en una rama cercana";
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

  void _addComponentAtPosition(TapDownDetails details, CircuitBranch branch) async {
    Offset adjustedPosition = _adjustComponentPosition(details.localPosition);
    TextEditingController valueController = TextEditingController();

    String selectedUnit = "kΩ"; // Default
    List<String> unitOptions = ["kΩ", "Ω"];
    if (selectedComponent == SelectedComponent.voltageSource) {
      unitOptions = ["V", "mV"];
      selectedUnit = "V";
    } else if (selectedComponent == SelectedComponent.currentSource) {
      unitOptions = ["mA","A"];
      selectedUnit = "mA";
    }

    bool add = true;
    // Show dialog to get the value
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Introduce el valor"),
            content: Form(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: valueController,
                        decoration: InputDecoration(
                          hintText: selectedComponent == SelectedComponent.resistor
                              ? "Resistencia"
                              : selectedComponent == SelectedComponent.voltageSource
                              ? "Voltaje"
                              : "Intensidad",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(border: OutlineInputBorder()),
                        value: selectedUnit,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedUnit = newValue;
                            });
                          }
                        },
                        items: unitOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                )),
            actions: <Widget>[
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  add = false;
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });

    if(add) {
      double value = double.tryParse(valueController.text) ??
          0.0; // Default to 0 if parse fails
      if(value!=0.0) {
        value = CircuitUtils.convertValue(value, selectedUnit);
        // Add component with value
        setState(() {
          if (selectedComponent == SelectedComponent.resistor) {
            branch.resistors.add(Resistor(adjustedPosition, value.abs()));
            resistors.add(Resistor(adjustedPosition, value.abs()));
          } else if (selectedComponent == SelectedComponent.voltageSource) {
            int sign = value < 0
                ? -1
                : 1;
            branch.voltageSources.add(VoltageSource(adjustedPosition, value.abs(), sign));
            voltageSources.add(VoltageSource(adjustedPosition, value.abs(), sign));
          } else {
            int sign = value < 0
                ? -1
                : 1;
            branch.currentSources.add(CurrentSource(adjustedPosition, value.abs(), sign));
            currentSources.add(CurrentSource(adjustedPosition, value.abs(), sign));
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "${valueController.text} no es un formato válido. Introduce un número distinto a 0 en formato XX.XX"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)));
      }
    }
  }

  void _saveCircuitDialog() {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Guardar Circuito"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Nombre del Circuito",
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Guardar"),
              onPressed: () {
                _saveCircuit(nameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveCircuit(String name) async {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("El nombre del circuito no puede estar vacío"),
        backgroundColor: Colors.red,
          duration: Duration(seconds: 1)
      ));
      return;
    }

    // Check name is unique
    List<CircuitStoreWrapper> existingCircuits = await CircuitManager().loadCircuits();
    bool nameExists = existingCircuits.any((circuit) => circuit.name.toLowerCase() == name.toLowerCase());
    if (nameExists) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Ya existe un circuito con el nombre '$name'. Por favor, elige otro nombre."),
        backgroundColor: Colors.red,
          duration: Duration(seconds: 1)
      ));
      return;
    }

    CircuitStoreWrapper circuitWrapper = CircuitStoreWrapper(name: name, circuit: circuit);
    print("Guardando....");
    await CircuitManager().addCircuit(circuitWrapper);
    print("GUARDADO!");

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Circuito '$name' guardado correctamente"),
      backgroundColor: Colors.green,
        duration: Duration(seconds: 1)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Diseña tu circuito",
          style: TextStyle(
            color: Colors.brown.darker(30),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(90,10,90,10),
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () => setState(
                          () => selectedComponent = SelectedComponent.resistor),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedComponent == SelectedComponent.resistor
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Opacity(
                      opacity: selectedComponent == SelectedComponent.resistor
                          ? 1.0
                          : 0.5,
                      child: Tooltip(message: "Resistencia", child: Image.asset('assets/resistor.png', width: 50)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(
                          () => selectedComponent = SelectedComponent.voltageSource),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                        selectedComponent == SelectedComponent.voltageSource
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Opacity(
                      opacity:
                      selectedComponent == SelectedComponent.voltageSource
                          ? 1.0
                          : 0.5,
                      child: Tooltip(message: "Fuente de Voltaje", child: Image.asset('assets/voltajeFuente.png', width: 50)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(
                          () => selectedComponent = SelectedComponent.currentSource),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                        selectedComponent == SelectedComponent.currentSource
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Opacity(
                      opacity:
                      selectedComponent == SelectedComponent.currentSource
                          ? 1.0
                          : 0.5,
                      child: Tooltip(message: "Fuente de Intensidad", child: Image.asset('assets/fuenteIntensidad.png', width: 50)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      setState(() => selectedComponent = SelectedComponent.edit),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedComponent == SelectedComponent.edit
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Opacity(
                      opacity:
                      selectedComponent == SelectedComponent.edit ? 1.0 : 0.5,
                      child: Tooltip(message: "Editar", child: const Icon(Icons.edit, size: 25)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTapDown: (TapDownDetails details) async {
                ThreeMeshCircuitIdentifier? branchIdentifier =
                _isTapOnBorder(details.localPosition);
                if (branchIdentifier != null) {
                  print("Tap is on branch $branchIdentifier");
                  ElectricComponent? component =
                  _isTapOnComponent(details.localPosition);
                  if (selectedComponent == SelectedComponent.edit &&
                      component != null) {
                    print("Starting component edit on: ${component}");
                    component.showEditDialog(
                        context,
                            (newValue) => _updateComponentValue(
                            component, newValue, branchIdentifier),
                            () => _deleteComponent(component, branchIdentifier),
                            () => _rotateComponent(component, branchIdentifier));
                  } else if (selectedComponent != SelectedComponent.edit &&
                      component == null) {
                    // validate Current Sources by Alfonso doc
                    bool validAddition = true;
                    if (selectedComponent == SelectedComponent.currentSource) {
                      validAddition = await _validateCurrentSourceAddition(
                          circuit, branchIdentifier);
                    }
                    if (validAddition) {
                      _addComponentAtPosition(
                          details, circuit.getBranch(branchIdentifier));
                    }
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
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.brown.darker(18),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                ),
                onPressed: () async {
                  // Use file picker to get the file path where the data will be saved.
                  String? filePath = await FileUtils.selectSaveFile();
                  // Write the serialized JSON data to the selected file.
                  if (filePath != null) {
                    await FileUtils.writeToFile(filePath, circuit.toJson());
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Circuito guardado en $filePath'), duration: Duration(seconds: 1)));
                    print('Data saved to file: $filePath');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Guardado cancelado'), duration: Duration(seconds: 1)));
                    print('No file selected.');
                  }
                },
                child: const Text('Exportar',
                    style: TextStyle(color: Colors.white))
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.brown.darker(18),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TheveninWindow(circuit: circuit)));
              },
              child: const Text('Calcular equivalente',
                  style: TextStyle(color: Colors.white)
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.brown.darker(18),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                ),
                onPressed: () {
                  _saveCircuitDialog();
                },
                child: const Text('Guardar',
                    style: TextStyle(color: Colors.white))),
          ],
        ),
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
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;

    // Define Lines of the circuit
    List<CircuitLine> lines = CircuitParameters.CircuitLines;
    // Draw each line
    for (var line in lines) {
      line.draw(canvas, paint);
    }
    // Check that at least an image is loaded
    if (resistorImage != null) {
      resistors.forEach((resistor) => _drawComponent(
          canvas,
          resistorImage!,
          resistor.position,
          resistor.resistance,
          SelectedComponent.resistor,
          1));
      voltageSources.forEach((source) => _drawComponent(
          canvas,
          voltageSourceImage!,
          source.position,
          source.voltage,
          SelectedComponent.voltageSource,
          source.sign));
      currentSources.forEach((source) => _drawComponent(
          canvas,
          currentSourceImage!,
          source.position,
          source.current,
          SelectedComponent.currentSource,
          source.sign));
    }

    // Draw the letter 'A' next to CircuitLine1
    TextSpan spanA = const TextSpan(
      style: TextStyle(color: Colors.black, fontSize: 20),
      text: 'A',
    );
    TextPainter tpA = TextPainter(
      text: spanA,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tpA.layout();
    double textXA = CircuitParameters.circuitPadding + CircuitParameters.circuitWidth + 10;
    double textYA = CircuitParameters.circuitPadding - tpA.height / 2; // middle of the letter
    tpA.paint(canvas, Offset(textXA, textYA));

    // Draw the letter 'B' next to CircuitLine2
    TextSpan spanB = const TextSpan(
      style: TextStyle(color: Colors.black, fontSize: 20),
      text: 'B',
    );
    TextPainter tpB = TextPainter(
      text: spanB,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tpB.layout();
    double textXB = CircuitParameters.circuitPadding + CircuitParameters.circuitWidth + 10;
    double textYB = CircuitParameters.circuitPadding + CircuitParameters.circuitHeight - tpB.height / 2; // middle of the letter
    tpB.paint(canvas, Offset(textXB, textYB));
  }

  void _drawComponent(Canvas canvas, ui.Image image, Offset position,
      double value, SelectedComponent selectedComponent, int sign) {
    bool isVerticalLine =
        position.dx == CircuitParameters.circuitPadding || // Left vertical line
        position.dx == CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 3 ||
        position.dx == CircuitParameters.circuitPadding + 2*CircuitParameters.circuitWidth / 3
    ;
    bool isBottom = position.dy ==
        CircuitParameters.circuitPadding + CircuitParameters.circuitHeight;

    double componentWidth = CircuitParameters.imageWidth;
    double componentHeight = CircuitParameters.imageHeight;

    Rect destRect = Rect.fromCenter(
      center: position,
      width: componentWidth,
      height: componentHeight,
    );

    // Save canvas state before rotation
    canvas.save();

    // Apply rotation if necessary
    double rotationAngle = 0;
    if (isVerticalLine) {
      rotationAngle = sign * (-pi) / 2;
    } else if (isBottom) {
      // For keeping orientation consistency
      rotationAngle = sign == 1
          ? pi
          : 0;
    } else if (sign == -1) {
      rotationAngle = pi;
    }

    if (rotationAngle != 0) {
      canvas.translate(position.dx, position.dy);
      canvas.rotate(rotationAngle);
      canvas.translate(-position.dx, -position.dy);
    }

    // Draw the image
    canvas.drawImageRect(
      image,
      Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
      destRect,
      Paint(),
    );

    // Restore the canvas state after drawing the image
    canvas.restore();

    // Draw the value text above the component
    canvas.save();
    if (isVerticalLine) {
      canvas.translate(position.dx, position.dy);
      canvas.rotate(-pi / 2);
      canvas.translate(-position.dx, -position.dy);
    }

    String valueText = "";
    if (selectedComponent == SelectedComponent.resistor) {
      valueText = CircuitUtils.formatOhms(value);
    } else if (selectedComponent == SelectedComponent.voltageSource) {
      valueText = CircuitUtils.formatVolts(value);
    } else {
      valueText = CircuitUtils.formatAmperes(value);
    }
    TextSpan span = TextSpan(
        style: const TextStyle(color: Colors.black), text: valueText);
    TextPainter tp = TextPainter(
        text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout();

    double textX = position.dx - (tp.width / 2);
    double textY = position.dy -
        CircuitParameters.imageHeight -
        tp.height + 20;

    tp.paint(canvas, Offset(textX, textY));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
