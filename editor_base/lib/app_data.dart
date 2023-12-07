import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  // Access appData globaly with:
  // AppData appData = Provider.of<AppData>(context);
  // AppData appData = Provider.of<AppData>(context, listen: false)

  double zoom = 100;
  Size docSize = const Size(500, 1000);

  bool readyExample = false;
  late dynamic dataExample;

  void setZoom (value) {
    zoom = value;
    notifyListeners();
  }
}
