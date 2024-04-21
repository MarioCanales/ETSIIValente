import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'electric_component.dart';

class CurrentSource extends ElectricComponent{
  double current;
  int sign;
  CurrentSource(Offset position, this.current, this.sign): super(position);

  @override
  void showEditDialog(BuildContext context, Function updateCallback, Function deleteCallback, Function rotateCallback) {
    TextEditingController controller = TextEditingController(text: current.toString());
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Editar fuente de intensidad"),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: "Amperios"),
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
                  double newValue = double.tryParse(controller.text) ?? current;
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
