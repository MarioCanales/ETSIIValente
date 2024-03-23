import 'dart:math';
import 'dart:ui';

class CircuitLine {
  final Offset start;
  final Offset end;

  CircuitLine(this.start, this.end);

  void draw(Canvas canvas, Paint paint) {
    canvas.drawLine(start, end, paint);
  }

  double distanceToPoint(Offset point) {
    // Horizontal
    if (start.dy == end.dy) {
      if (point.dx >= start.dx && point.dx <= end.dx) {
        return (point.dy - start.dy).abs(); // Distance is the vertical difference
      } else {
        // Point is outside the horizontal span of the line
        double distanceStart = (point - start).distance;
        double distanceEnd = (point - end).distance;
        return min(distanceStart, distanceEnd);
      }
    } else { // vertical
      if (point.dy >= start.dy && point.dy <= end.dy) {
        return (point.dx - start.dx).abs(); // Distance is the horizontal difference
      } else {
        // Point is outside the vertical span of the line
        double distanceStart = (point - start).distance;
        double distanceEnd = (point - end).distance;
        return min(distanceStart, distanceEnd);
      }
    }
  }
}