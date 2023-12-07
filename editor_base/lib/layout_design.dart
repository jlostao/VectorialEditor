import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'layout_design_painter.dart';
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
    return Size(((appData.docSize.width * appData.zoom) / 100),
        ((appData.docSize.height * appData.zoom) / 100));
  }

  Offset _getDisplacement(Size scrollArea, BoxConstraints constraints) {
    return Offset(((scrollArea.width - constraints.maxWidth) / 2) + 25,
        ((scrollArea.height - constraints.maxHeight) / 2) + 25);
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
                          appData.setZoom(appData.zoom + pointerSignal.scrollDelta.dy);
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
                    painter: LayoutDesignPainter(
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
