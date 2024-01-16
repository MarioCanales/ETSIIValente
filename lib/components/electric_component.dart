import 'package:flutter/material.dart';

abstract class ElectricComponent {
  double position; // A cordinate will be fixed (e.g. in horizontal lines we
                   // Already have the x and we just need the y
  ElectricComponent({this.position = 0}); //Default

  void updatePosition(double newPosition) {
    position = newPosition;
  }
}
