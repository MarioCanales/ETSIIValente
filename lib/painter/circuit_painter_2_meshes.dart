import 'package:flutter/material.dart';
import 'package:thevenin_norton/painter/base_circuit_painter.dart';
import 'package:thevenin_norton/utils/mesh_segment_calculator.dart';

import '../components/resistor.dart';
import '../utils/mesh.dart';

class CircuitPainter2Meshes extends BaseCircuitPainter {

  final List<Resistor> resistors;
  late Mesh mesh1;
  late Mesh mesh2;

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

    mesh1 = MeshSegmentCalculator.calculateMesh(left, top, mid, bottom);
    mesh2 = MeshSegmentCalculator.calculateMesh(mid, top, right, bottom);

    mesh1.drawMesh(paint, canvas);
    mesh2.drawMesh(paint, canvas);

  }

  @override
  bool isValidPosition(Offset offset) {
    return mesh1.isNearMesh(offset) || mesh2.isNearMesh(offset);
  }
}
