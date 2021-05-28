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

  final buttonsFocus = FocusNode();
  final indicatorsFocus = FocusNode();
  final fieldsFocus = FocusNode();

  final List<Widget> pages = [
    ButtonsPage(),
    IndicatorsPage(),
    FieldsPage(),
  ];

  Color textLuminance(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      titleBar: TitleBar(
        size: TitleBarSize.small,
        child: Text('macos_ui Widget Gallery'),
      ),
      sidebar: Sidebar(
        minWidth: 200,
        builder: (context, _) => FocusScope(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              SidebarItem(
                focusColor: pageIndex == 0
                    ? CupertinoColors.systemBlue
                    : Color(0x00000000),
                leading: Icon(
                  CupertinoIcons.square_on_circle,
                  size: 20,
                  color: pageIndex == 0
                      ? MacosColors.white
                      : CupertinoColors.systemBlue,
                ),
                label: Text(
                  'Buttons',
                  style: TextStyle(
                    color: pageIndex == 0
                        ? textLuminance(CupertinoColors.systemBlue)
                        : textLuminance(MacosTheme.of(context).canvasColor),
                  ),
                ),
                onClick: () {
                  setState(() => pageIndex = 0);
                },
              ),
              SidebarItem(
                focusColor: pageIndex == 1
                    ? CupertinoColors.systemBlue
                    : Color(0x00000000),
                leading: Icon(
                  CupertinoIcons.arrow_2_circlepath,
                  size: 20,
                  color: pageIndex == 1
                      ? MacosColors.white
                      : CupertinoColors.systemBlue,
                ),
                label: Text(
                  'Indicators',
                  style: TextStyle(
                    color: pageIndex == 1
                        ? textLuminance(CupertinoColors.systemBlue)
                        : textLuminance(MacosTheme.of(context).canvasColor),
                  ),
                ),
                onClick: () {
                  setState(() => pageIndex = 1);
                },
              ),
              SidebarItem(
                focusColor: pageIndex == 2
                    ? CupertinoColors.systemBlue
                    : Color(0x00000000),
                leading: Icon(
                  CupertinoIcons.textbox,
                  size: 20,
                  color: pageIndex == 2
                      ? MacosColors.white
                      : CupertinoColors.systemBlue,
                ),
                label: Text(
                  'Fields',
                  style: TextStyle(
                    color: pageIndex == 2
                        ? textLuminance(CupertinoColors.systemBlue)
                        : textLuminance(MacosTheme.of(context).canvasColor),
                  ),
                ),
                onClick: () {
                  setState(() => pageIndex = 2);
                },
              ),
            ],
          ),
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
