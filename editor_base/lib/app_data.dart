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

  void setDocWidth (double value) {
    docSize.width = value;
    notifyListeners();
  }

  void setDocHeight (double value) {
    docSize.height = value;
    notifyListeners();
  }
}
