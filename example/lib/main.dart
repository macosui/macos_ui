import 'package:example/pages/buttons_page.dart';
import 'package:example/pages/colors_page.dart';
import 'package:example/pages/dialogs_page.dart';
import 'package:example/pages/fields_page.dart';
import 'package:example/pages/indicators_page.dart';
import 'package:example/pages/selectors_page.dart';
import 'package:example/pages/tabview_page.dart';
import 'package:example/pages/toolbar_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

void main() {
  runApp(const MacosUIGalleryApp());
}

class MacosUIGalleryApp extends StatelessWidget {
  const MacosUIGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return MacosApp(
          title: 'macos_ui Widget Gallery',
          theme: MacosThemeData.light(),
          darkTheme: MacosThemeData.dark(),
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          home: const WidgetGallery(),
        );
      },
    );
  }
}

class WidgetGallery extends StatefulWidget {
  const WidgetGallery({super.key});

  @override
  State<WidgetGallery> createState() => _WidgetGalleryState();
}

class _WidgetGalleryState extends State<WidgetGallery> {
  double ratingValue = 0;
  double sliderValue = 0;
  bool value = false;

  int pageIndex = 0;

  late final searchFieldController = TextEditingController();

  final List<Widget> pages = [
    CupertinoTabView(
      builder: (_) => const ButtonsPage(),
    ),
    const IndicatorsPage(),
    const FieldsPage(),
    const ColorsPage(),
    const Center(
      child: MacosIcon(
        CupertinoIcons.add,
      ),
    ),
    const DialogsPage(),
    const ToolbarPage(),
    const SelectorsPage(),
    const TabViewPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: const [
        PlatformMenu(
          label: 'macos_ui Widget Gallery',
          menus: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.about,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.quit,
            ),
          ],
        ),
        PlatformMenu(
          label: 'View',
          menus: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.toggleFullScreen,
            ),
          ],
        ),
        PlatformMenu(
          label: 'Window',
          menus: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.minimizeWindow,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.zoomWindow,
            ),
          ],
        ),
      ],
      body: MacosWindow(
        sidebar: Sidebar(
          top: MacosSearchField(
            placeholder: 'Search',
            controller: searchFieldController,
            onResultSelected: (result) {
              switch (result.searchKey) {
                case 'Buttons':
                  setState(() {
                    pageIndex = 0;
                    searchFieldController.clear();
                  });
                  break;
                case 'Indicators':
                  setState(() {
                    pageIndex = 1;
                    searchFieldController.clear();
                  });
                  break;
                case 'Fields':
                  setState(() {
                    pageIndex = 2;
                    searchFieldController.clear();
                  });
                  break;
                case 'Colors':
                  setState(() {
                    pageIndex = 3;
                    searchFieldController.clear();
                  });
                  break;
                case 'Dialogs and Sheets':
                  setState(() {
                    pageIndex = 5;
                    searchFieldController.clear();
                  });
                  break;
                case 'Toolbar':
                  setState(() {
                    pageIndex = 6;
                    searchFieldController.clear();
                  });
                  break;
                case 'Selectors':
                  setState(() {
                    pageIndex = 7;
                    searchFieldController.clear();
                  });
                  break;
                default:
                  searchFieldController.clear();
              }
            },
            results: const [
              SearchResultItem('Buttons'),
              SearchResultItem('Indicators'),
              SearchResultItem('Fields'),
              SearchResultItem('Colors'),
              SearchResultItem('Dialogs and Sheets'),
              SearchResultItem('Toolbar'),
              SearchResultItem('Selectors'),
            ],
          ),
          minWidth: 200,
          builder: (context, controller) {
            return SidebarItems(
              currentIndex: pageIndex,
              onChanged: (i) => setState(() => pageIndex = i),
              scrollController: controller,
              items: const [
                SidebarItem(
                  leading: MacosIcon(CupertinoIcons.square_on_circle),
                  label: Text('Buttons'),
                ),
                SidebarItem(
                  leading: MacosIcon(CupertinoIcons.arrow_2_circlepath),
                  label: Text('Indicators'),
                ),
                SidebarItem(
                  leading: MacosIcon(CupertinoIcons.textbox),
                  label: Text('Fields'),
                ),
                SidebarItem(
                  leading: Icon(CupertinoIcons.folder),
                  label: Text('Disclosure'),
                  disclosureItems: [
                    SidebarItem(
                      leading: MacosIcon(CupertinoIcons.infinite),
                      label: Text('Colors'),
                    ),
                    SidebarItem(
                      leading: MacosIcon(CupertinoIcons.infinite),
                      label: Text('Item 3'),
                    ),
                  ],
                ),
                SidebarItem(
                  leading: MacosIcon(CupertinoIcons.rectangle),
                  label: Text('Dialogs & Sheets'),
                ),
                SidebarItem(
                  leading: MacosIcon(CupertinoIcons.macwindow),
                  label: Text('Toolbar'),
                ),
                SidebarItem(
                  leading: MacosIcon(CupertinoIcons.calendar),
                  label: Text('Selectors'),
                ),
                SidebarItem(
                  leading: MacosIcon(CupertinoIcons.table_fill),
                  label: Text('TabView'),
                ),
              ],
            );
          },
          bottom: const MacosListTile(
            leading: MacosIcon(CupertinoIcons.profile_circled),
            title: Text('Tim Apple'),
            subtitle: Text('tim@apple.com'),
          ),
        ),
        endSidebar: Sidebar(
          startWidth: 200,
          minWidth: 200,
          maxWidth: 300,
          shownByDefault: false,
          builder: (context, scrollController) {
            return const Center(
              child: Text('End Sidebar'),
            );
          },
        ),
        child: IndexedStack(
          index: pageIndex,
          children: pages,
        ),
      ),
    );
  }
}
