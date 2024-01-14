import 'package:flutter/material.dart';
import 'package:thevenin_norton/painter/base_circuit_painter.dart';
import 'package:thevenin_norton/painter/circuit_painter_2_meshes.dart';
import 'package:thevenin_norton/painter/circuit_painter_3_meshes.dart';
import 'package:thevenin_norton/painter/circuit_painter_4_meshes.dart';

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
      appBar: AppBar(
        title: const Text('Design Screen'),
      ),
      body: Stack(
        children: [
          const Positioned(
            top: 50,
            left: 50,
            child: DraggableResistor(), // The draggable resistor
          ),
          Center(
            child: DragTarget<Resistor>(
              onAccept: (resistor) {
                setState(() {
                  resistors.add(resistor); // Add the resistor to the circuit
                });
              },
              builder: (context, candidateData, rejectedData) {
                return CustomPaint(
                  size: const Size(850, 350),
                  painter: _getPainterForMeshes(meshes: widget.selectedMeshes, resistors: resistors)
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  BaseCircuitPainter _getPainterForMeshes( {required int meshes,required List<Resistor> resistors}) {
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

