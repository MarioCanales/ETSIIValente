import 'package:ETSIIValente/electricComponents/electric_component.dart';

import '../electricComponents/current_source.dart';
import '../electricComponents/resistor.dart';
import '../electricComponents/voltage_source.dart';

class CircuitBranch {
  List<Resistor> resistors;
  List<VoltageSource> voltageSources;
  List<CurrentSource> currentSources;

  //No-args
  CircuitBranch()
      : resistors = [],
        voltageSources = [],
        currentSources = [];

  CircuitBranch.withComponents(this.resistors, this.voltageSources, this.currentSources);

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

  /// Serialize the circuit branch to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'resistors': resistors.map((resistor) => resistor.toJson()).toList(),
      'voltageSources': voltageSources.map((voltageSource) => voltageSource.toJson()).toList(),
      'currentSources': currentSources.map((currentSource) => currentSource.toJson()).toList(),
    };
  }

  /// Deserialize the circuit branch from a JSON object.
  static CircuitBranch fromJson(Map<String, dynamic> json) {
    return CircuitBranch.withComponents(
      json['resistors'].map<Resistor>((resistorJson) => Resistor.fromJson(resistorJson)).toList(),
      json['voltageSources'].map<VoltageSource>((voltageSourceJson) => VoltageSource.fromJson(voltageSourceJson)).toList(),
      json['currentSources'].map<CurrentSource>((currentSourceJson) => CurrentSource.fromJson(currentSourceJson)).toList(),
    );
  }

}
