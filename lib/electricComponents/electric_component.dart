import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class ElectricComponent {
  Offset position;
  ElectricComponent(this.position);

  bool isTapOnComponent(Offset tapPosition, double tolerance) {
    if ((tapPosition - position).distance < tolerance) {
      return true;
    }
    return false;
  }

  void showEditDialog(BuildContext context, Function updateCallback, Function deleteCallback, Function rotateCallback);

  void showDeleteConfirmation(BuildContext context, Function onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar borrado"),
          content: Text("¿Está seguro de que desea eliminar este componente? "
              "Esta acción no se puede deshacer"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Borrar", style: TextStyle(color: Colors.red)),
              onPressed: () {
                onConfirm();  // Execute the deletion callback
                Navigator.of(context).pop();  // Close the confirmation dialog
                Navigator.of(context).pop();  // Close the edit dialog
              },
            ),
          ],
        );
      },
    );
  }

}
