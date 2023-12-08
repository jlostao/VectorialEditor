import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'layout_sidebar_tools.dart';
import 'util_tab_views.dart';

class LayoutSidebarRight extends StatelessWidget {
  const LayoutSidebarRight({super.key});

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    Color backgroundColor = theme.backgroundSecondary1;
    double screenHeight = MediaQuery.of(context).size.height;

    TextStyle fontBold = const TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
    TextStyle font = const TextStyle(fontSize: 12, fontWeight: FontWeight.w400);

    return Container(
        color: backgroundColor,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top:1.0),
              height: screenHeight - 45,
              color: backgroundColor,
              child: UtilTabViews(isAccent: true, options: const [
                Text('Document'),
                Text('Format'),
                Text('Layers')
              ], views: [
                SizedBox(
                  width: double.infinity, // Estira el widget horitzontalment
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Document dimensions:", style: fontBold),
                        const SizedBox(height: 8),
                        Row(children: [
                          Text("Width:", style: font),
                          const SizedBox(width: 4),
                          SizedBox(width: 80, child:
                            CDKFieldNumeric(
                              value: appData.docSize.width,
                              min: 100,
                              max: 2500,
                              units: "px",
                              increment: 100,
                              decimals: 0,
                              onValueChanged: (value) {
                                appData.setDocWidth(value);
                              },
                            )),
                          Expanded(child: Container()),
                          Text("Height:", style: font),
                          const SizedBox(width: 4),
                          SizedBox(width: 80, child:
                            CDKFieldNumeric(
                              value: appData.docSize.height,
                              min: 100,
                              max: 2500,
                              units: "px",
                              increment: 100,
                              decimals: 0,
                              onValueChanged: (value) {
                                appData.setDocHeight(value);
                              },
                            ))
                        ],)
                      
                    ]),
                  ),
                ),
                SizedBox(
                  width: double.infinity, // Estira el widget horitzontalment
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const LayoutSidebarTools(),
                    Container(
                    padding: const EdgeInsets.all(4.0),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tool widgets'),
                      ],
                    )),
                  ]),
                
                ),
                SizedBox(
                  width: double.infinity, // Estira el widget horitzontalment
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    child: const Column(
                      children: [
                        Text('Layer A'),
                        Text('Layer B'),
                        Text('Layer C'),
                        Text('Layer D'),
                        Text('Layer E'),
                        Text('Layer F'),
                        Text('Layer C'),
                        Text('Layer D'),
                        Text('Layer E'),
                        Text('Layer F'),
                        Text('Layer C'),
                        Text('Layer D'),
                        Text('Layer E'),
                        Text('Layer F'),
                        Text('Layer C'),
                        Text('Layer D'),
                        Text('Layer E'),
                        Text('Layer F'),
                        Text('Layer C'),
                        Text('Layer D'),
                        Text('Layer E'),
                        Text('Layer F'),
                        Text('Layer C'),
                        Text('Layer D'),
                        Text('Layer E'),
                        Text('Layer F'),
                      ],
                    ),
                  ),
                ),
              ]),
            )
          ],
        ));
  }
}