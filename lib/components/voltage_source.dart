import 'dart:ui';

import 'package:ETSIIValente/components/electric_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class VoltageSource extends ElectricComponent{
  double voltage;
  int sign;
  VoltageSource(Offset position, this.voltage, this.sign): super(position);

  @override
  void showEditDialog(BuildContext context, Function updateCallback, Function deleteCallback, Function rotateCallback) {
    TextEditingController controller = TextEditingController(text: voltage.toString());
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Editar fuente de voltaje"),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: "Voltios"),
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
                  double newValue = double.tryParse(controller.text) ?? voltage;
                  updateCallback(newValue);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Girar'),
                onPressed: () {
                  rotateCallback();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Eliminar'),
                onPressed: () {
                  showDeleteConfirmation(context, deleteCallback);
                },
              ),
            ],
          );
        }
    );
  }
}