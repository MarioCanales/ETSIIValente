import 'package:flutter/material.dart';
import 'package:ETSIIValente/circuits/CircuitManager.dart';

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
        title: Text("Circuitos Guardados"),
        backgroundColor: Colors.brown,
      ),
      body: FutureBuilder<List<CircuitStoreWrapper>>(
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
                              icon: Icon(Icons.remove_red_eye, color: Colors.blue),
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
                              icon: Icon(Icons.delete, color: Colors.red),
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
        .showSnackBar(SnackBar(content: Text("Circuito eliminado: $name")));
  }
}
