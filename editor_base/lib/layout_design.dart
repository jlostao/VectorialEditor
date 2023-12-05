import 'package:flutter/cupertino.dart';
import 'util_scroll2d.dart';

class LayoutDesign extends StatefulWidget {
  const LayoutDesign({super.key});

  @override
  LayoutDesignState createState() => LayoutDesignState();
}

class LayoutDesignState extends State<LayoutDesign> {
  bool _hasSizes = false;
List<Map> list = [
      {
        "position": const Offset(0, 0),
        "size": const Size(0,0),
        "widget": Text(key: GlobalKey(), 'Widget 0 hola què tal'),
      },
      {
        "position": const Offset(100, 100),
        "size": const Size(0,0),
        "widget": Text(key: GlobalKey(), 'Widget 1'),
      },
      {
        "position": const Offset(200, 200),
        "size": const Size(0,0),
        "widget": Text(key: GlobalKey(), 'Widget 2'),
      },
      {
        "position": const Offset(500, 500),
        "size": const Size(0,0),
        "widget": Text(key: GlobalKey(), 'Widget 2b 500'),
      },
      {
        "position": const Offset(600, 600),
        "size": const Size(0,0),
        "widget": Text(key: GlobalKey(), 'Widget 2c'),
      },
      {
        "position": const Offset(800, 800),
        "size": const Size(0,0),
        "widget": Text(key: GlobalKey(), 'Widget 3'),
      },
      {
        "position": const Offset(900, 900),
        "size": const Size(0,0),
        "widget": Text(key: GlobalKey(), 'Widget 3b'),
      },
    ];

  @override
  void initState() {
    super.initState();
  }

  void _calculateSizes() {
    for (var item in list) {
      var key = item["widget"].key;
      final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      final size = renderBox.size;
      item["size"] = size;
    }
    _hasSizes = true;
  }

  @override
  Widget build(BuildContext context) {

    if (!_hasSizes) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _calculateSizes());
      return Offstage(child: Stack(children: 
            list.map((item) {
            return Positioned(
              left: 0,
              top: 0,
              child: item["widget"],
            );
          }).toList()

      ));
    }

    return UtilScroll2d(
      list: list,
    );
  }
}
