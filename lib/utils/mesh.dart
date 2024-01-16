import 'dart:ui';

import 'line_segment.dart';

class Mesh {
  LineSegment bottom;
  LineSegment left;
  LineSegment top;
  LineSegment right;

  Mesh({required this.bottom, required this.left, required this.top, required this.right});

  void drawMesh(Paint paint, Canvas canvas) {
    _drawSegment(paint, canvas, bottom);
    _drawSegment(paint, canvas, left);
    _drawSegment(paint, canvas, top);
    _drawSegment(paint, canvas, right);
  }

  void _drawSegment(Paint paint, Canvas canvas, LineSegment segment) {
    canvas.drawLine(segment.start, segment.end, paint);
  }

  bool isNearMesh(Offset offset) {
    return bottom.isPointNear(offset, 10) || left.isPointNear(offset, 10) ||
        top.isPointNear(offset, 10) || right.isPointNear(offset, 10);
  }
}




