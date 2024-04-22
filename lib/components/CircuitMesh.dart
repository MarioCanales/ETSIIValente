import 'package:ETSIIValente/electricComponents/electric_component.dart';

import '../electricComponents/current_source.dart';
import '../electricComponents/resistor.dart';
import '../electricComponents/voltage_source.dart';
class CircuitMesh {
  List<Resistor> resistors;
  List<VoltageSource> voltageSources;
  List<CurrentSource> currentSources;

  //No-args
  CircuitMesh()
      : resistors = [],
        voltageSources = [],
        currentSources = [];

  CircuitMesh.withComponents(this.resistors, this.voltageSources, this.currentSources);

  void addResistor(Resistor r) {
    resistors.add(r);
  }

  void addVoltageSource(VoltageSource v) {
    voltageSources.add(v);
  }

  void addCurrentSource(CurrentSource c) {
    currentSources.add(c);
  }

  void deleteComponent(ElectricComponent component) {
    if (component is Resistor) {
      resistors.removeWhere((element) =>
      element.position == component.position &&
          element.resistance == component.resistance
      );
    } else if (component is VoltageSource) {
      voltageSources.removeWhere((element) =>
      element.position == component.position &&
          element.voltage == component.voltage
      );
    } else if (component is CurrentSource) {
      currentSources.removeWhere((element) =>
      element.position == component.position &&
          element.current == component.current
      );
    }
  }

// TODO: Implement rotateSource
// TODO: Implement deleteComponent
}
