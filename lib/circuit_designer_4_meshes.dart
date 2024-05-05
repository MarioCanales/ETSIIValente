import 'dart:math';

import 'package:ETSIIValente/circuitComponents/CircuitLine.dart';
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
import 'circuitComponents/CircuitMesh.dart';
import 'circuits/CircuitManager.dart';
import 'circuits/FourMeshCircuit.dart';
import 'electricComponents/resistor.dart';
import 'electricComponents/voltage_source.dart';

enum SelectedComponent { resistor, voltageSource, currentSource, edit }

class CircuitParameters {
  static const double tolerance = 10.0;
  static const double componentRange = 40.0;
  static const double circuitWidth = 800.0;
  static const double circuitHeight = 300.0;
  static const double circuitPadding = 90.0;
  static const double imageWidth = 60.0;
  static const double imageHeight = 30.0;

  // Structuring branch numbers according to Alfonso doc
  // (available on TFG documentation)

  static List<CircuitLine> CircuitLinesBranch1 = [
    // Top right line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding + (3*CircuitParameters.circuitWidth) / 4,
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
          CircuitParameters.circuitPadding + (3*CircuitParameters.circuitWidth) / 4,
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
              3*(CircuitParameters.circuitWidth / 4),
          CircuitParameters.circuitPadding),
      const Offset(
          CircuitParameters.circuitPadding +
              3*(CircuitParameters.circuitWidth / 4),
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    )
  ];

  static List<CircuitLine> CircuitLinesBranch4 = [
    // middle top line right
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding + 2 * (CircuitParameters.circuitWidth / 4),
          CircuitParameters.circuitPadding),
      const Offset(
          CircuitParameters.circuitPadding + 3*(CircuitParameters.circuitWidth)/4,
          CircuitParameters.circuitPadding),
    ),
  ];

  static List<CircuitLine> CircuitLinesBranch5 = [
    // middle bottom line right
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding + 2 * (CircuitParameters.circuitWidth / 4),
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
      const Offset(
          CircuitParameters.circuitPadding + 3*(CircuitParameters.circuitWidth/4),
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    ),
  ];

  static List<CircuitLine> CircuitLinesBranch6 = [
    // Middle right vertical line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding +
              2 * (CircuitParameters.circuitWidth / 4),
          CircuitParameters.circuitPadding),
      const Offset(
          CircuitParameters.circuitPadding +
              2 * (CircuitParameters.circuitWidth / 4),
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    )
  ];

  static List<CircuitLine> CircuitLinesBranch7 = [
    // middle top line left
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding +  (CircuitParameters.circuitWidth / 4),
          CircuitParameters.circuitPadding),
      const Offset(
          CircuitParameters.circuitPadding + 2 * (CircuitParameters.circuitWidth)/4,
          CircuitParameters.circuitPadding),
    ),
  ];

  static List<CircuitLine> CircuitLinesBranch8 = [
    // middle bottom line right
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding + (CircuitParameters.circuitWidth / 4),
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
      const Offset(
          CircuitParameters.circuitPadding + 3*(CircuitParameters.circuitWidth/4),
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    ),
  ];

  static List<CircuitLine> CircuitLinesBranch9 = [
    // Middle left vertical line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding +
              1 * (CircuitParameters.circuitWidth / 4),
          CircuitParameters.circuitPadding),
      const Offset(
          CircuitParameters.circuitPadding +
              1 * (CircuitParameters.circuitWidth / 4),
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
    )
  ];

  static List<CircuitLine> CircuitLinesBranch10 = [
    // Top left line
    CircuitLine(
      const Offset(
          CircuitParameters.circuitPadding, CircuitParameters.circuitPadding),
      const Offset(
          CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 4,
          CircuitParameters.circuitPadding),
    ),
    // Bottom left line
    CircuitLine(
      const Offset(CircuitParameters.circuitPadding,
          CircuitParameters.circuitPadding + CircuitParameters.circuitHeight),
      const Offset(
          CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 4,
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

  static Map<FourMeshCircuitIdentifier, List<CircuitLine>> BranchsLinesMap = {
    FourMeshCircuitIdentifier.branch1: CircuitLinesBranch1,
    FourMeshCircuitIdentifier.branch2: CircuitLinesBranch2,
    FourMeshCircuitIdentifier.branch3: CircuitLinesBranch3,
    FourMeshCircuitIdentifier.branch4: CircuitLinesBranch4,
    FourMeshCircuitIdentifier.branch5: CircuitLinesBranch5,
    FourMeshCircuitIdentifier.branch6: CircuitLinesBranch6,
    FourMeshCircuitIdentifier.branch7: CircuitLinesBranch7,
    FourMeshCircuitIdentifier.branch8: CircuitLinesBranch8,
    FourMeshCircuitIdentifier.branch9: CircuitLinesBranch9,
    FourMeshCircuitIdentifier.branch10: CircuitLinesBranch10
  };

  static List<CircuitLine> CircuitLines = [
    ...CircuitLinesBranch1,
    ...CircuitLinesBranch2,
    ...CircuitLinesBranch3,
    ...CircuitLinesBranch4,
    ...CircuitLinesBranch5,
    ...CircuitLinesBranch6,
    ...CircuitLinesBranch7,
    ...CircuitLinesBranch8,
    ...CircuitLinesBranch9,
    ...CircuitLinesBranch10
  ];
}

class CircuitDesigner4Meshes extends StatefulWidget {
  FourMeshCircuit circuit;

  CircuitDesigner4Meshes({Key? key, required this.circuit})
      : super(key: key);

  @override
  _CircuitDesigner4MeshesState createState() =>
      _CircuitDesigner4MeshesState(circuit);
}

class _CircuitDesigner4MeshesState extends State<CircuitDesigner4Meshes> {
  FourMeshCircuit circuit;

  _CircuitDesigner4MeshesState(this.circuit);
  // it makes sense to have a overall list of components though to simplify
  // Draw features
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

  FourMeshCircuitIdentifier? _isTapOnBorder(Offset tapPosition) {
    // Iterate map to return the specific branch or "None"
    for (var branch in CircuitParameters.BranchsLinesMap.entries) {
      for (CircuitLine line in branch.value) {
        if (line.distanceToPoint(tapPosition) < CircuitParameters.tolerance) {
          return branch.key;
        }
      }
    }
    return null; // No line is close enough to the tap position
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

  void _updateComponentValue(ElectricComponent component, double newValue,
      FourMeshCircuitIdentifier meshCircuitIdentifier) {
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
      FourMeshCircuitIdentifier meshCircuitIdentifier) {
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
      FourMeshCircuitIdentifier meshCircuitIdentifier) {
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
      FourMeshCircuit circuit, FourMeshCircuitIdentifier target) async {
    String? message;
    if (target == FourMeshCircuitIdentifier.branch1 ||
        target == FourMeshCircuitIdentifier.branch2) {
      message =
      "No se puede colocar una fuente de intensidad en una rama abierta";
    } else if (circuit.hasCurrentSource(target)) {
      message = "Ya hay una fuente de intensidad en esta rama";
    } else if (currentSources.length == 3) {
      message =
      "No se pueden colocar más fuentes de intensidad. El máximo de fuentes de intensidad en este circuito es de 3.";
    } else if ((target == FourMeshCircuitIdentifier.branch3 ||target == FourMeshCircuitIdentifier.branch4 || target == FourMeshCircuitIdentifier.branch5)
    // Grupo 3-5-6
        && (circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch3) || circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch4) || circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch5))
    ) {
      message =
      "No se puede colocar una fuente de intensidad aquí. Hay una fuente en una rama cercana";
    } else if ((target == FourMeshCircuitIdentifier.branch7 || target == FourMeshCircuitIdentifier.branch8)
        && (circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch7) || circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch8))
    ) {
      // Grupo 7-8
      message =
      "No se puede colocar una fuente de intensidad aquí. Hay una fuente en una rama cercana";
    } else if (currentSources.length == 2) {
      // Se intenta meter una tercera:

      bool group345 =  circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch3) || circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch4) || circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch5);
      bool group78 = circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch7) || circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch8);

      String defaultErrorMessage = "No se puede colocar una fuente de intensidad aquí. Hay una fuente en una rama cercana";
      // Si hay en 3-4-5 y 6, no puede haber en 7 ni 8
      if ((group345 && circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch6)) && (target==FourMeshCircuitIdentifier.branch7 || target==FourMeshCircuitIdentifier.branch8)) {
        message = defaultErrorMessage;
      } else if (group345 && group78 && target==FourMeshCircuitIdentifier.branch6) {
        message = defaultErrorMessage;
      } else if (circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch6)) {
        // Si hay en 6 y 3-4-5 no 7 u 8, si hay en 6 y 7 u 8 no 3-4-5
        if(group345 && (target==FourMeshCircuitIdentifier.branch7 || target==FourMeshCircuitIdentifier.branch8)) {
          message = defaultErrorMessage;
        } else if (group78 && (target==FourMeshCircuitIdentifier.branch3 || target==FourMeshCircuitIdentifier.branch4 || target==FourMeshCircuitIdentifier.branch5)) {
          message = defaultErrorMessage;
        }
      } else if (group78) {
        // Si hay en 7u8...
        // Si 6 no 345
        if(circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch6) && (target==FourMeshCircuitIdentifier.branch3 || target==FourMeshCircuitIdentifier.branch4 || target==FourMeshCircuitIdentifier.branch5)) {
          message = defaultErrorMessage;
        // Si 3-4-5 no 6
        } else if (group345 && target == FourMeshCircuitIdentifier.branch6) {
          message = defaultErrorMessage;
        // Si 9 no 10
        } else if (circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch9) && (target == FourMeshCircuitIdentifier.branch10)) {
          message = defaultErrorMessage;
        // Si 10 no 9
        } else if (circuit.hasCurrentSource(FourMeshCircuitIdentifier.branch10) && (target == FourMeshCircuitIdentifier.branch9)) {
          message = defaultErrorMessage;
        }
      }
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
      value = CircuitUtils.convertValue(value, selectedUnit);
      // Add component with value
      setState(() {
        if (selectedComponent == SelectedComponent.resistor) {
          branch.resistors.add(Resistor(adjustedPosition, value));
          resistors.add(Resistor(adjustedPosition, value));
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
        title: const Text('Diseña tu circuito'),
      ),
      body: Column(
        children: <Widget>[
          Row(
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
                    child: Image.asset('assets/resistor.jpg', width: 50),
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
                    child: Image.asset('assets/voltajeFuente.png', width: 50),
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
                    child:
                    Image.asset('assets/fuenteIntensidad.png', width: 50),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    setState(() => selectedComponent = SelectedComponent.edit),
                child: Container(
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
                    child: const Icon(Icons.edit, size: 24),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              onTapDown: (TapDownDetails details) async {
                FourMeshCircuitIdentifier? branchIdentifier =
                _isTapOnBorder(details.localPosition);
                if (branchIdentifier != null) {
                  print("Tap is on branch $branchIdentifier");
                  ElectricComponent? component =
                  _isTapOnComponent(details.localPosition);
                  if (selectedComponent == SelectedComponent.edit &&
                      component != null) {
                    // Edit mode, we need to check if there's a component
                    // TODO: refine tolerance for this edit method.
                    // idea: if is not edit, add a +5 in tolerance and vice-versa
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TheveninWindow(circuit: circuit)));
                },
                child: const Text('Calcular equivalente',
                    style: TextStyle(color: Colors.brown))),
            ElevatedButton(
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
                    style: TextStyle(color: Colors.brown))),
            ElevatedButton(
                onPressed: () {
                  _saveCircuitDialog();
                },
                child: const Text('Guardar',
                    style: TextStyle(color: Colors.brown))),
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
      ..style = PaintingStyle.stroke; // Draw only the outline

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
            position.dx == CircuitParameters.circuitPadding + CircuitParameters.circuitWidth / 4 ||
            position.dx == CircuitParameters.circuitPadding + 2*CircuitParameters.circuitWidth / 4 ||
            position.dx == CircuitParameters.circuitPadding + 3*CircuitParameters.circuitWidth / 4
    ;
    bool isBottom = position.dy ==
        CircuitParameters.circuitPadding + CircuitParameters.circuitHeight;

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

    // Rotation calculation
    double rotationAngle = 0;
    if (isVerticalLine) {
      rotationAngle = sign * (-pi) / 2;
    } else if (isBottom) {
      // For keeping orientation consistency
      rotationAngle = sign == 1
          ? pi
          : 0;
    } else if (sign == -1) {
      // reverse horizontal in top line
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
    // Restore the canvas to the previous state
    // Draw the value text above the component
    // Create a text painter to draw the value
    canvas.restore();

    // If vertical rotate -pi/2 FIXED regardless of sign
    canvas.save();
    if (isVerticalLine) {
      canvas.translate(position.dx, position.dy);
      canvas.rotate(-pi / 2);
      canvas.translate(-position.dx, -position.dy);
    }

    String valueText = "";
    if(selectedComponent == SelectedComponent.resistor) {
      valueText = "${(value/1000).toStringAsFixed(1)} KΩ";
    } else if (selectedComponent == SelectedComponent.voltageSource) {
      valueText = "${(value).toStringAsFixed(1)} V";
    } else {
      valueText = "${(value*1000).toStringAsFixed(1)} mA";
    }
    TextSpan span = TextSpan(
        style: const TextStyle(color: Colors.black),
        text: valueText
    );
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
