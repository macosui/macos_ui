import 'package:example/pages/buttons_page.dart';
import 'package:example/pages/colors_page.dart';
import 'package:example/pages/dialogs_page.dart';
import 'package:example/pages/fields_page.dart';
import 'package:example/pages/indicators_page.dart';
import 'package:example/pages/selectors_page.dart';
import 'package:example/pages/sliver_toolbar_page.dart';
import 'package:example/pages/tabview_page.dart';
import 'package:example/pages/toolbar_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

/// This delegate removes the toolbar in full-screen mode.
class _FlutterWindowDelegate extends NSWindowDelegate {
  @override
  void windowWillEnterFullScreen() {
    WindowManipulator.removeToolbar();
    super.windowWillEnterFullScreen();
  }

  @override
  void windowDidExitFullScreen() {
    WindowManipulator.addToolbar();
    super.windowDidExitFullScreen();
  }
}

/// This method initializes macos_window_utils and styles the window.
Future<void> _initMacosWindowUtils() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManipulator.initialize(enableWindowDelegate: true);
  await WindowManipulator.setMaterial(
      NSVisualEffectViewMaterial.windowBackground);
  await WindowManipulator.enableFullSizeContentView();
  await WindowManipulator.makeTitlebarTransparent();
  await WindowManipulator.hideTitle();
  await WindowManipulator.addToolbar();

  // Use NSWindowToolbarStyle.expanded if the app will have a title bar,
  // otherwise use NSWindowToolbarStyle.unified.
  await WindowManipulator.setToolbarStyle(
      toolbarStyle: NSWindowToolbarStyle.unified);

  // Create a delegate that removes the toolbar in full-screen mode.
  final delegate = _FlutterWindowDelegate();
  WindowManipulator.addNSWindowDelegate(delegate);

  // Auto-hide toolbar and menubar in full-screen mode.
  final options = NSAppPresentationOptions.from({
    NSAppPresentationOption.fullScreen,
    NSAppPresentationOption.autoHideToolbar,
    NSAppPresentationOption.autoHideMenuBar,
    NSAppPresentationOption.autoHideDock,
  });
  options.applyAsFullScreenPresentationOptions();
}

void main() async {
  await _initMacosWindowUtils();

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

  final List<Widget Function(bool)> pages = [
    (bool isVisible) => CupertinoTabView(
          builder: (_) => const ButtonsPage(),
        ),
    (bool isVisible) => const IndicatorsPage(),
    (bool isVisible) => const FieldsPage(),
    (bool isVisible) => const ColorsPage(),
    (bool isVisible) => const Center(
          child: MacosIcon(
            CupertinoIcons.add,
          ),
        ),
    (bool isVisible) => const DialogsPage(),
    (bool isVisible) => const ToolbarPage(),
    (bool isVisible) => SliverToolbarPage(
          isVisible: isVisible,
        ),
    (bool isVisible) => const TabViewPage(),
    (bool isVisible) => const SelectorsPage(),
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
      child: MacosWindow(
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
          builder: (context, scrollController) {
            return SidebarItems(
              currentIndex: pageIndex,
              onChanged: (i) => setState(() => pageIndex = i),
              scrollController: scrollController,
              itemSize: SidebarItemSize.large,
              items: [
                const SidebarItem(
                  // leading: MacosIcon(CupertinoIcons.square_on_circle),
                  leading: MacosImageIcon(
                    AssetImage(
                      'assets/sf_symbols/button_programmable_2x.png',
                    ),
                  ),
                  label: Text('Buttons'),
                ),
                const SidebarItem(
                  leading: MacosImageIcon(
                    AssetImage(
                      'assets/sf_symbols/lines_measurement_horizontal_2x.png',
                    ),
                  ),
                  label: Text('Indicators'),
                ),
                const SidebarItem(
                  leading: MacosImageIcon(
                    AssetImage(
                      'assets/sf_symbols/character_cursor_ibeam_2x.png',
                    ),
                  ),
                  label: Text('Fields'),
                ),
                SidebarItem(
                  leading: const MacosIcon(CupertinoIcons.folder),
                  label: const Text('Disclosure'),
                  trailing: Text(
                    '2',
                    style: TextStyle(
                      color: MacosTheme.brightnessOf(context) == Brightness.dark
                          ? MacosColors.tertiaryLabelColor.darkColor
                          : MacosColors.tertiaryLabelColor,
                    ),
                  ),
                  disclosureItems: [
                    const SidebarItem(
                      leading: MacosImageIcon(
                        AssetImage(
                          'assets/sf_symbols/rectangle_3_group_2x.png',
                        ),
                      ),
                      label: Text('Colors'),
                    ),
                    const SidebarItem(
                      leading: MacosIcon(CupertinoIcons.infinite),
                      label: Text('Item 3'),
                    ),
                  ],
                ),
                const SidebarItem(
                  leading: MacosIcon(CupertinoIcons.square_on_square),
                  label: Text('Dialogs & Sheets'),
                ),
                const SidebarItem(
                  leading: MacosImageIcon(
                    AssetImage(
                      'assets/sf_symbols/macwindow.on.rectangle_2x.png',
                    ),
                  ),
                  label: Text('Layout'),
                  disclosureItems: [
                    SidebarItem(
                      leading: MacosIcon(CupertinoIcons.macwindow),
                      label: Text('Toolbar'),
                    ),
                    SidebarItem(
                      leading: MacosImageIcon(
                        AssetImage(
                          'assets/sf_symbols/menubar.rectangle_2x.png',
                        ),
                      ),
                      label: Text('SliverToolbar'),
                    ),
                    SidebarItem(
                      leading: MacosIcon(CupertinoIcons.uiwindow_split_2x1),
                      label: Text('TabView'),
                    ),
                  ],
                ),
                const SidebarItem(
                  leading: MacosImageIcon(
                    AssetImage(
                      'assets/sf_symbols/filemenu_and_selection_2x.png',
                    ),
                  ),
                  label: Text('Selectors'),
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
          builder: (context, _) {
            return const Center(
              child: Text('End Sidebar'),
            );
          },
        ),
        child: IndexedStack(
          index: pageIndex,
          children: pages
              .asMap()
              .map((index, builder) {
                final widget = builder(index == pageIndex);
                return MapEntry(index, widget);
              })
              .values
              .toList(),
        ),
      ),
    );
  }
}
