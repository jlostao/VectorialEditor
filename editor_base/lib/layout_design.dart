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
  ui.ImageShader? _shaderGrid;
  double _scrollX = 0;
  double _scrollY = 0;

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
      return CustomPaint(
        painter: DesignPainter(
          appData: appData,
          theme: theme,
          zoom: widget.zoom,
          shaderGrid: _shaderGrid,
          scrollX: _scrollX,
          scrollY: _scrollY,
        ),
        size: Size(constraints.maxWidth, constraints.maxHeight),
      );
    });
  }
}

class DesignPainter extends CustomPainter {
  final AppData appData;
  final CDKTheme theme;
  final double zoom;
  final ui.Shader? shaderGrid;
  final double scrollX;
  final double scrollY;

  DesignPainter({
    required this.appData,
    required this.theme,
    required this.zoom,
    this.shaderGrid,
    this.scrollX = 0,
    this.scrollY = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Size docSize = appData.docSize;

    // Set canvas drawing limits
    canvas.save();
    Rect clipRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(clipRect);

    // Scale everything from now on based on zoom
    double scale = zoom / 100;
    canvas.scale(scale, scale);

    // Draw document 'barckground grid'
    double docX = 0;
    double docY = 0;
    double docW = docSize.width;
    double docH = docSize.height;

    if (docW > size.width / scale) {
      docX -= scrollX;
    } else {
      docX = (size.width / scale - docW) / 2;
    }
    if (docH > size.height / scale) {
      docY -= scrollY;
    } else {
      docY = (size.height / scale - docH) / 2;
    }

    Paint paint = Paint();
    paint.shader = shaderGrid;
    canvas.drawRect(Rect.fromLTWH(docX, docY, docW, docH), paint);

    // Restore canvas settings
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DesignPainter oldDelegate) {
    return oldDelegate.appData != appData ||
        oldDelegate.zoom != zoom ||
        oldDelegate.shaderGrid != shaderGrid;
  }
}
