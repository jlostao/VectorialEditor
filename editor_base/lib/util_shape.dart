class Shape {
  MutableOffset position;
  MutableSize scale;
  double rotation;
  List<MutableOffset> points;

  MutableSize(this.position = MutableOffset(0, 0), this.scale = MutableSize(1, 1), this.rotation = 0, this.points = []);

  void setPosition(double x, double y) {
    position.dx = x;
    position.dy = y;
  }

  void setScale(double width, double y) {
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