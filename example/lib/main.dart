import 'package:example/pages/buttons.dart';
import 'package:example/pages/fields.dart';
import 'package:example/pages/indicators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return MacosApp(
          title: 'macos_ui example',
          theme: MacosThemeData.light(),
          darkTheme: MacosThemeData.dark().copyWith(
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          home: Demo(),
        );
      },
    );
  }
}

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  double ratingValue = 0;
  double sliderValue = 0;
  bool value = false;

  int pageIndex = 0;

  final List<Widget> pages = [
    ButtonsPage(),
    IndicatorsPage(),
    FieldsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      titleBar: TitleBar(
        size: TitleBarSize.small,
        child: Text('macos_ui Widget Gallery'),
      ),
      sidebar: Sidebar(
        minWidth: 200,
        builder: (context, _) => ListView(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() => pageIndex = 0);
                  },
                  child: Text('Buttons'),
                ),
              ),
            ),
            Divider(
              height: 0,
              color: MacosTheme.of(context).dividerColor,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() => pageIndex = 1);
                  },
                  child: Text('Indicators'),
                ),
              ),
            ),
            Divider(
              height: 0,
              color: MacosTheme.of(context).dividerColor,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() => pageIndex = 2);
                  },
                  child: Text('Fields'),
                ),
              ),
            ),
            Divider(
              height: 0,
              color: MacosTheme.of(context).dividerColor,
            ),
          ],
        ),
      ),
      children: <Widget>[
        ContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(20),
              child: IndexedStack(
                index: pageIndex,
                children: pages,
              ),
            );
          },
        ),
        // ResizablePane(
        //   minWidth: 180,
        //   startWidth: 200,
        //   scaffoldBreakpoint: 500,
        //   resizableSide: ResizableSide.left,
        //   builder: (_, __) {
        //     return Center(child: Text('Resizable Pane'));
        //   },
        // ),
      ],
    );
  }
}
