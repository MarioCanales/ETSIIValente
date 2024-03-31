import 'dart:ui';

import 'electric_component.dart';

class CurrentSource extends ElectricComponent{
  double current;
  int sign;
  CurrentSource(Offset position, this.current, this.sign): super(position);
}
