import 'package:flutter/material.dart';
import 'package:ETSIIValente/circuits/CircuitManager.dart';
import 'package:flutter_color/flutter_color.dart';

import 'circuit_designer_2_meshes.dart';
import 'circuit_designer_3_meshes.dart';
import 'circuit_designer_4_meshes.dart';
import 'circuits/Circuit.dart';
import 'circuits/FourMeshCircuit.dart';
import 'circuits/ThreeMeshCircuit.dart';
import 'circuits/TwoMeshCircuit.dart';

class SavedCircuitsPage extends StatefulWidget {
  @override
  _SavedCircuitsPageState createState() => _SavedCircuitsPageState();
}

class _SavedCircuitsPageState extends State<SavedCircuitsPage> {
  late Future<List<CircuitStoreWrapper>> _circuits;

  @override
  void initState() {
    super.initState();
    _circuits = CircuitManager().loadCircuits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 88,
        title: Text(
          "Circuitos Guardados",
          style: TextStyle(
            color: Colors.brown.darker(30),
            fontSize: 27, // Tamaño de fuente aumentado
            fontWeight: FontWeight.bold, // Peso de la fuente más grueso
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover)),
            child: FutureBuilder<List<CircuitStoreWrapper>>(
            future: _circuits,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data![index];
                        return Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(item.name, style: TextStyle(fontSize: 18)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Tooltip(child: Icon(Icons.remove_red_eye, color: Colors.blue), message: "Ver circuito",),
                                  onPressed: () {
                                    Circuit circuit = item.circuit;
                                    // You can add your edit functionality here
                                    if (circuit is TwoMeshCircuit) {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CircuitDesigner2Meshes(
                                                          circuit: circuit)))
                                          .then((value) => setState(() {
                                                _circuits =
                                                    CircuitManager().loadCircuits();
                                              }));
                                    } else if (circuit is ThreeMeshCircuit) {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CircuitDesigner3Meshes(
                                                          circuit: circuit)))
                                          .then((value) => setState(() {
                                                _circuits =
                                                    CircuitManager().loadCircuits();
                                              }));
                                      ;
                                    } else if (circuit is FourMeshCircuit) {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CircuitDesigner4Meshes(
                                                          circuit: circuit)))
                                          .then((value) => setState(() {
                                                _circuits =
                                                    CircuitManager().loadCircuits();
                                              }));
                                      ;
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Tooltip(child: Icon(Icons.delete, color: Colors.red), message: "Eliminar circuito"),
                                  onPressed: () => _deleteCircuit(item.name),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
              return Center(child: CircularProgressIndicator());
            },
                    ),
          ),
      ]
      ),
    );
  }

  void _deleteCircuit(String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar Circuito"),
          content:
              Text("¿Estás seguro de que deseas eliminar el circuito '$name'?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Eliminar"),
              onPressed: () {
                Navigator.of(context).pop();
                _confirmDelete(name);
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(String name) async {
    await CircuitManager().deleteCircuit(name);
    setState(() {
      _circuits = CircuitManager().loadCircuits(); // Refresh the list
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Circuito eliminado: $name"), duration: Duration(seconds: 1)));
  }
}
