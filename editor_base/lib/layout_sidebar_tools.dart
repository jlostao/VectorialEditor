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
        : const Color.fromARGB(255, 250, 250, 250);

    return Column(children: [
      Container(
        padding: const EdgeInsets.only(top: 2, left: 2),
        child: UtilButtonIcon(
          size: 24,
          isSelected: appData.toolSelected == "pointer",
          onPressed: () {
            appData.setToolSelected("pointer");
          },
          child: Opacity(
            opacity: appData.toolSelected == "pointer" ? 1.0 : 0.5,
            child: Image.asset('assets/images/arrow_pointer.png',
                color: appData.toolSelected == "pointer"
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
          isSelected: appData.toolSelected == "pencil",
          onPressed: () {
            appData.setToolSelected("pencil");
          },
          child: Opacity(
            opacity: appData.toolSelected == "pencil" ? 1.0 : 0.5,
            child: Icon(Icons.edit,
                color: appData.toolSelected == "pencil"
                    ? colorSelected
                    : colorUnselected,
                size: 18),
          ),
        ),
      ),
    ]);
  }
}
