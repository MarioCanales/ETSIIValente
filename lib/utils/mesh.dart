import 'dart:ui';

import 'line_segment.dart';

class Mesh {
  LineSegment low;
  LineSegment vert;
  LineSegment up;

  Mesh({required this.low, required this.vert, required this.up});

  void drawMesh(Paint paint, Canvas canvas) {
    _drawSegment(paint, canvas, low);
    _drawSegment(paint, canvas, vert);
    _drawSegment(paint, canvas, up);
  }

  void _drawSegment(Paint paint, Canvas canvas, LineSegment segment) {
    canvas.drawLine(segment.start, segment.end, paint);
  }

  bool isNearMesh(Offset offset) {
    return low.isPointNear(offset, 100) || up.isPointNear(offset, 100) || up.isPointNear(offset, 100);
  }
}




