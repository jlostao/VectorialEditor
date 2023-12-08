import 'package:flutter/material.dart';
import 'util_mutable_size.dart';

class AppData with ChangeNotifier {
  // Access appData globaly with:
  // AppData appData = Provider.of<AppData>(context);
  // AppData appData = Provider.of<AppData>(context, listen: false)

  double zoom = 100;
  MutableSize docSize = MutableSize(500, 400);

  bool readyExample = false;
  late dynamic dataExample;

  void setZoom (double value) {
    zoom = value.clamp(50, 500);
    notifyListeners();
  }

  void setZoomNormalized (double value) {
    if (value < 0 || value > 1) {
      throw Exception(
          "AppData setZoomNormalized: value must be between 0 and 1");
    }
    if (value < 0.5) {
      zoom = value * 100 + 50;
    } else {
      double normalizedValue = (value - 0.51) / (1 - 0.51);
      zoom = normalizedValue * 400 + 100;
    } 
    notifyListeners();
  }

  void setDocWidth (double value) {
    docSize.width = value;
    notifyListeners();
  }

  void setDocHeight (double value) {
    docSize.height = value;
    notifyListeners();
  }
}
