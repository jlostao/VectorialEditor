import 'package:flutter/cupertino.dart';
import 'util_scroll2d.dart';

class LayoutDesign extends StatefulWidget {
  const LayoutDesign({super.key});

  @override
  LayoutDesignState createState() => LayoutDesignState();
}

class LayoutDesignState extends State<LayoutDesign> {
  //bool _hasSizes = false;
  List<Offset> positions = [
      const Offset(0, 0),
      const Offset(100, 100),
      const Offset(200, 200),
      const Offset(500, 500),
      const Offset(600, 600),
      const Offset(800, 800),
      const Offset(400, 900),
  ];

  List<Widget> widgets = [
      Text(key: GlobalKey(), 'Widget 0 hola què tal'),
      Text(key: GlobalKey(), 'Widget 1'),
      Text(key: GlobalKey(), 'Widget 2'),
      Text(key: GlobalKey(), 'Widget 2b 500'),
      Text(key: GlobalKey(), 'Widget 2c'),
      Text(key: GlobalKey(), 'Widget 3'),
      Text(key: GlobalKey(), 'Widget 3b'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UtilScroll2d(
      positions: positions,
      children: widgets,
    );
  }
}
