import 'dart:convert';
import 'dart:ui';

import 'package:ETSIIValente/circuits/ThreeMeshCircuit.dart';

import '../circuitComponents/CircuitBranch.dart';
import '../circuitComponents/TheveninEquivalent.dart';
import '../electricComponents/current_source.dart';
import '../electricComponents/resistor.dart';
import '../electricComponents/voltage_source.dart';
import 'Circuit.dart';
import 'TwoMeshCircuit.dart';

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

  // Serialize the circuit to a JSON string.
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

  // Deserialize the circuit from a JSON string.
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

    double theveninResistance = 0;
    double theveninVoltage = 0;

    double v1 = 0;
    double v2 = 0;
    for (var voltSource in branch1.voltageSources) {
      v1 += voltSource.voltage * voltSource.sign;
    }
    for (var voltSource in branch2.voltageSources) {
      v2 += voltSource.voltage * voltSource.sign;
    }

    double r1 = 0;
    double r2 = 0;
    for (var resistor in branch1.resistors) {
      r1 += resistor.resistance;
    }
    for (var resistor in branch2.resistors) {
      r2 += resistor.resistance;
    }

    // Caso especial fuentes 10, 9 y 6
    if (hasCurrentSource(FourMeshCircuitIdentifier.branch10) && hasCurrentSource(FourMeshCircuitIdentifier.branch9) && hasCurrentSource(FourMeshCircuitIdentifier.branch6)) {
      // Vamos por 3
      double r3 = 0;
      for (var resistor in branch3.resistors) {
        r3 += resistor.resistance;
      }

      double i3 =
          (branch6.currentSources.first.current * branch6.currentSources.first.sign) +
          (branch9.currentSources.first.current * branch9.currentSources.first.sign) +
          (branch10.currentSources.first.current * branch10.currentSources.first.sign);

      double v3 = 0;
      for (var voltSource in branch3.voltageSources) {
        v3 += voltSource.voltage * voltSource.sign;
      }

      theveninResistance = r1 + r2 + r3;
      theveninVoltage = v1 + v2 + v3 + (r3*i3);
    } else {
      // si 2 fuentes en 6-7 o 6-8 calculamos I3 como la suma de estas dos y resolvemos
      if (getCurrentSources().length == 2 && hasCurrentSource(FourMeshCircuitIdentifier.branch6) && hasCurrentSource(FourMeshCircuitIdentifier.branch7)) {
        // Vamos por 3 con I3=I6+I7
        double i3 =
            (branch6.currentSources.first.current * branch6.currentSources.first.sign) +
                (branch7.currentSources.first.current * branch7.currentSources.first.sign);
        double r3 = 0;
        for (var resistor in branch3.resistors) {
          r3 += resistor.resistance;
        }
        double v3 = 0;
        for (var voltSource in branch3.voltageSources) {
          v3 += voltSource.voltage * voltSource.sign;
        }
        theveninResistance = r1 + r2 + r3;
        theveninVoltage = v1 + v2 + v3 + (r3*i3);
      } else if (getCurrentSources().length == 2 && hasCurrentSource(FourMeshCircuitIdentifier.branch6) && hasCurrentSource(FourMeshCircuitIdentifier.branch8)) {
        // Vamos por 3 con I3=I6+I8
        double i3 =
            (branch6.currentSources.first.current * branch6.currentSources.first.sign) +
                (branch8.currentSources.first.current * branch8.currentSources.first.sign);
        double r3 = 0;
        for (var resistor in branch3.resistors) {
          r3 += resistor.resistance;
        }
        double v3 = 0;
        for (var voltSource in branch3.voltageSources) {
          v3 += voltSource.voltage * voltSource.sign;
        }
        theveninResistance = r1 + r2 + r3;
        theveninVoltage = v1 + v2 + v3 + (r3*i3);
      } else if (getCurrentSources().length == 3 && (hasCurrentSource(FourMeshCircuitIdentifier.branch7) || hasCurrentSource(FourMeshCircuitIdentifier.branch8))) {
        // si hay 3 fuentes y una esta en en 7 o 8, equivalente de 9 y 10 (2 mallas) + 3 mallas
        // Equivalente 9 y 10
        TwoMeshCircuit auxleft = TwoMeshCircuit();
        auxleft.branch1 = CircuitBranch(); // empty
        auxleft.branch2 = CircuitBranch(); // empty
        auxleft.branch3 = branch9;
        auxleft.branch4 = branch10;

        TheveninEquivalent auxleftEquiv = auxleft.calculateTheveninEquivalent();
        // Pegar al trozo restante
        ThreeMeshCircuit aux2 = ThreeMeshCircuit();
        aux2.branch1 = branch1;
        aux2.branch2 = branch2;
        aux2.branch3 = branch3;
        aux2.branch4 = branch4;
        aux2.branch5 = branch5;
        aux2.branch6 = branch6;
        aux2.branch7 = CircuitBranch();

        aux2.branch7.currentSources = [
          ...branch7.currentSources,
          ...branch8.currentSources
        ];
        aux2.branch7.voltageSources = [
          ...branch7.voltageSources,
          ...branch8.voltageSources,
          VoltageSource(Offset(0,0), auxleftEquiv.voltage.abs(), auxleftEquiv.voltage < 0 ? -1 : 1)
        ];
        aux2.branch7.resistors = [
          ...branch7.resistors,
          ...branch8.resistors,
          Resistor(Offset(0,0), auxleftEquiv.resistance)
        ];

        TheveninEquivalent finalEquiv = aux2.calculateTheveninEquivalent();
        theveninVoltage = finalEquiv.voltage;
        theveninResistance = finalEquiv.resistance;
      } else {
        // Caso normal, equiv de 3 mallas + 2 ramas con el
        // Cortar entre ramas 4 y 5
        ThreeMeshCircuit auxLeft = ThreeMeshCircuit();
        auxLeft.branch1 = CircuitBranch();
        auxLeft.branch2 = CircuitBranch();
        auxLeft.branch3 = branch6;
        auxLeft.branch4 = branch7;
        auxLeft.branch5 = branch8;
        auxLeft.branch6 = branch9;
        auxLeft.branch7 = branch10;

        TheveninEquivalent auxLeftEquiv = auxLeft.calculateTheveninEquivalent();

        // Pegar al cacho restante
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
          VoltageSource(Offset(0,0), auxLeftEquiv.voltage.abs(), auxLeftEquiv.voltage < 0 ? -1 : 1)
        ];
        aux2.branch4.resistors = [
          ...branch4.resistors,
          ...branch5.resistors,
          Resistor(Offset(0,0), auxLeftEquiv.resistance)
        ];

        TheveninEquivalent finalEquiv = aux2.calculateTheveninEquivalent();
        theveninVoltage = finalEquiv.voltage;
        theveninResistance = finalEquiv.resistance;
      }

    }
    return TheveninEquivalent(theveninVoltage, theveninResistance);
  }
}
