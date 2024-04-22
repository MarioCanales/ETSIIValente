import 'package:flutter/material.dart';

import '../electricComponents/electric_component.dart';
/*
This class will represent either vertical or horizontal lines and a function
to detect if a point is near with a margin of tolerance
 */
class CircuitSegment {
  Offset start;
  Offset end;
  List<ElectricComponent> components;


  CircuitSegment(this.start, this.end, this.components);

  bool isPointNear(Offset point, double tolerance) {
    if (start.dx == end.dx) { // Vertical line
      return (point.dx >= start.dx - tolerance && point.dx <= start.dx + tolerance) &&
             (point.dy >= start.dy && point.dy <= end.dy);
    } else { // Horizontal line
      return (point.dy >= start.dy - tolerance && point.dy <= start.dy + tolerance) &&
             (point.dx >= start.dx && point.dx <= end.dx);
    }
  }

  void draw(Paint paint, Canvas canvas) {
    canvas.drawLine(start, end, paint);
  }
}
