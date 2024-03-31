import 'dart:ui';
import 'electric_component.dart';

class Resistor extends ElectricComponent {
  double resistance;
  Resistor(Offset position, this.resistance) : super(position);
}
