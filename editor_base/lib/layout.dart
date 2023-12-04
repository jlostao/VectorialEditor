import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
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

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: theme.backgroundSecondary0,
          middle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("hola"),
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
          central: Container(),
        ));
  }
}
