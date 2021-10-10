import 'package:example/pages/buttons.dart';
import 'package:example/pages/colors_page.dart';
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
    const Center(child: Text('Disclosure item 2')),
    const Center(child: Text('Disclosure item 3')),
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
        bottom: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.profile_circled),
              const SizedBox(width: 8.0),
              const Text('Tim Apple'),
            ],
          ),
        ),
        builder: (context, controller) {
          return SidebarItems(
            currentIndex: pageIndex,
            onChanged: (i) => setState(() => pageIndex = i),
            scrollController: controller,
            items: [
              const SidebarItem(
                leading: Icon(CupertinoIcons.square_on_circle),
                label: Text('Buttons'),
              ),
              const SidebarItem(
                leading: Icon(CupertinoIcons.arrow_2_circlepath),
                label: Text('Indicators'),
              ),
              const SidebarItem(
                leading: Icon(CupertinoIcons.textbox),
                label: Text('Fields'),
              ),
              const SidebarItem(
                label: Text('Disclosure'),
                disclosureItems: [
                  SidebarItem(
                    leading: Icon(CupertinoIcons.infinite),
                    label: Text('Colors'),
                  ),
                  SidebarItem(
                    leading: Icon(CupertinoIcons.heart),
                    label: Text('Item 2'),
                  ),
                  SidebarItem(
                    leading: Icon(CupertinoIcons.infinite),
                    label: Text('Item 3'),
                  ),
                ],
              ),
              const SidebarItem(
                leading: Icon(CupertinoIcons.rectangle),
                label: Text('Dialogs and Sheets'),
              ),
            ],
          );
        },
      ),
    );
  }
}
