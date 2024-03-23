import '../components/current_source.dart';
import '../components/resistor.dart';
import '../components/voltage_source.dart';

class CircuitMesh {
  List<Resistor> resistors = [];
  List<VoltageSource> voltageSources = [];
  List<CurrentSource> currentSources = [];

  CircuitMesh(this.resistors, this.voltageSources, this.currentSources);

  void addResistor(Resistor r) {
    resistors.add(r);
  }

  void addVoltageSource(VoltageSource v) {
    voltageSources.add(v);
  }

  void addCurrentSource(CurrentSource c) {
    currentSources.add(c);
  }
}