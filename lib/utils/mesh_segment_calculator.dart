import 'dart:ui';

import 'circuit_segment.dart';
import 'mesh.dart';

class MeshSegmentCalculator {
  static Mesh calculateMesh(
      double left,
      double top,
      double right,
      double bottom)
  {
    CircuitSegment bottomSegment = CircuitSegment(Offset(right,bottom), Offset(left,bottom), List.empty());
    CircuitSegment leftSegment = CircuitSegment(Offset(left,bottom), Offset(left,top), List.empty());
    CircuitSegment topSegment = CircuitSegment(Offset(left,top), Offset(right,top), List.empty());
    CircuitSegment rightSegment = CircuitSegment(Offset(right,top), Offset(right,bottom), List.empty());
    return Mesh(bottom: bottomSegment, left: leftSegment, top: topSegment, right: rightSegment);
  }
}