import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:thevenin_norton/painter/base_circuit_painter.dart';
import 'package:thevenin_norton/utils/mesh_segment_calculator.dart';

import '../components/resistor.dart';
import '../utils/mesh.dart';

class CircuitPainter2Meshes extends BaseCircuitPainter {

  final List<Resistor> resistors;

  CircuitPainter2Meshes({int meshes = 2, this.resistors = const []}) :
        super(meshes);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Calculate positions
    assignBorders(size);
    double mid = left + (right - left)/2;

    Mesh mesh1 = MeshSegmentCalculator.calculateMesh(left, top, mid, bottom);
    Mesh mesh2 = MeshSegmentCalculator.calculateMesh(mid, top, right, bottom);

    mesh1.drawMesh(paint, canvas);
    mesh2.drawMesh(paint, canvas);

  }
}
