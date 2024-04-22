import 'package:ETSIIValente/components/TheveninEquivalent.dart';

import '../electricComponents/current_source.dart';
import '../electricComponents/resistor.dart';
import '../electricComponents/voltage_source.dart';
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

  bool hasCurrentSource(TwoMeshCircuitIdentifier id) {
    if(id == TwoMeshCircuitIdentifier.mesh1) {
      return mesh1.currentSources.isNotEmpty;
    } else if (id == TwoMeshCircuitIdentifier.mesh2) {
      return mesh2.currentSources.isNotEmpty;
    } else if (id == TwoMeshCircuitIdentifier.mesh3) {
      return mesh3.currentSources.isNotEmpty;
    } else {
      return mesh4.currentSources.isNotEmpty;
    }
  }


  TheveninEquivalent calculateTheveninEquivalent() {
    // As per Alfonso doc

    // Resistance calculation
    double theveninResistance = 0;
    for(var resistor in mesh1.resistors) {
      theveninResistance += resistor.resistance;
    }
    for(var resistor in mesh2.resistors) {
      theveninResistance += resistor.resistance;
    }
    // Calculate accumulated values per mesh
    double mesh4Resistance = 0;
    for(var resistor in mesh4.resistors){
      mesh4Resistance += resistor.resistance;
    }
    double mesh3Resistance = 0;
    for(var resistor in mesh3.resistors){
      mesh3Resistance += resistor.resistance;
    }

    if(hasCurrentSource(TwoMeshCircuitIdentifier.mesh3)) {
      // Add Mesh4 resistance
      theveninResistance += mesh4Resistance;
    } else if(hasCurrentSource(TwoMeshCircuitIdentifier.mesh4)) {
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
