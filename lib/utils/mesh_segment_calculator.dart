import 'dart:ui';

import 'package:thevenin_norton/utils/line_segment.dart';
import 'package:thevenin_norton/utils/mesh.dart';

class MeshSegmentCalculator {
  static Mesh calculateMesh(
      double left,
      double top,
      double right,
      double bottom)
  {
    LineSegment low = LineSegment(Offset(right,bottom), Offset(left,bottom));
    LineSegment vert = LineSegment(Offset(left,bottom), Offset(left,top));
    LineSegment up = LineSegment(Offset(left,top), Offset(right,top));
    return Mesh(low: low, vert: vert, up: up);
  }
}