

import '../circuitComponents/CircuitMesh.dart';
import '../circuitComponents/TheveninEquivalent.dart';
import 'Circuit.dart';

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
    return TheveninEquivalent(3, 33);
  }
}
