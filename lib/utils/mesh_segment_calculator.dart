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
    LineSegment bottomSegment = LineSegment(Offset(right,bottom), Offset(left,bottom));
    LineSegment leftSegment = LineSegment(Offset(left,bottom), Offset(left,top));
    LineSegment topSegment = LineSegment(Offset(left,top), Offset(right,top));
    LineSegment rightSegment = LineSegment(Offset(right,top), Offset(right,bottom));
    return Mesh(bottom: bottomSegment, left: leftSegment, top: topSegment, right: rightSegment);
  }
}