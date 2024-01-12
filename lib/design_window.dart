import 'package:flutter/material.dart';
import 'package:thevenin_norton/painter/circuit_painter.dart';

class DesginWindow extends StatelessWidget {
  final int selectedMeshes;

  DesginWindow({required this.selectedMeshes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Design Screen'),
      ),
      body: Center(
        child: CustomPaint(
          size: Size(850,350),
          painter: CircuitPainter(selectedMeshes),
        ),
      ),
    );
  }
}