import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'util_tool_icon.dart';

class LayoutSidebarTools extends StatelessWidget {
  const LayoutSidebarTools({super.key});

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    List<String> tools = [ "wand", "pencil" ];

    List<Widget> toolWidgets = tools.map((tool) {
      IconData iconData;
      switch (tool) {
        case "wand":
          iconData = CupertinoIcons.wand_rays;
          break;
        case "pencil":
          iconData = Icons.create;
          break;
        default:
          iconData = CupertinoIcons.question_circle; // Un icona genèric per a eines no reconegudes
      }

      Color colorText = theme.colorText;
      if (appData.toolSelected == tool) {
        colorText = theme.accent;
      }

      return Listener(
        onPointerDown: (event) {
          appData.setToolSelected(tool);
        },
      child: Container(
        padding: const EdgeInsets.only(top: 2),
        child: UtilToolIcon(
        icon: iconData,
        isSelected: appData.toolSelected == tool,
      )));
    }).toList();

    return Column(children: toolWidgets);
  }
}