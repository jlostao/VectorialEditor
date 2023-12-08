import 'package:flutter/cupertino.dart';
import 'util_mutable_offset.dart';
import 'util_mutable_size.dart';

class Shape {
  MutableOffset position = MutableOffset(0, 0);
  MutableSize scale = MutableSize(1, 1);
  double rotation = 0;
  List<MutableOffset> points = [];

  Shape();

  void setPosition(Offset newPosition) {
    position.dx = newPosition.dx;
    position.dy = newPosition.dy;
  }

  void setScale(Size newScale) {
    scale.width = newScale.width;
    scale.height = newScale.height;
  }

  void setRotation(double newRotation) {
    rotation = newRotation;
  }

  void addPoint(Offset point) {
    points.add(MutableOffset(point.dx, point.dy));
  }
}
