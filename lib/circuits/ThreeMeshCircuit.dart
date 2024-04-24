

import 'dart:ui';

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
    // TODO: add calculation logic

    double theveninVoltage = 0;
    double theveninResistance = 0;

    if(hasCurrentSource(ThreeMeshCircuitIdentifier.branch6) &&
        hasCurrentSource(ThreeMeshCircuitIdentifier.branch7)) {
      //TODO: implement this case
      theveninResistance = 33.33;
      theveninVoltage = 33.33;
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
