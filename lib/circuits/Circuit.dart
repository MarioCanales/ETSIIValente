import 'dart:convert';

import 'package:ETSIIValente/circuits/ThreeMeshCircuit.dart';

import '../circuitComponents/TheveninEquivalent.dart';
import 'FourMeshCircuit.dart';
import 'TwoMeshCircuit.dart';

abstract class Circuit {
  // TODO add more common signatures
  TheveninEquivalent calculateTheveninEquivalent();

  // Method to serialize the circuit to a JSON string.
  String toJson();
  // Method to deserialize
  static Circuit fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    String type = map['type'];
    switch (type) {
      case 'TwoMeshCircuit':
        return TwoMeshCircuit.fromJson(json);
      case 'ThreeMeshCircuit':
        return ThreeMeshCircuit.fromJson(json);
      case 'FourMeshCircuit':
        return FourMeshCircuit.fromJson(json);
      default:
        throw ArgumentError('Invalid circuit type');
    }
  }
}
