import 'package:ETSIIValente/circuitComponents/TheveninEquivalent.dart';
import 'package:flutter/material.dart';
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

    String theveninText = 'Vth = ${equivalent.voltage.toStringAsFixed(2)} V, Rth = ${(equivalent.resistance / 1000).toStringAsFixed(2)} kΩ';
    String nortonText = 'In = ${(equivalent.calculateNortonCurrent() * 1000).toStringAsFixed(2)} mA, Rn = ${(equivalent.resistance / 1000).toStringAsFixed(2)} kΩ';

    return Scaffold(
      appBar: AppBar(
        title: Text(showThevenin ? "Equivalente Thevenin" : "Equivalente Norton"),
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
