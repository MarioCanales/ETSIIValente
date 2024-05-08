import 'dart:convert';
import 'dart:io';

import '../circuitComponents/CircuitMesh.dart';
import '../circuitComponents/TheveninEquivalent.dart';
import '../electricComponents/current_source.dart';
import '../electricComponents/resistor.dart';
import '../electricComponents/voltage_source.dart';
import 'Circuit.dart';

enum TwoMeshCircuitIdentifier { branch1, branch2, branch3, branch4}

class TwoMeshCircuit extends Circuit {
  // Branch1
  CircuitBranch branch1;
  // Branch2
  CircuitBranch branch2;
  // Branch3
  CircuitBranch branch3;
  // Branch4
  CircuitBranch branch4;
  //No-args
  TwoMeshCircuit()
      : branch1 = CircuitBranch(),
        branch2 = CircuitBranch(),
        branch3 = CircuitBranch(),
        branch4 = CircuitBranch();

  TwoMeshCircuit.withComponents(this.branch1, this.branch2, this.branch3, this.branch4);

  CircuitBranch getBranch(TwoMeshCircuitIdentifier id) {
    if(id == TwoMeshCircuitIdentifier.branch1) {
      return branch1;
    } else if (id == TwoMeshCircuitIdentifier.branch2) {
      return branch2;
    } else if (id == TwoMeshCircuitIdentifier.branch3) {
      return branch3;
    } else {
      return branch4;
    }
  }

  /// Serialize the circuit to a JSON string.
  String toJson() {
    return jsonEncode({
      'type': 'TwoMeshCircuit',
      'branch1': branch1.toJson(),
      'branch2': branch2.toJson(),
      'branch3': branch3.toJson(),
      'branch4': branch4.toJson(),
    });
  }

  /// Deserialize the circuit from a JSON string.
  static TwoMeshCircuit fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return TwoMeshCircuit.withComponents(
      CircuitBranch.fromJson(map['branch1']),
      CircuitBranch.fromJson(map['branch2']),
      CircuitBranch.fromJson(map['branch3']),
      CircuitBranch.fromJson(map['branch4']),
    );
  }

  List<Resistor> getResistors() {
    return [
      ...branch1.resistors,
      ...branch2.resistors,
      ...branch3.resistors,
      ...branch4.resistors
    ];
  }

  List<CurrentSource> getCurrentSources() {
    return [
      ...branch1.currentSources,
      ...branch2.currentSources,
      ...branch3.currentSources,
      ...branch4.currentSources,
    ];
  }

  List<VoltageSource> getVoltageSources() {
    return [
      ...branch1.voltageSources,
      ...branch2.voltageSources,
      ...branch3.voltageSources,
      ...branch4.voltageSources,
    ];
  }

  bool hasCurrentSource(TwoMeshCircuitIdentifier id) {
    if(id == TwoMeshCircuitIdentifier.branch1) {
      return branch1.currentSources.isNotEmpty;
    } else if (id == TwoMeshCircuitIdentifier.branch2) {
      return branch2.currentSources.isNotEmpty;
    } else if (id == TwoMeshCircuitIdentifier.branch3) {
      return branch3.currentSources.isNotEmpty;
    } else {
      return branch4.currentSources.isNotEmpty;
    }
  }


  TheveninEquivalent calculateTheveninEquivalent() {
    double r1 = 0;
    double r2 = 0;
    double r3 = 0;
    double r4 = 0;

    for (var resistor in branch1.resistors) {
      r1 += resistor.resistance;
    }
    for (var resistor in branch2.resistors) {
      r2 += resistor.resistance;
    }
    for (var resistor in branch3.resistors) {
      r3 += resistor.resistance;
    }
    for (var resistor in branch4.resistors) {
      r4 += resistor.resistance;
    }

    double v1 = 0;
    double v2 = 0;
    double v3 = 0;
    double v4 = 0;

    for (var voltSource in branch1.voltageSources) {
      v1 += voltSource.voltage * voltSource.sign;
    }
    for (var voltSource in branch2.voltageSources) {
      v2 += voltSource.voltage * voltSource.sign;
    }
    for (var voltSource in branch3.voltageSources) {
      v3 += voltSource.voltage * voltSource.sign;
    }
    for (var voltSource in branch4.voltageSources) {
      v4 += voltSource.voltage * voltSource.sign;
    }

    // As per Alfonso doc
    // Resistance calculation
    double theveninResistance = r1 + r2;
    if(hasCurrentSource(TwoMeshCircuitIdentifier.branch3)) {
      // Add Mesh4 resistance
      theveninResistance += r4;
    } else if(hasCurrentSource(TwoMeshCircuitIdentifier.branch4)) {
      // Add Mesh3 resistance
      theveninResistance += r3;
    } else if (r3+r4 != 0){
      // No current sources in the circuit -> R4 || R3
      theveninResistance += (r3*r4)/(r3+r4);
    }

    // Voltage calculation
    double theveninVoltage = v1 + v2;
    if(hasCurrentSource(TwoMeshCircuitIdentifier.branch3)) {
      // Caclulate VR4 and add
      double ir3 = branch3.currentSources.first.current*branch3.currentSources.first.sign;
      theveninVoltage += ir3*r4+v4;
    } else if (hasCurrentSource(TwoMeshCircuitIdentifier.branch4)) {
      // Calculate VR3 and add
      double ir4 = branch4.currentSources.first.current*branch4.currentSources.first.sign;
      theveninVoltage += ir4*r3+v3;
    } else {
      if(!(r3+r4== 0 && v3==0 && v4==0)) {
        // No vacio
        double i = (-v3 + v4)/(r3+r4);
        theveninVoltage += r3*i+v3;
      }
    }
    return TheveninEquivalent(theveninVoltage, theveninResistance);
  }

}
