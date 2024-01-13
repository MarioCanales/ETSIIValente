import 'package:flutter/material.dart';
import 'package:thevenin_norton/painter/circuit_painter.dart';
import 'package:thevenin_norton/painter/circuit_painter_2_meshes.dart';

class DesignWindow extends StatelessWidget {
  final int selectedMeshes;

  DesignWindow({required this.selectedMeshes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Design Screen'),
      ),
      body: Center(
        child: CustomPaint(
          size: Size(850,350),
          painter: _getPainterForMeshes(selectedMeshes),
        ),
      ),
    );
  }
  
  CustomPainter _getPainterForMeshes(int meshes) {
    switch (meshes) {
      case 2:
        return CircuitPainter2Meshes();
      default:
        return CircuitPainter(meshes);
    }
  }
}