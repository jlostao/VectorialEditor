import 'package:editor_base/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'package:provider/provider.dart';
import 'layout_design.dart';
import 'layout_sidebar_right.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  GlobalKey<CDKAppSidebarsState> keyAppStructure = GlobalKey();

  void toggleRightSidebar() {
    final CDKAppSidebarsState? state = keyAppStructure.currentState;
    if (state != null) {
      state.setSidebarRightVisibility(!state.isSidebarRightVisible);
    }
  }

  double invertZoom(double zoom) {
    if (zoom < 100) { 
      return (zoom - 50) / 100;
    } else {
      double normalizedValue = (zoom - 100) / 400;
      return normalizedValue * (1 - 0.51) + 0.51;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    double zoomSlider = invertZoom(appData.zoom);

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: theme.backgroundSecondary0,
          middle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                      width: 75,
                      child: CDKPickerSlider(
                          value: zoomSlider,
                          onChanged: (value) {
                            zoomSlider = value;
                            if (value < 0.5) {
                              appData.setZoom(value * 100 + 50);
                            } else {
                              double normalizedValue =
                                  (value - 0.51) / (1 - 0.51);
                              appData.setZoom(normalizedValue * 400 + 100);
                            }
                            setState(() { });
                          })),
                  const SizedBox(width: 8),
                  Text("${appData.zoom.toStringAsFixed(0)}%",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400)),
                ]),
                CDKButtonIcon(
                  icon: CupertinoIcons.sidebar_right,
                  onPressed: () {
                    toggleRightSidebar();
                  },
                ),
              ]),
        ),
        child: CDKAppSidebars(
          key: keyAppStructure,
          sidebarLeftIsResizable: true,
          sidebarLeftDefaultsVisible: false,
          sidebarRightDefaultsVisible: true,
          sidebarLeft: Container(),
          sidebarRight: const LayoutSidebarRight(),
          sidebarRightWidth: 250,
          central: const LayoutDesign(),
        ));
  }
}