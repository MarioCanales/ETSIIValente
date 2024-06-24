import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'Circuit.dart';

class CircuitStoreWrapper {
  String name;
  Circuit circuit;

  CircuitStoreWrapper({required this.name, required this.circuit});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'circuit': circuit.toJson() // Serialize the circuit
    };
  }

  static CircuitStoreWrapper fromJson(Map<String, dynamic> json) {
    return CircuitStoreWrapper(
        name: json['name'],
        circuit: Circuit.fromJson(json['circuit'])
    );
  }
}

class CircuitManager {
  // Singleton instance: factory
  static final CircuitManager _instance = CircuitManager._internal();
  factory CircuitManager() => _instance;
  CircuitManager._internal();

  // Save the list of circuits to SharedPreferences
  Future<void> saveCircuits(List<CircuitStoreWrapper> circuits) async {
    final prefs = await SharedPreferences.getInstance();
    String serializedCircuits = jsonEncode(circuits.map((wrapper) => wrapper.toJson()).toList());
    await prefs.setString('saved_circuits', serializedCircuits);
  }

  // Load the list of circuits from SharedPreferences
  Future<List<CircuitStoreWrapper>> loadCircuits() async {
    final prefs = await SharedPreferences.getInstance();
    String? serializedCircuits = prefs.getString('saved_circuits');
    if (serializedCircuits != null) {
      List<dynamic> decodedCircuits = jsonDecode(serializedCircuits);
      return decodedCircuits.map((wrapperJson) => CircuitStoreWrapper.fromJson(wrapperJson)).toList();
    }
    return [];
  }

  Future<void> addCircuit(CircuitStoreWrapper circuitWrapper) async {
    List<CircuitStoreWrapper> circuits = await loadCircuits();
    circuits.add(circuitWrapper);
    await saveCircuits(circuits);
  }

  Future<void> deleteCircuit(String circuitName) async {
    List<CircuitStoreWrapper> circuits = await loadCircuits();
    // Only delete the first one, although there should be only 1 with the name
    int index = circuits.indexWhere((wrapper) => wrapper.name == circuitName);
    if (index != -1) {
      circuits.removeAt(index);
    }
    await saveCircuits(circuits);
  }

}