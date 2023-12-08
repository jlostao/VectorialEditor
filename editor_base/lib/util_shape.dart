import 'util_mutable_offset.dart';
import 'util_mutable_size.dart';

class Shape {
  MutableOffset position = MutableOffset(0, 0);
  MutableSize scale = MutableSize(1, 1);
  double rotation = 0;
  List<MutableOffset> points = [];

  Shape();

  void setPosition(double x, double y) {
    position.dx = x;
    position.dy = y;
  }

  void setScale(double width, double height) {
    scale.width = width;
    scale.height = height;
  }

  void setRotation(double newRotation) {
    rotation = newRotation;
  }

  void addPoint(double x, double y) {
    points.add(MutableOffset(x, y));
  }
}
