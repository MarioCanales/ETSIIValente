import 'package:ETSIIValente/painter/base_circuit_painter.dart';
import 'package:flutter/material.dart';

import '../components/resistor.dart';
import '../utils/mesh.dart';
import '../utils/mesh_segment_calculator.dart';

class CircuitPainter3Meshes extends BaseCircuitPainter {

  final List<Resistor> resistors;

  late Mesh mesh1;
  late Mesh mesh2;
  late Mesh mesh3;

  CircuitPainter3Meshes({int meshes = 3, this.resistors = const []}) :
        super(meshes);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Calculate positions
    assignBorders(size);
    double meshWidht = (right - left)/3;

    mesh1 = MeshSegmentCalculator.calculateMesh(left, top, left + meshWidht, bottom);
    mesh2 = MeshSegmentCalculator.calculateMesh(left + meshWidht, top, left + 2 * meshWidht, bottom);
    mesh3 = MeshSegmentCalculator.calculateMesh(left + 2 *meshWidht, top, right, bottom);

    mesh1.drawMesh(paint, canvas);
    mesh2.drawMesh(paint, canvas);
    mesh3.drawRightMesh(paint, canvas);

  }

  @override
  bool isValidPosition(Offset offset) {
    return mesh1.isNearMesh(offset) || mesh2.isNearMesh(offset) || mesh3.isNearMesh(offset);
  }
}