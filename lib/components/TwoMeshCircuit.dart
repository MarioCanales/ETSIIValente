import 'package:ETSIIValente/components/TheveninEquivalent.dart';

import '../components/current_source.dart';
import '../components/resistor.dart';
import '../components/voltage_source.dart';
import 'CircuitMesh.dart';

enum TwoMeshCircuitIdentifier { mesh1, mesh2, mesh3, mesh4}

class TwoMeshCircuit {
  CircuitMesh mesh1;
  // Mesh2
  CircuitMesh mesh2;
  // Mesh3
  CircuitMesh mesh3;
  // Mesh 4
  CircuitMesh mesh4;
  //No-args
  TwoMeshCircuit()
      : mesh1 = CircuitMesh(),
        mesh2 = CircuitMesh(),
        mesh3 = CircuitMesh(),
        mesh4 = CircuitMesh();

  TwoMeshCircuit.withComponents(this.mesh1, this.mesh2, this.mesh3, this.mesh4);

  CircuitMesh getMesh(TwoMeshCircuitIdentifier id) {
    if(id == TwoMeshCircuitIdentifier.mesh1) {
      return mesh1;
    } else if (id == TwoMeshCircuitIdentifier.mesh2) {
      return mesh2;
    } else if (id == TwoMeshCircuitIdentifier.mesh3) {
      return mesh3;
    } else {
      return mesh4;
    }
  }

  TheveninEquivalent calculateTheveninEquivalent() {
    // PLACEHOLDER VALUES
    // TODO: add logic
    return TheveninEquivalent(5, 7);
  }
}
