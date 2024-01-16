import 'electric_component.dart';

class CurrentSource extends ElectricComponent {
  double current;
  CurrentSource({double position = 0, this.current = 1.0}):
        super(position: position);
}
