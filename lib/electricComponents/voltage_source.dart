import 'dart:ui';

import 'package:ETSIIValente/electricComponents/electric_component.dart';
import 'package:flutter/material.dart';

class VoltageSource extends ElectricComponent {
  double voltage;
  int sign;

  VoltageSource(Offset position, this.voltage, this.sign) : super(position);

  @override
  void showEditDialog(BuildContext context, Function updateCallback, Function deleteCallback, Function rotateCallback) {
    TextEditingController controller = TextEditingController(text: voltage.toString());

    String selectedUnit = "V";
    List<String> unitOptions = ["V", "mV"];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Editar fuente de voltaje"),
            content: Form(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: "Valor",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: selectedUnit,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          selectedUnit = newValue;
                        }
                      },
                      items: unitOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context). pop();
                },
              ),
              TextButton(
                child: Text('Actualizar'),
                onPressed: () {
                  double value = double.tryParse(controller.text) ?? 0.0; // Parse the value
                  if(value == 0.0) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "${controller.text} no es un formato válido. Introduce un número distinto a 0 en formato XX.XX"),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2)));
                  } else {
                    value = convertValue(value, selectedUnit); // Convert the value based on the selected unit
                    updateCallback(value);
                  }
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

  double convertValue(double value, String unit) {
    if (unit == "mV") {
      return value / 1000; // Convert millivolts to volts
    }
    return value; // Return as is if already in volts
  }

  static VoltageSource fromJson(Map<String, dynamic> json) {
    return VoltageSource(
      Offset(json['position']['dx'], json['position']['dy']),
      json['voltage'],
      json['sign'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': 'VoltageSource',
      'position': {'dx': position.dx, 'dy': position.dy},
      'voltage': voltage,
      'sign': sign,
    };
  }
}
