import 'dart:ui';

import 'circuit_segment.dart';

class Mesh {
  CircuitSegment bottom;
  CircuitSegment left;
  CircuitSegment top;
  CircuitSegment right;

  Mesh({required this.bottom, required this.left, required this.top, required this.right});

  void drawMesh(Paint paint, Canvas canvas) {
    bottom.draw(paint, canvas);
    left.draw(paint, canvas);
    top.draw(paint, canvas);
    right.draw(paint, canvas);
  }

  bool isNearMesh(Offset offset) {
    return bottom.isPointNear(offset, 10) || left.isPointNear(offset, 10) ||
        top.isPointNear(offset, 10) || right.isPointNear(offset, 10);
  }
}




