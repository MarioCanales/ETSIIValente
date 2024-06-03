import 'package:ETSIIValente/circuitComponents/TheveninEquivalent.dart';
import 'package:ETSIIValente/utils/circuitUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'dart:math';

import 'circuits/Circuit.dart';

class TheveninWindow extends StatefulWidget {
  final Circuit circuit;

  const TheveninWindow({Key? key, required this.circuit}) : super(key: key);

  @override
  _TheveninWindowState createState() => _TheveninWindowState();
}

class _TheveninWindowState extends State<TheveninWindow> {
  bool showThevenin = true;

  @override
  Widget build(BuildContext context) {
    TheveninEquivalent equivalent = widget.circuit.calculateTheveninEquivalent();

    bool hasInvalidValues = equivalent.voltage.isNaN || equivalent.voltage.isInfinite ||
        equivalent.resistance.isNaN || equivalent.resistance.isInfinite;

    String theveninText = 'Vth = ${CircuitUtils.formatVolts(equivalent.voltage)}, Rth = ${CircuitUtils.formatOhms(equivalent.resistance)}';
    String nortonText = 'In = ${CircuitUtils.formatAmperes(equivalent.calculateNortonCurrent())}, Rn = ${CircuitUtils.formatOhms(equivalent.resistance)}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          showThevenin ? "Equivalente Thevenin" : "Equivalente Norton",
          style: TextStyle(
            color: Colors.brown.darker(30),
            fontSize: 25, // Tamaño de fuente aumentado
            fontWeight: FontWeight.bold, // Peso de la fuente más grueso
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              showThevenin ? 'assets/equivalent-template.png' : 'assets/norton-equivalent-template.png',
              width: 200, // Adjust the size as needed
              height: 350,
            ),
            const SizedBox(height: 20),
            hasInvalidValues
                ? const Text(
              "La configuración del circuito no es válida",
              style: TextStyle(fontSize: 18, color: Colors.redAccent),
            )
                : Text(
              showThevenin ? theveninText : nortonText,
              style: const TextStyle(fontSize: 20), // Adjust the style as needed
            ),
            const SizedBox(height: 20),
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
                setState(() {
                  showThevenin = !showThevenin;
                });
              },
              child: Text(showThevenin ? "Ver equivalente Norton" : "Ver equivalente Thevenin"),
            ),
          ],
        ),
      ),
    );
  }
}
