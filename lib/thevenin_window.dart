import 'package:ETSIIValente/components/TheveninEquivalent.dart';
import 'package:ETSIIValente/components/TwoMeshCircuit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TheveninWindow extends StatelessWidget {
  final TwoMeshCircuit circuit;

  const TheveninWindow({Key? key, required this.circuit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TheveninEquivalent equivalent = circuit.calculateTheveninEquivalent();
    return Scaffold(
      appBar: AppBar(
        title: Text("Equivalente Thevenin"),
      ),
      body: Center(
        child: CustomPaint(
            painter: TheveninPainter(equivalent.resistance, equivalent.voltage),
            size: Size(200,100),
          ),
        )
      );
  }
}

class TheveninPainter extends CustomPainter {
  final double resistance;
  final double voltage;

  TheveninPainter(this.resistance, this.voltage);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = 3;

    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint); // Top line
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint); // Left line
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);

    // Add your voltage source and resistor representations here
    // This is a placeholder for drawing
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'V = $voltage , R = $resistance',
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 4, size.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

}