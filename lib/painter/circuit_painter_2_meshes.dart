import 'dart:ui';

import 'package:thevenin_norton/painter/base_circuit_painter.dart';

import '../components/resistor.dart';

class CircuitPainter2Meshes extends BaseCircuitPainter {

  final List<Resistor> resistors;

  CircuitPainter2Meshes({int meshes = 2, this.resistors = const []}) :
        super(meshes);

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    // Draw resistors

  }
}
