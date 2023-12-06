import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'util_scroll2d.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  MyWidgetState createState() => MyWidgetState();
}

class MyWidgetState extends State<MyWidget> {
  double boxWidth = 100;
  double boxHeight = 50;

  void updateWidth(double newWidth) {
    setState(() {
      boxWidth = newWidth;
    });
  }

  void updateHeight(double newHeight) {
    setState(() {
      boxHeight = newHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: Container(color: CDKTheme.green));
  }
}

class LayoutDesign extends StatefulWidget {
  final double zoom;
  const LayoutDesign({super.key, this.zoom = 100});

  @override
  LayoutDesignState createState() => LayoutDesignState();
}

class LayoutDesignState extends State<LayoutDesign> {
  final GlobalKey<MyWidgetState> _keyCanvas = GlobalKey();
  final GlobalKey _keyLimit = GlobalKey();
  List<Offset> _positions = [];
  List<Widget> _widgets = [];

  @override
  void initState() {
    super.initState();
    _widgets = [
      MyWidget(key: _keyCanvas),
      Container(key: _keyLimit, width: 10, height: 10, color: CDKTheme.red)
    ];
  }

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;
    return LayoutBuilder(builder: (context, constraints) {
      double canvasWidth = 500 * widget.zoom / 100;
      double canvasHeight = 800 * widget.zoom / 100;

      double padding = 50;
      double x = padding;
      double y = padding;
      double width = canvasWidth;
      double height = canvasHeight;

      _keyCanvas.currentState?.updateWidth(width);
      _keyCanvas.currentState?.updateHeight(height);

      double limitX = width + padding * 2;
      double limitY = height + padding * 2;

      _positions = [
        Offset(x, y),
        Offset(limitX, limitY),
      ];

      return Container(
          color: theme.background,
          child: UtilScroll2d(
            positions: _positions,
            children: _widgets,
          ));
    });
  }
}
