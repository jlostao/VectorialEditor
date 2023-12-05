import 'package:flutter/cupertino.dart';
import 'util_scroll2d.dart';

class LayoutDesign extends StatefulWidget {
  const LayoutDesign({super.key});

  @override
  LayoutDesignState createState() => LayoutDesignState();
}

class LayoutDesignState extends State<LayoutDesign> {
  bool _hasSizes = false;
List<List<dynamic>> list = [
      [
        const Offset(0, 0),
        const Size(0,0),
        Text(key: GlobalKey(), 'Widget 0 hola què tal'),
      ],
      [
        const Offset(100, 100),
        const Size(0,0),
        Text(key: GlobalKey(), 'Widget 1'),
      ],
      [
        const Offset(200, 200),
        const Size(0,0),
        Text(key: GlobalKey(), 'Widget 2'),
      ],
      [
        const Offset(500, 500),
        const Size(0,0),
        Text(key: GlobalKey(), 'Widget 2b'),
      ],
      [
        const Offset(600, 600),
        const Size(0,0),
        Text(key: GlobalKey(), 'Widget 2c'),
      ],
      [
        const Offset(800, 800),
        const Size(0,0),
        Text(key: GlobalKey(), 'Widget 3'),
      ],
      [
        const Offset(900, 900),
        const Size(0,0),
        Text(key: GlobalKey(), 'Widget 3b'),
      ],
    ];

  @override
  void initState() {
    super.initState();
  }

  void _calculateSizes() {
    for (var item in list) {
      var key = item[2].key;
      final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      final size = renderBox.size;
      item[1] = size;
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
              child: item[2],
            );
          }).toList()

      ));
    }

    return UtilScroll2d(
      list: list,
    );
  }
}
