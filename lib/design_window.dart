import 'package:ETSIIValente/painter/base_circuit_painter.dart';
import 'package:ETSIIValente/painter/circuit_painter_2_meshes.dart';
import 'package:ETSIIValente/painter/circuit_painter_3_meshes.dart';
import 'package:ETSIIValente/painter/circuit_painter_4_meshes.dart';
import 'package:flutter/material.dart';

import 'components/resistor.dart';

class DesignWindow extends StatefulWidget {
  final int selectedMeshes;

  const DesignWindow({super.key, required this.selectedMeshes});

  @override
  _DesignWindowState createState() => _DesignWindowState();
}

class _DesignWindowState extends State<DesignWindow> {
  List<Resistor> resistors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design Screen')),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      //TBD
                    },
                    child: Image.asset('assets/resistor.jpg',
                        width: 40, height: 40)),
                GestureDetector(
                    onTap: () {
                      //TBD
                    },
                    child: Image.asset('assets/voltajeFuente.png',
                        width: 40, height: 40)),
                GestureDetector(
                  onTap: () {
                    //TBD
                  },
                  child: Image.asset('assets/fuenteIntensidad.png',
                      width: 40, height: 40),
                )
              ],
            ),
          ),
          SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.8, // 50% of screen width
            height: MediaQuery.of(context).size.height *
                0.5, // 30% of screen height,
            child: CustomPaint(
              painter: _getPainterForMeshes(
                  meshes: widget.selectedMeshes, resistors: resistors),
            ),
          )
        ],
      ),
    );
  }

  BaseCircuitPainter _getPainterForMeshes(
      {required int meshes, required List<Resistor> resistors}) {
    switch (meshes) {
      case 2:
        return CircuitPainter2Meshes(meshes: meshes, resistors: resistors);
      case 3:
        return CircuitPainter3Meshes(meshes: meshes, resistors: resistors);
      default:
        return CircuitPainter4Meshes(meshes: meshes, resistors: resistors);
    }
  }
}
