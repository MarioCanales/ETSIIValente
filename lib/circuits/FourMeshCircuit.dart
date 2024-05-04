import 'dart:convert';

import '../circuitComponents/CircuitMesh.dart';
import '../circuitComponents/TheveninEquivalent.dart';
import '../electricComponents/current_source.dart';
import '../electricComponents/resistor.dart';
import '../electricComponents/voltage_source.dart';
import 'Circuit.dart';

enum FourMeshCircuitIdentifier { branch1, branch2, branch3, branch4, branch5, branch6, branch7, branch8, branch9, branch10}

class FourMeshCircuit extends Circuit {
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
  // Branch8
  CircuitBranch branch8;
  // Branch9
  CircuitBranch branch9;
  // Branch10
  CircuitBranch branch10;

  //No-args
  FourMeshCircuit()
      : branch1 = CircuitBranch(),
        branch2 = CircuitBranch(),
        branch3 = CircuitBranch(),
        branch4 = CircuitBranch(),
        branch5 = CircuitBranch(),
        branch6 = CircuitBranch(),
        branch7 = CircuitBranch(),
        branch8 = CircuitBranch(),
        branch9 = CircuitBranch(),
        branch10 = CircuitBranch();

  FourMeshCircuit.withComponents(this.branch1, this.branch2, this.branch3, this.branch4, this.branch5, this.branch6, this.branch7, this.branch8, this.branch9, this.branch10);

  CircuitBranch getBranch(FourMeshCircuitIdentifier id) {
    if (id == FourMeshCircuitIdentifier.branch1) {
      return branch1;
    } else if (id == FourMeshCircuitIdentifier.branch2) {
      return branch2;
    } else if (id == FourMeshCircuitIdentifier.branch3) {
      return branch3;
    } else if (id == FourMeshCircuitIdentifier.branch4) {
      return branch4;
    } else if (id == FourMeshCircuitIdentifier.branch5) {
      return branch5;
    } else if (id == FourMeshCircuitIdentifier.branch6) {
      return branch6;
    } else if (id == FourMeshCircuitIdentifier.branch7) {
      return branch7;
    } else if (id == FourMeshCircuitIdentifier.branch8) {
      return branch8;
    } else if (id == FourMeshCircuitIdentifier.branch9) {
      return branch9;
    } else {
      return branch10;
    }
  }

  /// Serialize the circuit to a JSON string.
  @override
  String toJson() {
    return jsonEncode({
      'type': 'FourMeshCircuit',
      'branch1': branch1.toJson(),
      'branch2': branch2.toJson(),
      'branch3': branch3.toJson(),
      'branch4': branch4.toJson(),
      'branch5': branch5.toJson(),
      'branch6': branch6.toJson(),
      'branch7': branch7.toJson(),
      'branch8': branch8.toJson(),
      'branch9': branch9.toJson(),
      'branch10': branch10.toJson()
    });
  }

  /// Deserialize the circuit from a JSON string.
  static FourMeshCircuit fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return FourMeshCircuit.withComponents(
        CircuitBranch.fromJson(map['branch1']),
        CircuitBranch.fromJson(map['branch2']),
        CircuitBranch.fromJson(map['branch3']),
        CircuitBranch.fromJson(map['branch4']),
        CircuitBranch.fromJson(map['branch5']),
        CircuitBranch.fromJson(map['branch6']),
        CircuitBranch.fromJson(map['branch7']),
        CircuitBranch.fromJson(map['branch8']),
        CircuitBranch.fromJson(map['branch9']),
        CircuitBranch.fromJson(map['branch10'])
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
      ...branch8.resistors,
      ...branch9.resistors,
      ...branch10.resistors,
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
      ...branch8.currentSources,
      ...branch9.currentSources,
      ...branch10.currentSources,
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
      ...branch8.voltageSources,
      ...branch9.voltageSources,
      ...branch10.voltageSources,
    ];
  }

  bool hasCurrentSource(FourMeshCircuitIdentifier id) {
    if(id == FourMeshCircuitIdentifier.branch1) {
      return branch1.currentSources.isNotEmpty;
    } else if (id == FourMeshCircuitIdentifier.branch2) {
      return branch2.currentSources.isNotEmpty;
    } else if (id == FourMeshCircuitIdentifier.branch3) {
      return branch3.currentSources.isNotEmpty;
    } else if (id == FourMeshCircuitIdentifier.branch4) {
      return branch4.currentSources.isNotEmpty;
    } else if (id == FourMeshCircuitIdentifier.branch5) {
      return branch5.currentSources.isNotEmpty;
    } else if (id == FourMeshCircuitIdentifier.branch6) {
      return branch6.currentSources.isNotEmpty;
    }  else if (id == FourMeshCircuitIdentifier.branch7) {
      return branch7.currentSources.isNotEmpty;
    } else if (id == FourMeshCircuitIdentifier.branch8) {
      return branch8.currentSources.isNotEmpty;
    } else if (id == FourMeshCircuitIdentifier.branch9) {
      return branch9.currentSources.isNotEmpty;
    } else {
      return branch10.currentSources.isNotEmpty;
    }
  }

  TheveninEquivalent calculateTheveninEquivalent() {
    // TODO: implement functionality
    return TheveninEquivalent(44.44, 44.44);
  }
}
