import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'util_custom_scroll_vertical.dart';
import 'util_custom_scroll_horizontal.dart';
import 'util_mutable_offset.dart';

class LayoutDesign extends StatefulWidget {
  const LayoutDesign({super.key});

  @override
  LayoutDesignState createState() => LayoutDesignState();
}

class LayoutDesignState extends State<LayoutDesign> {
  final GlobalKey<UtilCustomScrollHorizontalState> _keyScrollX = GlobalKey();
  final GlobalKey<UtilCustomScrollVerticalState> _keyScrollY = GlobalKey();
  bool _shadersReady = false;
  ui.ImageShader? _shaderGrid;
  bool _isMouseButtonPressed = false;
  bool _isAltOptionKeyPressed = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initShaders();
  }

  Future<void> initShaders() async {
    const double size = 10.0;
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas imageCanvas = Canvas(recorder);
    final paint = Paint()..color = CDKTheme.white;
    imageCanvas.drawRect(const Rect.fromLTWH(0, 0, size, size), paint);
    imageCanvas.drawRect(const Rect.fromLTWH(size, size, size, size), paint);
    paint.color = CDKTheme.grey100;
    imageCanvas.drawRect(const Rect.fromLTWH(size, 0, size, size), paint);
    imageCanvas.drawRect(const Rect.fromLTWH(0, size, size, size), paint);
    int s = (size * 2).toInt();
    int matSize = 4;
    List<List<double>> matIdent =
        List.generate(matSize, (_) => List.filled(matSize, 0.0));
    for (int i = 0; i < matSize; i++) {
      matIdent[i][i] = 1.0;
    }
    List<double> vecIdent = [];
    for (int i = 0; i < matSize; i++) {
      vecIdent.addAll(matIdent[i]);
    }
    ui.Image? gridImage = await recorder.endRecording().toImage(s, s);
    _shaderGrid = ui.ImageShader(
      gridImage,
      TileMode.repeated,
      TileMode.repeated,
      Float64List.fromList(vecIdent),
    );
    _shadersReady = true;
    setState(() {});
  }

  Size _getScrollArea(AppData appData) {
    Size docSize = appData.docSize;
    return Size(((docSize.width * appData.zoom) / 100),
        ((docSize.height * appData.zoom) / 100));
  }

  Offset _getDisplacement(Size scrollArea, BoxConstraints constraints) {
    return Offset((scrollArea.width - constraints.maxWidth) / 2,
        (scrollArea.height - constraints.maxHeight) / 2);
  }

  @override
  Widget build(BuildContext context) {
    if (!_shadersReady) return Container();

    return LayoutBuilder(builder: (context, constraints) {
      AppData appData = Provider.of<AppData>(context);
      CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

      Size scrollArea = _getScrollArea(appData);
      Offset scrollDisplacement = _getDisplacement(scrollArea, constraints);
      MutableOffset scrollCenter = MutableOffset(0, 0);

      if (_keyScrollX.currentState != null) {
        if (scrollArea.width < constraints.maxWidth) {
          _keyScrollX.currentState!.setOffset(0);
        } else {
          scrollCenter.dx = _keyScrollX.currentState!.getOffset() *
              (scrollDisplacement.dx * 100 / appData.zoom);
        }
      }

      if (_keyScrollY.currentState != null) {
        if (scrollArea.height < constraints.maxHeight) {
          _keyScrollY.currentState!.setOffset(0);
        } else {
          scrollCenter.dy = _keyScrollY.currentState!.getOffset() *
              (scrollDisplacement.dy * 100 / appData.zoom);
        }
      }

      return Stack(
        children: [
          RawKeyboardListener(
            focusNode: _focusNode,
            onKey: (event) {
              if (event is RawKeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.altLeft) {
                  _isAltOptionKeyPressed = true;
                }
              } else if (event is RawKeyUpEvent) {
                if (event.logicalKey == LogicalKeyboardKey.altLeft) {
                  _isAltOptionKeyPressed = false;
                }
              }
            },
            child: GestureDetector(
              onPanEnd: (details) {
                _keyScrollX.currentState!.startInertiaAnimation();
                _keyScrollY.currentState!.startInertiaAnimation();
              },
              onPanUpdate: (DragUpdateDetails details) {
                if (!_isMouseButtonPressed) {
                  if (_isAltOptionKeyPressed) {
                    appData.setZoom(appData.zoom + details.delta.dy);
                  } else {
                    if (details.delta.dy != 0) {
                        _keyScrollY.currentState!
                          .setTrackpadDelta(details.delta.dy);
                    }
                    if (details.delta.dx != 0) {
                        _keyScrollX.currentState!
                          .setTrackpadDelta(details.delta.dx);
                    }
                  }
                }
              },
              child: Listener(
                  onPointerDown: (event) {
                    _focusNode.requestFocus();
                    _isMouseButtonPressed = true;
                  },
                  onPointerUp: (event) {
                    _isMouseButtonPressed = false;
                  },
                  onPointerSignal: (pointerSignal) {
                    if (pointerSignal is PointerScrollEvent) {
                      if (!_isMouseButtonPressed) {
                        if (_isAltOptionKeyPressed) {

                        } else {
                          _keyScrollX.currentState!
                              .setWheelDelta(pointerSignal.scrollDelta.dx);
                          _keyScrollY.currentState!
                              .setWheelDelta(pointerSignal.scrollDelta.dy);
                        }
                      }
                    }
                  },
                  child: CustomPaint(
                    painter: DesignPainter(
                      appData: appData,
                      theme: theme,
                      zoom: appData.zoom,
                      shaderGrid: _shaderGrid,
                      centerX: scrollCenter.dx,
                      centerY: scrollCenter.dy,
                    ),
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                )))),
          UtilCustomScrollHorizontal(
            key: _keyScrollX,
            size: constraints.maxWidth,
            contentSize: scrollArea.width,
            onChanged: (value) {
              setState(() {});
            },
          ),
          UtilCustomScrollVertical(
            key: _keyScrollY,
            size: constraints.maxHeight,
            contentSize: scrollArea.height,
            onChanged: (value) {
              setState(() {});
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
    Rect visibleRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(visibleRect);

    // Dibuixa el fons de l'àrea
    Paint paintBackground = Paint();
    paintBackground.color = theme.backgroundSecondary1;
    canvas.drawRect(visibleRect, paintBackground);

    // Calcula l'escalat basat en el zoom
    double scale = zoom / 100;

    Size scaledSize = Size(size.width / scale, size.height / scale);

    // Aplica l'escalat
    canvas.scale(scale, scale);

    // Calcula la posició de translació per centrar el punt desitjat
    double translateX = (scaledSize.width / 2) - (docSize.width / 2) - centerX;
    double translateY =
        (scaledSize.height / 2) - (docSize.height / 2) - centerY;
    canvas.translate(translateX, translateY);

    // Dibuixa la 'reixa de fons' del document
    double docW = docSize.width;
    double docH = docSize.height;

    Paint paint = Paint();
    paint.shader = shaderGrid;
    canvas.drawRect(Rect.fromLTWH(0, 0, docW, docH), paint);

    // Dibuixa una diagonal vermella a tot el document
    Paint paintLine0 = Paint();
    paintLine0.color = CDKTheme.red;
    canvas.drawLine(
        const Offset(0, 1), Offset(docW, 1), paintLine0..strokeWidth = 1);

    Paint paintLine1 = Paint();
    paintLine1.color = CDKTheme.blue;
    canvas.drawLine(
        const Offset(0, 1), Offset(docW, docH), paintLine1..strokeWidth = 1);

    Paint paintLine2 = Paint();
    paintLine2.color = CDKTheme.green;
    canvas.drawLine(Offset(0, docH - 1), Offset(docW, docH - 1),
        paintLine2..strokeWidth = 1);

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
