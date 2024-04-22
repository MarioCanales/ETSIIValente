import 'package:ETSIIValente/components/TheveninEquivalent.dart';
import 'package:ETSIIValente/components/TwoMeshCircuit.dart';
import 'package:flutter/material.dart';

class TheveninWindow extends StatelessWidget {
  final TwoMeshCircuit circuit;

  const TheveninWindow({Key? key, required this.circuit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TheveninEquivalent equivalent = circuit.calculateTheveninEquivalent();
    return Scaffold(
      appBar: AppBar(
        title: Text("Equivalente Thevenin"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/equivalent-template.png',
              width: 200, // Adjust the size as needed
            ),
            SizedBox(height: 20), // Space between image and text
            Text(
              'Vth = ${equivalent.voltage.toStringAsFixed(2)} V, Rth = ${(equivalent.resistance / 1000).toStringAsFixed(2)} kΩ',
              style: TextStyle(fontSize: 20), // Adjust the style as needed
            ),
          ],
        ),
      ),
    );
  }
}
