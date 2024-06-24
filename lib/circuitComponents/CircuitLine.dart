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
    // Horizontal, fijamos componente y
    if (start.dy == end.dy) {
      if (point.dx >= start.dx && point.dx <= end.dx) {
        // Coordenada x en el ancho del segmento
        return (point.dy - start.dy).abs(); // Distancia en vertical
      } else {
        // Coordenada a la izq o derecha del segmento
        double distanceStart = (point - start).distance;
        double distanceEnd = (point - end).distance;
        return min(distanceStart, distanceEnd);
      }
    } else { // vertical, fijamos componente x y misma lógica que arriba
      if (point.dy >= start.dy && point.dy <= end.dy) {
        return (point.dx - start.dx).abs();
      } else {
        double distanceStart = (point - start).distance;
        double distanceEnd = (point - end).distance;
        return min(distanceStart, distanceEnd);
      }
    }
  }
}