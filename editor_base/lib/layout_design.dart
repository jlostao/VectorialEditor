import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'util_scroll2d.dart';

class LayoutDesign extends StatefulWidget {
  const LayoutDesign({super.key});

  @override
  LayoutDesignState createState() => LayoutDesignState();
}

class LayoutDesignState extends State<LayoutDesign> {
  @override
  Widget build(BuildContext context) {
    Map<Offset, Widget> list = {
      const Offset(0, 0): const Text('Widget 0 hola què tal'),
      const Offset(100, 100): const Text('Widget 1'),
      const Offset(200, 200): const Text('Widget 2'),
      const Offset(500, 500): const Text('Widget 2b'),
      const Offset(600, 600): const Text('Widget 2c'),
      const Offset(800, 800): const Text('Widget 3'),
      const Offset(900, 900): const Text('Widget 3b'),
      // Afegir més widgets segons sigui necessari
    };

    return UtilScroll2d(
      widgetsList: list,
    );
  }
}

class RulePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = CupertinoColors.black;

    // Dibuixar les regles aquí
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class YourDesignWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Construeix el teu widget de disseny aquí
    return Center(child: Text('El teu Disseny'));
  }
}
