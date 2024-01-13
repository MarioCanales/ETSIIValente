import 'package:flutter/material.dart';

class Resistor {
  double value = 1; // default value 1K
}

class DraggableResistor extends StatelessWidget {
  const DraggableResistor({super.key}); // key added for IDE recommendation.
                                        // use is optional.

  @override
  Widget build(BuildContext context) {
    return Draggable<Resistor>(
      data: Resistor()
        ..value = 3, //Default to 3K ohms
      feedback: const Material(
        type: MaterialType.transparency,
        child: ResistorWidget()
      ), // the thing that will remain there (the same from now)
      childWhenDragging: const Opacity(opacity: 0.5, child: ResistorWidget()),
      child: const ResistorWidget(), // Shadow it
    );
  }
}

class ResistorWidget extends StatelessWidget {
  const ResistorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Customize this widget to look like a resistor
    return Container(
      width: 50,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: Text('R', style: TextStyle(color: Colors.white))),
    );
  }
}
