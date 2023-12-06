import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';

class LayoutDesign extends StatefulWidget {
  final double zoom;
  const LayoutDesign({super.key, this.zoom = 100});

  @override
  LayoutDesignState createState() => LayoutDesignState();
}

class LayoutDesignState extends State<LayoutDesign> {
  GlobalKey _keyScrollY = GlobalKey();
  double _scrollY = 0;
  ui.ImageShader? _shaderGrid;

  @override
  void initState() {
    super.initState();
    initShaders();
  }

  Future<void> initShaders() async {
    const double size = 5.0;
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas imageCanvas = Canvas(recorder);
    final paint = Paint()..color = CDKTheme.white;
    imageCanvas.drawRect(const Rect.fromLTWH(0, 0, size, size), paint);
    imageCanvas.drawRect(const Rect.fromLTWH(size, size, size, size), paint);
    paint.color = CDKTheme.grey100;
    imageCanvas.drawRect(const Rect.fromLTWH(size, 0, size, size), paint);
    imageCanvas.drawRect(const Rect.fromLTWH(0, size, size, size), paint);
    int s = (size * 2).toInt();
    int mida = 4;
    List<List<double>> matIdent =
        List.generate(mida, (_) => List.filled(mida, 0.0));
    for (int i = 0; i < mida; i++) {
      matIdent[i][i] = 1.0;
    }
    List<double> vecIdent = [];
    for (int i = 0; i < mida; i++) {
      vecIdent.addAll(matIdent[i]);
    }
    ui.Image? gridImage = await recorder.endRecording().toImage(s, s);
    _shaderGrid = ui.ImageShader(
      gridImage,
      TileMode.repeated,
      TileMode.repeated,
      Float64List.fromList(vecIdent),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_shaderGrid == null) return Container();

    AppData appData = Provider.of<AppData>(context);
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          CustomPaint(
            painter: DesignPainter(
              appData: appData,
              theme: theme,
              zoom: widget.zoom,
              shaderGrid: _shaderGrid,
              centerX: 0,
              centerY: _scrollY,
            ),
            size: Size(constraints.maxWidth, constraints.maxHeight),
          ),
          UtilCustomVerticalScroll(
            key: _keyScrollY,
            size: constraints.maxHeight,
            onChanged: (value) {
              setState(() {
                _scrollY = value * 100;
              });
            },
          ),
        ],
      );
    });
  }
}

class DesignPainter extends CustomPainter {
  final AppData appData;
  final CDKTheme theme;
  final ui.Shader? shaderGrid;
  final double zoom;
  final double centerX;
  final double centerY;

  DesignPainter({
    required this.appData,
    required this.theme,
    this.shaderGrid,
    required this.zoom,
    this.centerX = 0,
    this.centerY = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Size docSize = appData.docSize;

    // Defineix els límits de dibuix del canvas
    canvas.save();
    Rect clipRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(clipRect);

    // Dibuixa el fons de l'àrea
    Paint paintBackground = Paint();
    paintBackground.color = theme.backgroundSecondary1;
    canvas.drawRect(clipRect, paintBackground);

    // Calcula l'escalat basat en el zoom
    double scale = zoom / 100;

    // Calcula la posició de translació per centrar el punt desitjat
    double translateX = size.width / 2 - centerX * scale;
    double translateY = size.height / 2 - centerY * scale;
    canvas.translate(translateX, translateY);

    // Aplica l'escalat
    canvas.scale(scale, scale);

    // Dibuixa la 'reixa de fons' del document
    double docX = -docSize.width / 2;
    double docY = -docSize.height / 2;
    double docW = docSize.width;
    double docH = docSize.height;

    Paint paint = Paint();
    paint.shader = shaderGrid;
    canvas.drawRect(Rect.fromLTWH(docX, docY, docW, docH), paint);

    // Restaura les configuracions del canvas
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DesignPainter oldDelegate) {
    return oldDelegate.appData != appData ||
        oldDelegate.zoom != zoom ||
        oldDelegate.shaderGrid != shaderGrid;
  }
}

class UtilCustomVerticalScroll extends StatefulWidget {
  double size = 0;
  final Function(double) onChanged;
  UtilCustomVerticalScroll(
      {super.key, required this.size, required this.onChanged});

  @override
  UtilCustomVerticalScrollState createState() =>
      UtilCustomVerticalScrollState();
}

class UtilCustomVerticalScrollState extends State<UtilCustomVerticalScroll> {
  double _topOffset = 0;

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      double newTopOffset = _topOffset + details.delta.dy;
      double halfSize = widget.size / 2;
      double halfBar = 100 / 2;

      newTopOffset =
          newTopOffset.clamp(-halfSize + halfBar, halfSize - halfBar);
      _topOffset = newTopOffset;

      // Calcula l'offset normalitzat de -1 a +1
      double offset = _topOffset / (halfSize - halfBar);
      widget.onChanged(offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: (widget.size / 2) + _topOffset - 50,
          right: 0,
          height: 100,
          width: 10,
          child: Container(
            padding: const EdgeInsets.all(2.5),
            child: GestureDetector(
                onVerticalDragUpdate: _onVerticalDragUpdate,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: CDKTheme.grey.withOpacity(0.5)),
                )),
          ),
        ),
      ],
    );
  }
}
