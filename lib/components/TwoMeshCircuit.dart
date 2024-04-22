import 'package:ETSIIValente/components/TheveninEquivalent.dart';

import 'CircuitMesh.dart';

enum TwoMeshCircuitIdentifier { branch1, branch2, branch3, branch4}

class TwoMeshCircuit {
  CircuitBranch branch1;
  // Mesh2
  CircuitBranch branch2;
  // Mesh3
  CircuitBranch branch3;
  // Mesh 4
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
    // As per Alfonso doc

    // Resistance calculation
    double theveninResistance = 0;
    for(var resistor in branch1.resistors) {
      theveninResistance += resistor.resistance;
    }
    for(var resistor in branch2.resistors) {
      theveninResistance += resistor.resistance;
    }
    // Calculate accumulated values per mesh
    double mesh4Resistance = 0;
    for(var resistor in branch4.resistors){
      mesh4Resistance += resistor.resistance;
    }
    double mesh3Resistance = 0;
    for(var resistor in branch3.resistors){
      mesh3Resistance += resistor.resistance;
    }

    if(hasCurrentSource(TwoMeshCircuitIdentifier.branch3)) {
      // Add Mesh4 resistance
      theveninResistance += mesh4Resistance;
    } else if(hasCurrentSource(TwoMeshCircuitIdentifier.branch4)) {
      // Add Mesh3 resistance
      theveninResistance += mesh3Resistance;
    } else {
      // No current sources in the circuit -> R4 || R3
      theveninResistance += (mesh3Resistance*mesh4Resistance)/(mesh3Resistance+mesh4Resistance);
    }

    // TODO: add voltage calculation logic
    return TheveninEquivalent(5, theveninResistance);
  }
}
