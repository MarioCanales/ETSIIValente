import 'package:ETSIIValente/circuitComponents/TheveninEquivalent.dart';
import 'package:flutter/material.dart';

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
            SizedBox(height: 20), // Space between image and text
            Text(
              showThevenin ? 'Vth = ${equivalent.voltage.toStringAsFixed(2)} V, Rth = ${(equivalent.resistance / 1000).toStringAsFixed(2)} kΩ'
                  : 'In = ${(equivalent.calculateNortonCurrent()*1000).toStringAsFixed(2)} mA, Rn = ${(equivalent.resistance / 1000).toStringAsFixed(2)} kΩ',
              style: TextStyle(fontSize: 20), // Adjust the style as needed
            ),
            SizedBox(height: 20), // Space between text and button
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
