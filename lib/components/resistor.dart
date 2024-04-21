import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'electric_component.dart';

class Resistor extends ElectricComponent {
  double resistance;
  Resistor(Offset position, this.resistance) : super(position);

  @override
  void showEditDialog(BuildContext context, Function updateCallback) {
    TextEditingController controller = TextEditingController(text: resistance.toString());
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Editar resistencia"),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: "Ohmios"),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text('Cancelar'),
                onPressed: () {
                    Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Actualizar'),
                onPressed: () {
                  double newValue = double.tryParse(controller.text) ?? resistance;
                  updateCallback(newValue);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
}
