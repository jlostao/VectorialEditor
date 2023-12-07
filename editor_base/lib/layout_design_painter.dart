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

  void drawRules(Canvas canvas, Size size, Size docSize, double scale, double translateX, double translateY) {
    Rect rectRullerTop = Rect.fromLTWH(0, 0, size.width, 20);
    Paint paintRulerTop = Paint();
    paintRulerTop.color = theme.backgroundSecondary1;
    canvas.drawRect(rectRullerTop, paintRulerTop);

    double xLeft = (0 + translateX) * scale;
    double xRight = ((docSize.width + translateX) * scale) - 1;

    double unitSize = 5 * scale;
    int cnt = 0;
    for (double i = xLeft; i < xRight; i += unitSize) {
      if (i > 20 && i < size.width) {
        Paint paintLine = Paint()..color = CDKTheme.black;
        double adjustedPosition = i;
        double top = 15;
        if ((cnt % 100) == 0) {
          top = 0;

          TextSpan span = TextSpan(
            style: const TextStyle(color: CDKTheme.black, fontSize: 10),
            text: '$cnt', 
          );

          TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );
          tp.layout();
          tp.paint(canvas, Offset(adjustedPosition + 2.4, 0));

        } else if ((cnt % 10) == 0) {
          top = 10;
        }
        canvas.drawLine(
          Offset(adjustedPosition, top),
          Offset(adjustedPosition, 20),
          paintLine,
        );
      }
      cnt = cnt + 5;
    }

    Rect rectRullerLeft = Rect.fromLTWH(0, 0, 20, size.height);
    Paint paintRulerLeft = Paint();
    paintRulerLeft.color = theme.backgroundSecondary1;
    canvas.drawRect(rectRullerLeft, paintRulerLeft);

    double yTop = (0 + translateY) * scale;
    double yBottom = ((docSize.height + translateY) * scale) - 1;

    cnt = 0;
    for (double i = yTop; i < yBottom; i += unitSize) {
      if (i > 20 && i < size.width) {
        Paint paintLine = Paint()..color = CDKTheme.black;
        double adjustedPosition = i;
        double left = 15;
        if ((cnt % 100) == 0) {
          left = 0;

          TextSpan span = TextSpan(
            style: const TextStyle(color: CDKTheme.black, fontSize: 10),
            text: '$cnt', 
          );

          TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );
          tp.layout();
          tp.paint(canvas, Offset(0, adjustedPosition + 2.4));

        } else if ((cnt % 10) == 0) {
          left = 10;
        }
        canvas.drawLine(
          Offset(left, adjustedPosition),
          Offset(20, adjustedPosition),
          paintLine,
        );
      }
      cnt = cnt + 5;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Size docSize = Size(appData.docSize.width, appData.docSize.height);

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

    // Dibuixa la regla superior
    drawRules(canvas, size, docSize, scale, translateX, translateY);
  }

  @override
  bool shouldRepaint(covariant LayoutDesignPainter oldDelegate) {
    return oldDelegate.appData != appData ||
        oldDelegate.zoom != zoom ||
        oldDelegate.shaderGrid != shaderGrid;
  }
}