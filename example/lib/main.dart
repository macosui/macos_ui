import 'package:example/pages/buttons.dart';
import 'package:example/pages/colors_page.dart';
import 'package:example/pages/context_menus.dart';
import 'package:example/pages/dialogs_page.dart';
import 'package:example/pages/fields.dart';
import 'package:example/pages/indicators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return MacosApp(
          title: 'macos_ui example',
          theme: MacosThemeData.light(),
          darkTheme: MacosThemeData.dark(),
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          home: const Demo(),
        );
      },
    );
  }
}

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  double ratingValue = 0;
  double sliderValue = 0;
  bool value = false;

  int pageIndex = 0;

  final List<Widget> pages = [
    CupertinoTabView(
      builder: (_) => const ButtonsPage(),
    ),
    const IndicatorsPage(),
    const FieldsPage(),
    const ColorsPage(),
    const ContextMenusPage(),
    const Center(
        child: MacosIcon(
      CupertinoIcons.add,
    )),
    const DialogsPage(),
  ];

  Color textLuminance(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      child: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
      sidebar: Sidebar(
        minWidth: 200,
        bottom: const Padding(
          padding: EdgeInsets.all(16.0),
          child: MacosListTile(
            leading: MacosIcon(CupertinoIcons.profile_circled),
            title: Text('Tim Apple'),
            subtitle: Text('tim@apple.com'),
          ),
        ),
        builder: (context, controller) {
          return SidebarItems(
            currentIndex: pageIndex,
            onChanged: (i) => setState(() => pageIndex = i),
            scrollController: controller,
            items: [
              const SidebarItem(
                leading: MacosIcon(CupertinoIcons.square_on_circle),
                label: Text('Buttons'),
              ),
              const SidebarItem(
                leading: MacosIcon(CupertinoIcons.arrow_2_circlepath),
                label: Text('Indicators'),
              ),
              const SidebarItem(
                leading: MacosIcon(CupertinoIcons.textbox),
                label: Text('Fields'),
              ),
              const SidebarItem(
                label: Text('Disclosure'),
                disclosureItems: [
                  SidebarItem(
                    leading: MacosIcon(CupertinoIcons.infinite),
                    label: Text('Colors'),
                  ),
                  SidebarItem(
                    leading: MacosIcon(CupertinoIcons.heart),
                    label: Text('Context Menus'),
                  ),
                  SidebarItem(
                    leading: MacosIcon(CupertinoIcons.infinite),
                    label: Text('Item 3'),
                  ),
                ],
              ),
              const SidebarItem(
                leading: MacosIcon(CupertinoIcons.rectangle),
                label: Text('Dialogs & Sheets'),
              ),
            ],
          );
        },
      ),
    );
  }
}
