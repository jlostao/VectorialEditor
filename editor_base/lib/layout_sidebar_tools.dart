import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';

class LayoutSidebarTools extends StatelessWidget {
  const LayoutSidebarTools({super.key});

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return Column(children: [
      Container(
          padding: const EdgeInsets.only(top: 2, left: 2),
          child: CDKButtonIcon(
              size: 28,
              icon: CupertinoIcons.wand_rays,
              isSelected: appData.toolSelected == "wand",
              onPressed: () {
                appData.setToolSelected("wand");
              })),
      Container(
          padding: const EdgeInsets.only(top: 2, left: 2),
          child: CDKButtonIcon(
              size: 28,
              icon: Icons.edit,
              isSelected: appData.toolSelected == "pencil",
              onPressed: () {
                appData.setToolSelected("pencil");
              })),
    ]);
  }
}
