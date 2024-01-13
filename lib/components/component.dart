import 'package:flutter/material.dart';

abstract class Component {
  Offset position;

  Component({this.position = Offset.zero}); //Default
}
