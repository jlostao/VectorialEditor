import 'package:flutter/material.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'util_button_icon.dart';

class LayoutSidebarTools extends StatelessWidget {
  const LayoutSidebarTools({super.key});

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    Color colorSelected = theme.colorText;
    Color colorUnselected = theme.isLight
        ? const Color.fromARGB(255, 15, 15, 15)
        : const Color.fromARGB(255, 250, 0, 0);

    return Column(children: [
      Container(
        padding: const EdgeInsets.only(top: 2, left: 2),
        child: UtilButtonIcon(
          size: 24,
          isSelected: appData.toolSelected == "pointer_shapes",
          onPressed: () {
            appData.setToolSelected("pointer_shapes");
          },
          child: Opacity(
            opacity: appData.toolSelected == "pointer_shapes" ? 1.0 : 0.5,
            child: Image.asset('assets/images/pointer_shapes.png',
                color: appData.toolSelected == "pointer_shapes"
                    ? colorSelected
                    : colorUnselected,
                width: 18,
                height: 18),
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(top: 2, left: 2),
        child: UtilButtonIcon(
          size: 24,
          isSelected: appData.toolSelected == "shape_drawing",
          onPressed: () {
            appData.setToolSelected("shape_drawing");
          },
          child: Opacity(
            opacity: appData.toolSelected == "shape_drawing" ? 1.0 : 0.5,
            child: Image.asset('assets/images/shape_drawing.png',
                color: appData.toolSelected == "shape_drawing"
                    ? colorSelected
                    : colorUnselected,
                width: 18,
                height: 18),
          ),
        ),
      ),
    ]);
  }
}
