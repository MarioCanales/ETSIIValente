import 'electric_component.dart';

class VoltageSource extends ElectricComponent {
  double voltage;
  VoltageSource({double position = 0, this.voltage = 1.0}):
        super(position: position);
}
