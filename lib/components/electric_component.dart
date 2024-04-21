import 'dart:ui';

import 'package:flutter/cupertino.dart';

abstract class ElectricComponent {
  Offset position;
  ElectricComponent(this.position);
  // TODO: maybe add here draw component with canvas? deal with futures

  bool isTapOnComponent(Offset tapPosition, double tolerance) {
    if ((tapPosition - position).distance < tolerance) {
      return true;
    }
    return false;
  }

  void showEditDialog(BuildContext context, Function updateCallback);


}
