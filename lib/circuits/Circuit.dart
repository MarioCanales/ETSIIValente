import 'dart:convert';

import 'package:ETSIIValente/circuits/ThreeMeshCircuit.dart';

import '../circuitComponents/TheveninEquivalent.dart';
import 'FourMeshCircuit.dart';
import 'TwoMeshCircuit.dart';

abstract class Circuit {
  TheveninEquivalent calculateTheveninEquivalent();

  // Method to serialize the circuit to a JSON string. To be defined in
  // Each class
  String toJson();

  // Method to deserialize, map to each class static
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
