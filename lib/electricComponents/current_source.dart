import 'package:flutter/material.dart';

import 'electric_component.dart';

class CurrentSource extends ElectricComponent {
  double current;
  int sign;

  CurrentSource(Offset position, this.current, this.sign) : super(position);

  @override
  void showEditDialog(BuildContext context, Function updateCallback, Function deleteCallback, Function rotateCallback) {
    TextEditingController controller = TextEditingController(text: (current*1000).toString());

    String selectedUnit = "mA"; // Default unit
    List<String> unitOptions = ["mA", "A"]; // Options for the unit dropdown

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Editar fuente de intensidad"),
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
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Actualizar'),
                onPressed: () {
                  double value = double.tryParse(controller.text) ?? current; // Parse the entered value
                  value = convertValue(value, selectedUnit);
                  updateCallback(value);
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
    if (unit == "mA") {
      return value / 1000;
    }
    return value;
  }

  // Implement fromJson method
  static CurrentSource fromJson(Map<String, dynamic> json) {
    return CurrentSource(
      Offset(json['position']['dx'], json['position']['dy']),
      json['current'],
      json['sign'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': 'CurrentSource',
      'position': {'dx': position.dx, 'dy': position.dy},
      'current': current,
      'sign': sign,
    };
  }

}

