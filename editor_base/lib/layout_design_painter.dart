import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'app_data.dart';

class LayoutDesignPainter extends CustomPainter {
  final AppData appData;
  final CDKTheme theme;
  final ui.Shader? shaderGrid;
  final double zoom;
  final double centerX;
  final double centerY;

  LayoutDesignPainter({
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
  bool shouldRepaint(covariant LayoutDesignPainter oldDelegate) {
    return oldDelegate.appData != appData ||
        oldDelegate.zoom != zoom ||
        oldDelegate.shaderGrid != shaderGrid;
  }
}