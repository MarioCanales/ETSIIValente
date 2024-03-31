import 'dart:ui';

import 'package:ETSIIValente/components/electric_component.dart';

class VoltageSource extends ElectricComponent{
  double voltage;
  int sign;
  VoltageSource(Offset position, this.voltage, this.sign): super(position);
}