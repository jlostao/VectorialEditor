import 'package:flutter/cupertino.dart';


class LayoutDesign extends StatefulWidget {
  @override
  _LayoutDesignState createState() => _LayoutDesignState();
}

class _LayoutDesignState extends State<LayoutDesign> {
  double _zoom = 1.0;

  void _incrementZoom() {
    setState(() {
      _zoom += 0.1;
    });
  }

  void _decrementZoom() {
    if (_zoom > 0.1) {
      setState(() {
        _zoom -= 0.1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          CustomPaint(
            painter: RulePainter(),
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
          ),
          TwoDimensionalScrollViewX()


        ],
     
    );
  }
}

class TwoDimensionalScrollViewX extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: SizedBox(
            height: 2000, // Alçada de la primera secció
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: SizedBox(
                    width: 2000, // Amplada de la segona secció
                    height: 2000,
                    child: Text("hola"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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