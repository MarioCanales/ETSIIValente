import 'package:ETSIIValente/circuits/FourMeshCircuit.dart';
import 'package:ETSIIValente/circuits/TwoMeshCircuit.dart';
import 'package:ETSIIValente/saved_circuits.dart';
import 'package:ETSIIValente/utils/fileUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';

import 'circuit_designer_2_meshes.dart';
import 'circuit_designer_3_meshes.dart';
import 'circuit_designer_4_meshes.dart';
import 'circuits/Circuit.dart';
import 'circuits/CircuitManager.dart';
import 'circuits/ThreeMeshCircuit.dart';

void main() {
  // Initialize session
  WidgetsFlutterBinding.ensureInitialized();
  CircuitManager();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ETSIIValente',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.brown).copyWith(background: Colors.white),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset('assets/logo_etsii.png', fit: BoxFit.cover, height: 60),
            Expanded(
              child: Center(
                child: Text(
                  'ETSIIValente',
                  style: TextStyle(
                    color: Colors.brown.darker(30),
                    fontSize: 36,
                    fontWeight: FontWeight.bold, 
                    letterSpacing: 1.1, // Espaciado entre letras aumentado
                    shadows: [ // Sombra para mejorar la legibilidad
                      Shadow(
                        offset: Offset(0.25, 0.25),
                        blurRadius: 0.25,
                        color: Colors.brown,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedCircuitsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.brown.darker(10),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              child: Text('Circuitos guardados', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        toolbarHeight: 90,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Calcula el circuito equivalente Thevenin',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36, // Tamaño de fuente grande
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.darker(30)
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Elige la estructura, diseña y resuelve.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.brown.darker(20)),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 190,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.brown.darker(18),
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                        ),
                        child: Text('Diseñar', style: TextStyle(color: Colors.white, fontSize: 18)),
                        onPressed: () {
                          _showMeshSelectionDialog(context);
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                        width: 190,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.brown.darker(18),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                          ),
                          child: Text('Importar', style: TextStyle(color: Colors.white, fontSize: 18)),
                          onPressed: () {
                            _handleImport(context);
                          },
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: IconButton(
              icon: Icon(Icons.info_outline, color: Colors.brown,size: 28),
              onPressed: () {
                _showInfoDialog(context);
              },
            ),
          ),
        ],
      )

    );
  }

  void _showMeshSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Bordes redondeados
          ),
          title: Text('Selecciona el número de mallas', textAlign: TextAlign.center),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: Text('2 Mallas', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CircuitDesigner2Meshes(circuit: TwoMeshCircuit())));
                  },
                ),
                ListTile(
                  title: Text('3 Mallas', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CircuitDesigner3Meshes(circuit: ThreeMeshCircuit())));
                  },
                ),
                ListTile(
                  title: Text('4 Mallas', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CircuitDesigner4Meshes(circuit: FourMeshCircuit())));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> _handleImport(BuildContext context) async {
    // Use file picker to get the file path where the data is be saved.
    String? filePath = await FileUtils.selectFile();
    // Read the serialized JSON data to the selected file.
    if (filePath != null) {
      try {
        String? data = await FileUtils.readFromFile(filePath);
        if (data == null) {
          throw Exception("Error leyendo el fichero");
        }
        Circuit circuit = Circuit.fromJson(data);
        if (circuit is TwoMeshCircuit) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CircuitDesigner2Meshes(circuit: circuit)));
        } else if (circuit is ThreeMeshCircuit) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CircuitDesigner3Meshes(circuit: circuit)));
        } else if (circuit is FourMeshCircuit) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CircuitDesigner4Meshes(circuit: circuit)));
        }
      } on Exception catch (_) {
        // Validation error
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error al importar circuito"),
                content: Text("El formato del fichero no es valido"),
                actions: <Widget>[
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
    } else {
      print('No file selected.');
    }
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(Icons.info, size: 40, color: Colors.brown),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ETSIIValente-v1.0', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                SizedBox(height: 10),
                Text('Desarrollado por Mario Canales Torres', style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
