import 'package:flutter/cupertino.dart';
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

    return Column(children: [
      Container(
          padding: const EdgeInsets.only(top: 2, left: 2),
          child: UtilButtonIcon(
              size: 24,
              isSelected: appData.toolSelected == "pointer",
              onPressed: () {
                appData.setToolSelected("pointer");
              },
              child: Image.asset('assets/images/arrow_pointer.png', width: 18, height: 18))), 
      Container(
          padding: const EdgeInsets.only(top: 2, left: 2),
          child: UtilButtonIcon(
              size: 24,
              isSelected: appData.toolSelected == "pencil",
              onPressed: () {
                appData.setToolSelected("pencil");
              },
              child: Icon(Icons.edit, size: 18))),
    ]);
  }
}