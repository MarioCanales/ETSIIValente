
import 'dart:convert';
import 'dart:ui';

import 'package:ETSIIValente/electricComponents/current_source.dart';
import 'package:ETSIIValente/electricComponents/voltage_source.dart';

import '../circuitComponents/CircuitMesh.dart';
import '../circuitComponents/TheveninEquivalent.dart';
import '../electricComponents/resistor.dart';
import 'Circuit.dart';
import 'TwoMeshCircuit.dart';

enum ThreeMeshCircuitIdentifier { branch1, branch2, branch3, branch4, branch5, branch6, branch7}

class ThreeMeshCircuit extends Circuit {
  // Branch1
  CircuitBranch branch1;
  // Branch2
  CircuitBranch branch2;
  // Branch3
  CircuitBranch branch3;
  // Branch4
  CircuitBranch branch4;
  // Branch5
  CircuitBranch branch5;
  // Branch6
  CircuitBranch branch6;
  // Branch7
  CircuitBranch branch7;

  //No-args
  ThreeMeshCircuit()
      : branch1 = CircuitBranch(),
        branch2 = CircuitBranch(),
        branch3 = CircuitBranch(),
        branch4 = CircuitBranch(),
        branch5 = CircuitBranch(),
        branch6 = CircuitBranch(),
        branch7 = CircuitBranch();

  ThreeMeshCircuit.withComponents(this.branch1, this.branch2, this.branch3, this.branch4, this.branch5, this.branch6, this.branch7);

  CircuitBranch getBranch(ThreeMeshCircuitIdentifier id) {
    if(id == ThreeMeshCircuitIdentifier.branch1) {
      return branch1;
    } else if (id == ThreeMeshCircuitIdentifier.branch2) {
      return branch2;
    } else if (id == ThreeMeshCircuitIdentifier.branch3) {
      return branch3;
    } else if (id == ThreeMeshCircuitIdentifier.branch4) {
      return branch4;
    } else if (id == ThreeMeshCircuitIdentifier.branch5) {
      return branch5;
    } else if (id == ThreeMeshCircuitIdentifier.branch6) {
      return branch6;
    } else {
      return branch7;
    }
  }

  /// Serialize the circuit to a JSON string.
  String toJson() {
    return jsonEncode({
      'type': 'ThreeMeshCircuit',
      'branch1': branch1.toJson(),
      'branch2': branch2.toJson(),
      'branch3': branch3.toJson(),
      'branch4': branch4.toJson(),
      'branch5': branch5.toJson(),
      'branch6': branch6.toJson(),
      'branch7': branch7.toJson()
    });
  }

  /// Deserialize the circuit from a JSON string.
  static ThreeMeshCircuit fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return ThreeMeshCircuit.withComponents(
      CircuitBranch.fromJson(map['branch1']),
      CircuitBranch.fromJson(map['branch2']),
      CircuitBranch.fromJson(map['branch3']),
      CircuitBranch.fromJson(map['branch4']),
      CircuitBranch.fromJson(map['branch5']),
      CircuitBranch.fromJson(map['branch6']),
      CircuitBranch.fromJson(map['branch7'])
    );
  }

  List<Resistor> getResistors() {
    return [
      ...branch1.resistors,
      ...branch2.resistors,
      ...branch3.resistors,
      ...branch4.resistors,
      ...branch5.resistors,
      ...branch6.resistors,
      ...branch7.resistors,
    ];
  }

  List<CurrentSource> getCurrentSources() {
    return [
      ...branch1.currentSources,
      ...branch2.currentSources,
      ...branch3.currentSources,
      ...branch4.currentSources,
      ...branch5.currentSources,
      ...branch6.currentSources,
      ...branch7.currentSources,
    ];
  }

  List<VoltageSource> getVoltageSources() {
    return [
      ...branch1.voltageSources,
      ...branch2.voltageSources,
      ...branch3.voltageSources,
      ...branch4.voltageSources,
      ...branch5.voltageSources,
      ...branch6.voltageSources,
      ...branch7.voltageSources,
    ];
  }

  bool hasCurrentSource(ThreeMeshCircuitIdentifier id) {
    if(id == ThreeMeshCircuitIdentifier.branch1) {
      return branch1.currentSources.isNotEmpty;
    } else if (id == ThreeMeshCircuitIdentifier.branch2) {
      return branch2.currentSources.isNotEmpty;
    } else if (id == ThreeMeshCircuitIdentifier.branch3) {
      return branch3.currentSources.isNotEmpty;
    } else if (id == ThreeMeshCircuitIdentifier.branch4) {
      return branch4.currentSources.isNotEmpty;
    } else if (id == ThreeMeshCircuitIdentifier.branch5) {
      return branch5.currentSources.isNotEmpty;
    } else if (id == ThreeMeshCircuitIdentifier.branch6) {
      return branch6.currentSources.isNotEmpty;
    } else {
      return branch7.currentSources.isNotEmpty;
    }
  }

  TheveninEquivalent calculateTheveninEquivalent() {

    double theveninVoltage = 0;
    double theveninResistance = 0;

    if(hasCurrentSource(ThreeMeshCircuitIdentifier.branch6) &&
        hasCurrentSource(ThreeMeshCircuitIdentifier.branch7)) {

      double r1 = 0;
      double r2 = 0;
      double r3 = 0;
      for (var resistor in branch1.resistors) {
        r1 += resistor.resistance;
      }
      for (var resistor in branch2.resistors) {
        r2 += resistor.resistance;
      }
      for (var resistor in branch3.resistors) {
        r3 += resistor.resistance;
      }

      double i3 = (branch6.currentSources.first.current * branch6.currentSources.first.sign) +
          (branch7.currentSources.first.current * branch7.currentSources.first.sign);

      double v1 = 0;
      double v2 = 0;
      double v3 = 0;

      for (var voltSource in branch1.voltageSources) {
        v1 += voltSource.voltage * voltSource.sign;
      }
      for (var voltSource in branch2.voltageSources) {
        v2 += voltSource.voltage * voltSource.sign;
      }
      for (var voltSource in branch3.voltageSources) {
        v3 += voltSource.voltage * voltSource.sign;
      }

      theveninResistance = r1 + r2 + r3;
      theveninVoltage = v1 + v2 + v3 + (r3*i3);
    } else {
      // 1 CUT IN LEFT AND CALCULATE EQUIV
      TwoMeshCircuit aux = TwoMeshCircuit();
      aux.branch1 = CircuitBranch(); // empty
      aux.branch2 = CircuitBranch(); // empty
      aux.branch3 = branch6;
      aux.branch4 = branch7;

      TheveninEquivalent auxEquiv = aux.calculateTheveninEquivalent();

      // PASTE TO THE MISSING PIECE

      TwoMeshCircuit aux2 = TwoMeshCircuit();
      aux2.branch1 = branch1; // empty
      aux2.branch2 = branch2; // empty
      aux2.branch3 = branch3;

      aux2.branch4 = CircuitBranch();
      aux2.branch4.currentSources = [
        ...branch4.currentSources,
        ...branch5.currentSources
      ];
      aux2.branch4.voltageSources = [
        ...branch4.voltageSources,
        ...branch5.voltageSources,
        VoltageSource(Offset(0,0), auxEquiv.voltage.abs(), auxEquiv.voltage < 0 ? -1 : 1)
      ];
      aux2.branch4.resistors = [
        ...branch4.resistors,
        ...branch5.resistors,
        Resistor(Offset(0,0), auxEquiv.resistance)
      ];

      TheveninEquivalent finalEquiv = aux2.calculateTheveninEquivalent();
      theveninVoltage = finalEquiv.voltage;
      theveninResistance = finalEquiv.resistance;
    }


    return TheveninEquivalent(theveninVoltage, theveninResistance);
  }
}
