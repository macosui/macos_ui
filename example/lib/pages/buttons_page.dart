import 'package:example/widgets/widget_text_title1.dart';
import 'package:example/widgets/widget_text_title2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

class ButtonsPage extends StatefulWidget {
  const ButtonsPage({super.key});

  @override
  State<ButtonsPage> createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  String popupValue = 'One';
  String languagePopupValue = 'English';
  bool switchValue = false;
  bool isDisclosureButtonPressed = false;
  final _tabController = MacosTabController(initialIndex: 0, length: 3);

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Buttons'),
        titleWidth: 150.0,
        leading: MacosTooltip(
          message: 'Toggle Sidebar',
          useMousePosition: false,
          child: MacosIconButton(
            icon: MacosIcon(
              CupertinoIcons.sidebar_left,
              color: MacosTheme.brightnessOf(context).resolve(
                const Color.fromRGBO(0, 0, 0, 0.5),
                const Color.fromRGBO(255, 255, 255, 0.5),
              ),
              size: 20.0,
            ),
            boxConstraints: const BoxConstraints(
              minHeight: 20,
              minWidth: 20,
              maxWidth: 48,
              maxHeight: 38,
            ),
            onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
          ),
        ),
        actions: [
          ToolBarIconButton(
            label: 'Toggle End Sidebar',
            tooltipMessage: 'Toggle End Sidebar',
            icon: const MacosIcon(
              CupertinoIcons.sidebar_right,
            ),
            onPressed: () => MacosWindowScope.of(context).toggleEndSidebar(),
            showLabel: false,
          ),
        ],
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WidgetTextTitle1(widgetName: 'PushButton'),
                  Divider(color: MacosTheme.of(context).dividerColor),
                  Text(
                    'Primary',
                    style: MacosTypography.of(context).title2,
                  ),
                  Row(
                    children: [
                      PushButton(
                        controlSize: ControlSize.mini,
                        child: const Text('Mini'),
                        onPressed: () {
                          MacosWindowScope.of(context).toggleSidebar();
                        },
                      ),
                      const SizedBox(width: 8),
                      PushButton(
                        controlSize: ControlSize.small,
                        child: const Text('Small'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return MacosScaffold(
                                  toolBar: const ToolBar(
                                    title: Text('New page'),
                                  ),
                                  children: [
                                    ContentArea(
                                      builder: (context, _) {
                                        return Center(
                                          child: PushButton(
                                            controlSize: ControlSize.regular,
                                            child: const Text('Go Back'),
                                            onPressed: () {
                                              Navigator.of(context).maybePop();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    ResizablePane(
                                      minSize: 180,
                                      startSize: 200,
                                      windowBreakpoint: 700,
                                      resizableSide: ResizableSide.left,
                                      builder: (_, __) {
                                        return const Center(
                                          child: Text('Resizable Pane'),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      PushButton(
                        controlSize: ControlSize.regular,
                        child: const Text('Regular'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return MacosScaffold(
                                  toolBar: const ToolBar(
                                    title: Text('New page'),
                                  ),
                                  children: [
                                    ContentArea(
                                      builder: (context, _) {
                                        return Center(
                                          child: PushButton(
                                            controlSize: ControlSize.regular,
                                            child: const Text('Go Back'),
                                            onPressed: () {
                                              Navigator.of(context).maybePop();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    ResizablePane(
                                      minSize: 180,
                                      startSize: 200,
                                      windowBreakpoint: 700,
                                      resizableSide: ResizableSide.left,
                                      builder: (_, __) {
                                        return const Center(
                                          child: Text('Resizable Pane'),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      PushButton(
                        controlSize: ControlSize.large,
                        child: const Text('Large'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return MacosScaffold(
                                  toolBar: const ToolBar(
                                    title: Text('New page'),
                                  ),
                                  children: [
                                    ContentArea(
                                      builder: (context, _) {
                                        return Center(
                                          child: PushButton(
                                            controlSize: ControlSize.regular,
                                            child: const Text('Go Back'),
                                            onPressed: () {
                                              Navigator.of(context).maybePop();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    ResizablePane(
                                      minSize: 180,
                                      startSize: 200,
                                      windowBreakpoint: 700,
                                      resizableSide: ResizableSide.left,
                                      builder: (_, __) {
                                        return const Center(
                                          child: Text('Resizable Pane'),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Disabled Primary',
                    style: MacosTypography.of(context).title2,
                  ),
                  const Row(
                    children: [
                      PushButton(
                        controlSize: ControlSize.mini,
                        child: Text('Mini'),
                      ),
                      SizedBox(width: 8),
                      PushButton(
                        controlSize: ControlSize.small,
                        child: Text('Small'),
                      ),
                      SizedBox(width: 8),
                      PushButton(
                        controlSize: ControlSize.regular,
                        child: Text('Regular'),
                      ),
                      SizedBox(width: 8),
                      PushButton(
                        controlSize: ControlSize.large,
                        child: Text('Large'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Secondary',
                    style: MacosTypography.of(context).title2,
                  ),
                  Row(
                    children: [
                      PushButton(
                        controlSize: ControlSize.mini,
                        secondary: true,
                        child: const Text('Mini'),
                        onPressed: () {
                          MacosWindowScope.of(context).toggleSidebar();
                        },
                      ),
                      const SizedBox(width: 8),
                      PushButton(
                        controlSize: ControlSize.small,
                        secondary: true,
                        child: const Text('Small'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return MacosScaffold(
                                  toolBar: const ToolBar(
                                    title: Text('New page'),
                                  ),
                                  children: [
                                    ContentArea(
                                      builder: (context, _) {
                                        return Center(
                                          child: PushButton(
                                            controlSize: ControlSize.regular,
                                            child: const Text('Go Back'),
                                            onPressed: () {
                                              Navigator.of(context).maybePop();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    ResizablePane(
                                      minSize: 180,
                                      startSize: 200,
                                      windowBreakpoint: 700,
                                      resizableSide: ResizableSide.left,
                                      builder: (_, __) {
                                        return const Center(
                                          child: Text('Resizable Pane'),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      PushButton(
                        controlSize: ControlSize.regular,
                        secondary: true,
                        child: const Text('Regular'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return MacosScaffold(
                                  toolBar: const ToolBar(
                                    title: Text('New page'),
                                  ),
                                  children: [
                                    ContentArea(
                                      builder: (context, _) {
                                        return Center(
                                          child: PushButton(
                                            controlSize: ControlSize.regular,
                                            child: const Text('Go Back'),
                                            onPressed: () {
                                              Navigator.of(context).maybePop();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    ResizablePane(
                                      minSize: 180,
                                      startSize: 200,
                                      windowBreakpoint: 700,
                                      resizableSide: ResizableSide.left,
                                      builder: (_, __) {
                                        return const Center(
                                          child: Text('Resizable Pane'),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      PushButton(
                        controlSize: ControlSize.large,
                        secondary: true,
                        child: const Text('Large'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return MacosScaffold(
                                  toolBar: const ToolBar(
                                    title: Text('New page'),
                                  ),
                                  children: [
                                    ContentArea(
                                      builder: (context, _) {
                                        return Center(
                                          child: PushButton(
                                            controlSize: ControlSize.regular,
                                            child: const Text('Go Back'),
                                            onPressed: () {
                                              Navigator.of(context).maybePop();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    ResizablePane(
                                      minSize: 180,
                                      startSize: 200,
                                      windowBreakpoint: 700,
                                      resizableSide: ResizableSide.left,
                                      builder: (_, __) {
                                        return const Center(
                                          child: Text('Resizable Pane'),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Disabled Secondary',
                    style: MacosTypography.of(context).title2,
                  ),
                  const Row(
                    children: [
                      PushButton(
                        controlSize: ControlSize.mini,
                        secondary: true,
                        child: Text('Mini'),
                      ),
                      SizedBox(width: 8),
                      PushButton(
                        controlSize: ControlSize.small,
                        secondary: true,
                        child: Text('Small'),
                      ),
                      SizedBox(width: 8),
                      PushButton(
                        controlSize: ControlSize.regular,
                        secondary: true,
                        child: Text('Regular'),
                      ),
                      SizedBox(width: 8),
                      PushButton(
                        controlSize: ControlSize.large,
                        secondary: true,
                        child: Text('Large'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const WidgetTextTitle1(widgetName: 'HelpButton'),
                  Divider(color: MacosTheme.of(context).dividerColor),
                  HelpButton(onPressed: () {}),
                  const SizedBox(height: 16),
                  Text(
                    'Icon Buttons',
                    style: MacosTypography.of(context).title1,
                  ),
                  Divider(color: MacosTheme.of(context).dividerColor),
                  const WidgetTextTitle2(widgetName: 'MacosBackButton'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      MacosBackButton(
                        onPressed: () => debugPrint('click'),
                        fillColor: Colors.transparent,
                      ),
                      const SizedBox(width: 16.0),
                      MacosBackButton(
                        onPressed: () => debugPrint('click'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const WidgetTextTitle2(widgetName: 'MacosDisclosureButton'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      MacosDisclosureButton(
                        isPressed: isDisclosureButtonPressed,
                        onPressed: () {
                          debugPrint('click');
                          setState(() {
                            isDisclosureButtonPressed =
                                !isDisclosureButtonPressed;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const WidgetTextTitle2(widgetName: 'MacosIconButton'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      MacosIconButton(
                        icon: const MacosIcon(
                          CupertinoIcons.star_fill,
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(7),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      const MacosIconButton(
                        icon: MacosIcon(
                          CupertinoIcons.plus_app,
                        ),
                        shape: BoxShape.circle,
                        //onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      MacosIconButton(
                        icon: const MacosIcon(
                          CupertinoIcons.minus_square,
                        ),
                        backgroundColor: Colors.transparent,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Switches, Checkboxes, & Radios',
                    style: MacosTypography.of(context).title1,
                  ),
                  Divider(color: MacosTheme.of(context).dividerColor),
                  const WidgetTextTitle2(widgetName: 'MacosSwitch'),
                  const SizedBox(height: 8),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Text('Mini'),
                          const SizedBox(width: 8),
                          MacosSwitch(
                            value: switchValue,
                            size: ControlSize.mini,
                            onChanged: (value) {
                              setState(() => switchValue = value);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          const Text('Small'),
                          const SizedBox(width: 8),
                          MacosSwitch(
                            value: switchValue,
                            size: ControlSize.small,
                            onChanged: (value) {
                              setState(() => switchValue = value);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          const Text('Regular'),
                          const SizedBox(width: 8),
                          MacosSwitch(
                            value: switchValue,
                            onChanged: (value) {
                              setState(() => switchValue = value);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const WidgetTextTitle2(widgetName: 'MacosCheckbox'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      MacosCheckbox(
                        value: switchValue,
                        onChanged: (value) {
                          setState(() => switchValue = value);
                        },
                      ),
                      const SizedBox(width: 8),
                      MacosCheckbox(
                        value: switchValue,
                        onChanged: null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const WidgetTextTitle2(widgetName: 'MacosRadioButton'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('System Theme'),
                      const SizedBox(width: 8),
                      MacosRadioButton<ThemeMode>(
                        groupValue: context.watch<AppTheme>().mode,
                        value: ThemeMode.system,
                        onChanged: (value) {
                          context.read<AppTheme>().mode = value!;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Light Theme'),
                      const SizedBox(width: 24),
                      MacosRadioButton<ThemeMode>(
                        groupValue: context.watch<AppTheme>().mode,
                        value: ThemeMode.light,
                        onChanged: (value) {
                          context.read<AppTheme>().mode = value!;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Dark Theme'),
                      const SizedBox(width: 26),
                      MacosRadioButton<ThemeMode>(
                        groupValue: context.watch<AppTheme>().mode,
                        value: ThemeMode.dark,
                        onChanged: (value) {
                          context.read<AppTheme>().mode = value!;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Pulldown & Popup Buttons',
                    style: MacosTypography.of(context).title1,
                  ),
                  Divider(color: MacosTheme.of(context).dividerColor),
                  const WidgetTextTitle2(widgetName: 'MacosPulldownButton'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      MacosPulldownButton(
                        title: 'PDF',
                        items: [
                          MacosPulldownMenuItem(
                            title: const Text('Open in Preview'),
                            onTap: () => debugPrint('Opening in preview...'),
                          ),
                          MacosPulldownMenuItem(
                            title: const Text('Save as PDF...'),
                            onTap: () => debugPrint('Saving as PDF...'),
                          ),
                          MacosPulldownMenuItem(
                            enabled: false,
                            title: const Text('Save as Postscript'),
                            onTap: () => debugPrint('Saving as Postscript...'),
                          ),
                          const MacosPulldownMenuDivider(),
                          MacosPulldownMenuItem(
                            enabled: false,
                            title: const Text('Save to iCloud Drive'),
                            onTap: () => debugPrint('Saving to iCloud...'),
                          ),
                          MacosPulldownMenuItem(
                            enabled: false,
                            title: const Text('Save to Web Receipts'),
                            onTap: () =>
                                debugPrint('Saving to Web Receipts...'),
                          ),
                          MacosPulldownMenuItem(
                            title: const Text('Send in Mail...'),
                            onTap: () => debugPrint('Sending via Mail...'),
                          ),
                          const MacosPulldownMenuDivider(),
                          MacosPulldownMenuItem(
                            title: const Text('Edit Menu...'),
                            onTap: () => debugPrint('Editing menu...'),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      const MacosPulldownButton(
                        title: 'PDF',
                        disabledTitle: 'Disabled',
                        items: [],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      MacosPulldownButton(
                        icon: CupertinoIcons.ellipsis_circle,
                        items: [
                          MacosPulldownMenuItem(
                            title: const Text('New Folder'),
                            onTap: () => debugPrint('Creating new folder...'),
                          ),
                          MacosPulldownMenuItem(
                            title: const Text('Open'),
                            onTap: () => debugPrint('Opening...'),
                          ),
                          MacosPulldownMenuItem(
                            title: const Text('Open with...'),
                            onTap: () => debugPrint('Opening with...'),
                          ),
                          MacosPulldownMenuItem(
                            title: const Text('Import from iPhone...'),
                            onTap: () => debugPrint('Importing...'),
                          ),
                          const MacosPulldownMenuDivider(),
                          MacosPulldownMenuItem(
                            enabled: false,
                            title: const Text('Remove'),
                            onTap: () => debugPrint('Deleting...'),
                          ),
                          MacosPulldownMenuItem(
                            title: const Text('Move to Bin'),
                            onTap: () => debugPrint('Moving to Bin...'),
                          ),
                          const MacosPulldownMenuDivider(),
                          MacosPulldownMenuItem(
                            title: const Text('Tags...'),
                            onTap: () => debugPrint('Tags...'),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      const MacosPulldownButton(
                        icon: CupertinoIcons.square_grid_3x2,
                        items: [],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const WidgetTextTitle2(widgetName: 'MacosPopupButton'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      MacosPopupButton<String>(
                        value: popupValue,
                        onChanged: (String? newValue) {
                          setState(() => popupValue = newValue!);
                        },
                        items: <String>['One', 'Two', 'Three', 'Four']
                            .map<MacosPopupMenuItem<String>>((String value) {
                          return MacosPopupMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 20),
                      MacosPopupButton<String>(
                        disabledHint: const Text('Disabled'),
                        onChanged: null,
                        items: null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  MacosPopupButton<String>(
                    value: languagePopupValue,
                    onChanged: (String? newValue) {
                      setState(() => languagePopupValue = newValue!);
                    },
                    items: languages
                        .map<MacosPopupMenuItem<String>>((String value) {
                      return MacosPopupMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const WidgetTextTitle1(widgetName: 'MacosSegmentedControl'),
                  Divider(color: MacosTheme.of(context).dividerColor),
                  const SizedBox(height: 8),
                  MacosSegmentedControl(
                    controller: _tabController,
                    tabs: [
                      MacosTab(
                        label: 'Tab 1',
                        active: _tabController.index == 0,
                      ),
                      MacosTab(
                        label: 'Tab 2',
                        active: _tabController.index == 1,
                      ),
                      MacosTab(
                        label: 'Tab 3',
                        active: _tabController.index == 2,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

const languages = [
  'Mandarin Chinese',
  'Spanish',
  'English',
  'Hindi/Urdu',
  'Arabic',
  'Bengali',
  'Portuguese',
  'Russian',
  'Japanese',
  'German',
  'Thai',
  'Greek',
  'Nepali',
  'Punjabi',
  'Wu',
  'French',
  'Telugu',
  'Vietnamese',
  'Marathi',
  'Korean',
  'Tamil',
  'Italian',
  'Turkish',
  'Cantonese/Yue',
  'Urdu',
  'Javanese',
  'Egyptian Arabic',
  'Gujarati',
  'Iranian Persian',
  'Indonesian',
  'Polish',
  'Ukrainian',
  'Romanian',
  'Dutch'
];
