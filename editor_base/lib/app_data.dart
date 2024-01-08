import 'package:flutter/material.dart';
import 'app_click_selector.dart';
import 'app_data_actions.dart';
import 'util_shape.dart';

class AppData with ChangeNotifier {
  // Access appData globaly with:
  // AppData appData = Provider.of<AppData>(context);
  // AppData appData = Provider.of<AppData>(context, listen: false)

  ActionManager actionManager = ActionManager();
  bool isAltOptionKeyPressed = false;
  double zoom = 95;
  Size docSize = const Size(500, 400);
  Color docColor = const Color.fromARGB(0, 255, 255, 255);
  String toolSelected = "shape_drawing";
  Shape newShape = Shape();
  Color strokeColor = Colors.black;
  List<Shape> shapesList = [];
  int shapeSelected = -1;
  int shapeSelectedPrevious = -1;

  bool readyExample = false;
  late dynamic dataExample;

  void forceNotifyListeners() {
    super.notifyListeners();
  }

  void setZoom(double value) {
    zoom = value.clamp(25, 500);
    notifyListeners();
  }

  void setZoomNormalized(double value) {
    if (value < 0 || value > 1) {
      throw Exception(
          "AppData setZoomNormalized: value must be between 0 and 1");
    }
    if (value < 0.5) {
      double min = 25;
      zoom = zoom = ((value * (100 - min)) / 0.5) + min;
    } else {
      double normalizedValue = (value - 0.51) / (1 - 0.51);
      zoom = normalizedValue * 400 + 100;
    }
    notifyListeners();
  }

  double getZoomNormalized() {
    if (zoom < 100) {
      double min = 25;
      double normalized = (((zoom - min) * 0.5) / (100 - min));
      return normalized;
    } else {
      double normalizedValue = (zoom - 100) / 400;
      return normalizedValue * (1 - 0.51) + 0.51;
    }
  }

  void setDocWidth(double value) {
    double previousWidth = docSize.width;
    actionManager.register(ActionSetDocWidth(this, previousWidth, value));
  }

  void setDocHeight(double value) {
    double previousHeight = docSize.height;
    actionManager.register(ActionSetDocHeight(this, previousHeight, value));
  }

  Color getDocColor() {
    return docColor;
  }

  void setDocColor(Color color) {
    docColor = color;
  }

  void changeDocColor(Color color) {
    Color previousColor = docColor;
    actionManager.register(ActionSetDocColor(this, previousColor, color));
  }

  void setToolSelected(String name) {
    toolSelected = name;
    notifyListeners();
  }

  void setShapeSelected(int index) {
    shapeSelected = index;
    notifyListeners();
  }

  void setStrokeColor(Color color) {
    strokeColor = color;
  }

  void changeStrokeColor(Color color) {
    Color previousColor = strokeColor;
    actionManager.register(ActionSetStrokeColor(this, previousColor, color));
  }

  Future<void> selectShapeAtPosition(Offset docPosition, Offset localPosition,
      BoxConstraints constraints, Offset center) async {
    shapeSelectedPrevious = shapeSelected;
    shapeSelected = -1;
    setShapeSelected(await AppClickSelector.selectShapeAtPosition(
        this, docPosition, localPosition, constraints, center));
  }

  void addNewShape(Offset position) {
    newShape.setPosition(position);
    newShape.addPoint(const Offset(0, 0));
    notifyListeners();
  }

  void addRelativePointToNewShape(Offset point) {
    newShape.addRelativePoint(point);
    notifyListeners();
  }

  void addNewShapeToShapesList() {
    // Si no hi ha almenys 2 punts, no es podrà dibuixar res
    if (newShape.vertices.length >= 2) {
      double strokeWidthConfig = newShape.strokeWidth;
      Color strokeColorConfig = strokeColor;
      actionManager.register(ActionAddNewShape(this, newShape));
      newShape = Shape();
      newShape.setStrokeWidth(strokeWidthConfig);
      newShape.setStrokeColor(strokeColorConfig);
    }
  }

  void setNewShapeStrokeWidth(double value) {
    newShape.setStrokeWidth(value);
    notifyListeners();
  }

  void setNewShapeStrokeColor(Color color) {
    setStrokeColor(color);
    newShape.setStrokeColor(color);
    notifyListeners();
  }
}
