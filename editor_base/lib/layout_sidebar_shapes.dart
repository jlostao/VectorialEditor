import 'package:editor_base/custom_shape_painter.dart';
import 'package:editor_base/util_shape.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/cdk_theme.dart';
import 'package:flutter_cupertino_desktop_kit/cdk_theme_notifier.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'layout_design_painter.dart';

class LayoutSidebarShapes extends StatelessWidget {
  const LayoutSidebarShapes({Key? key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'List of shapes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ShapeListWidget(),
          ],
        ),
      ),
    );
  }
}

class ShapeListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    List<Shape> shapesList = appData.shapesList;
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    return CupertinoScrollbar(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: shapesList.length,
        itemBuilder: (context, index) {
          final isSelected = appData.shapeSelected == index;

          // Obtener la forma actual
          Shape currentShape = shapesList[index];

          // Crear una instancia de CustomShapePainter con el tamaño más pequeño
          CustomShapePainter shapePainter = CustomShapePainter(
            shape: currentShape,
            theme: theme,
            centerX: 0,
            centerY: 0,
          );

          // Definir un tamaño pequeño para el CustomPaint
          Size shapeSize = Size(20, 20);

          return CupertinoButton(
            onPressed: () {
              if (isSelected) {
                appData.setShapeSelected(-1);
              } else {
                appData.setShapeSelected(index);
              }
            },
            padding: EdgeInsets.zero,
            child: Container(
              color: isSelected ? CupertinoColors.activeBlue : null,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Mostrar el nombre de la forma
                      Text(
                        'Shape ${index + 1}',
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? CupertinoColors.white : null,
                        ),
                      ),
                      SizedBox(width: 8), // Espacio entre el texto y la forma
                      // Utilizar el tamaño pequeño de la forma en CustomPaint
                      CustomPaint(
                        painter: shapePainter,
                        size: shapeSize,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
