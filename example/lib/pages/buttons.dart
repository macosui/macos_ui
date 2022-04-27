import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

class ButtonsPage extends StatefulWidget {
  const ButtonsPage({Key? key}) : super(key: key);

  @override
  _ButtonsPageState createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  String popupValue = 'One';
  String languagePopupValue = 'English';

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      titleBar: const TitleBar(
        title: Text('App title bar'),
      ),
      toolBar: ToolBar(
        title: const Text('macOS UI Widget Gallery'),
        leading: MacosBackButton(
          onPressed: () => debugPrint('click'),
          fillColor: Colors.transparent,
        ),
        actions: [
          ToolBarPullDownButton(
            icon: CupertinoIcons.ellipsis_circle,
            items: [
              MacosPulldownMenuItem(
                title: const Text('New Folder'),
                onTap: () => debugPrint("Creating new folder..."),
              ),
              MacosPulldownMenuItem(
                title: const Text('Open'),
                onTap: () => debugPrint("Opening..."),
              ),
              MacosPulldownMenuItem(
                title: const Text('Open with...'),
                onTap: () => debugPrint("Opening with..."),
              ),
              MacosPulldownMenuItem(
                title: const Text('Import from iPhone...'),
                onTap: () => debugPrint("Importing..."),
              ),
              const MacosPulldownMenuDivider(),
              MacosPulldownMenuItem(
                enabled: false,
                title: const Text('Remove'),
                onTap: () => debugPrint("Deleting..."),
              ),
              MacosPulldownMenuItem(
                title: const Text('Move to Bin'),
                onTap: () => debugPrint("Moving to Bin..."),
              ),
              const MacosPulldownMenuDivider(),
              MacosPulldownMenuItem(
                title: const Text('Tags...'),
                onTap: () => debugPrint("Tags..."),
              ),
            ],
          ),
          ToolBarIconButton(
            label: "Pick Color",
            icon: const MacosIcon(
              CupertinoIcons.eyedropper,
            ),
            onPressed: () => debugPrint("pressed"),
          ),
          const ToolBarIconButton(
            label: "Change View",
            icon: const MacosIcon(
              CupertinoIcons.list_bullet,
            ),
          ),
          const ToolBarSpacer(),
          ToolBarIconButton(
            label: "Table",
            icon: const MacosIcon(
              CupertinoIcons.square_grid_3x2,
            ),
            onPressed: () => debugPrint("pressed"),
          ),
          ToolBarIconButton(
            label: "Share",
            icon: const MacosIcon(
              CupertinoIcons.share,
            ),
            onPressed: () => debugPrint("pressed"),
          ),
          ToolBarIconButton(
            label: "Delete",
            icon: const MacosIcon(
              CupertinoIcons.trash,
            ),
            onPressed: () => debugPrint("pressed"),
          ),
          ToolBarIconButton(
            label: "Toggle Sidebar",
            icon: const MacosIcon(
              CupertinoIcons.sidebar_left,
            ),
            onPressed: () {
              MacosWindowScope.of(context).toggleSidebar();
            },
          ),
        ],
      ),
      children: [
        ResizablePane(
          minWidth: 180,
          startWidth: 200,
          windowBreakpoint: 700,
          resizableSide: ResizableSide.right,
          builder: (_, __) {
            return const Center(
              child: Text('Resizable Pane'),
            );
          },
        ),
        ContentArea(builder: (context, scrollController) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('MacosBackButton'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                const Text('MacosIconButton'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MacosIconButton(
                      icon: const MacosIcon(
                        CupertinoIcons.star_fill,
                        color: Colors.white,
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(7),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    const MacosIconButton(
                      icon: MacosIcon(
                        CupertinoIcons.plus_app,
                        color: Colors.white,
                      ),
                      shape: BoxShape.circle,
                      //onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    MacosIconButton(
                      icon: const MacosIcon(
                        CupertinoIcons.minus_square,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.transparent,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                PushButton(
                  buttonSize: ButtonSize.large,
                  child: const Text('large PushButton'),
                  onPressed: () {
                    MacosWindowScope.of(context).toggleSidebar();
                  },
                ),
                const SizedBox(height: 20),
                PushButton(
                  buttonSize: ButtonSize.small,
                  child: const Text('small PushButton'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return MacosScaffold(
                            titleBar: const TitleBar(
                              centerTitle: false,
                              title: Text('New page'),
                            ),
                            children: [
                              ContentArea(
                                builder: (context, scrollController) {
                                  return Center(
                                    child: PushButton(
                                      buttonSize: ButtonSize.large,
                                      child: const Text('Go Back'),
                                      onPressed: () {
                                        Navigator.maybePop(context);
                                      },
                                    ),
                                  );
                                },
                              ),
                              ResizablePane(
                                minWidth: 180,
                                startWidth: 200,
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
                const SizedBox(height: 20),
                PushButton(
                  buttonSize: ButtonSize.large,
                  isSecondary: true,
                  child: const Text('secondary PushButton'),
                  onPressed: () {
                    MacosWindowScope.of(context).toggleSidebar();
                  },
                ),
                const SizedBox(height: 20),
                const Text('MacosPulldownButton'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MacosPulldownButton(
                      title: "PDF",
                      items: [
                        MacosPulldownMenuItem(
                          title: const Text('Open in Preview'),
                          onTap: () => debugPrint("Opening in preview..."),
                        ),
                        MacosPulldownMenuItem(
                          title: const Text('Save as PDF...'),
                          onTap: () => debugPrint("Saving as PDF..."),
                        ),
                        MacosPulldownMenuItem(
                          enabled: false,
                          title: const Text('Save as Postscript'),
                          onTap: () => debugPrint("Saving as Postscript..."),
                        ),
                        const MacosPulldownMenuDivider(),
                        MacosPulldownMenuItem(
                          enabled: false,
                          title: const Text('Save to iCloud Drive'),
                          onTap: () => debugPrint("Saving to iCloud..."),
                        ),
                        MacosPulldownMenuItem(
                          enabled: false,
                          title: const Text('Save to Web Receipts'),
                          onTap: () => debugPrint("Saving to Web Receipts..."),
                        ),
                        MacosPulldownMenuItem(
                          title: const Text('Send in Mail...'),
                          onTap: () => debugPrint("Sending via Mail..."),
                        ),
                        const MacosPulldownMenuDivider(),
                        MacosPulldownMenuItem(
                          title: const Text('Edit Menu...'),
                          onTap: () => debugPrint("Editing menu..."),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    const MacosPulldownButton(
                      title: "PDF",
                      disabledTitle: "Disabled",
                      items: [],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MacosPulldownButton(
                      icon: CupertinoIcons.ellipsis_circle,
                      items: [
                        MacosPulldownMenuItem(
                          title: const Text('New Folder'),
                          onTap: () => debugPrint("Creating new folder..."),
                        ),
                        MacosPulldownMenuItem(
                          title: const Text('Open'),
                          onTap: () => debugPrint("Opening..."),
                        ),
                        MacosPulldownMenuItem(
                          title: const Text('Open with...'),
                          onTap: () => debugPrint("Opening with..."),
                        ),
                        MacosPulldownMenuItem(
                          title: const Text('Import from iPhone...'),
                          onTap: () => debugPrint("Importing..."),
                        ),
                        const MacosPulldownMenuDivider(),
                        MacosPulldownMenuItem(
                          enabled: false,
                          title: const Text('Remove'),
                          onTap: () => debugPrint("Deleting..."),
                        ),
                        MacosPulldownMenuItem(
                          title: const Text('Move to Bin'),
                          onTap: () => debugPrint("Moving to Bin..."),
                        ),
                        const MacosPulldownMenuDivider(),
                        MacosPulldownMenuItem(
                          title: const Text('Tags...'),
                          onTap: () => debugPrint("Tags..."),
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
                const Text('MacosPopupButton'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      disabledHint: const Text("Disabled"),
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
                  items:
                      languages.map<MacosPopupMenuItem<String>>((String value) {
                    return MacosPopupMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          );
        }),
        ResizablePane(
          minWidth: 180,
          startWidth: 200,
          windowBreakpoint: 800,
          resizableSide: ResizableSide.left,
          builder: (_, __) {
            return const Center(
              child: Text('Resizable Pane'),
            );
          },
        ),
      ],
    );
  }
}

const languages = [
  "Mandarin Chinese",
  "Spanish",
  "English",
  "Hindi/Urdu",
  "Arabic",
  "Bengali",
  "Portuguese",
  "Russian",
  "Japanese",
  "German",
  "Thai",
  "Greek",
  "Nepali",
  "Punjabi",
  "Wu",
  "French",
  "Telugu",
  "Vietnamese",
  "Marathi",
  "Korean",
  "Tamil",
  "Italian",
  "Turkish",
  "Cantonese/Yue",
  "Urdu",
  "Javanese",
  "Egyptian Arabic",
  "Gujarati",
  "Iranian Persian",
  "Indonesian",
  "Polish",
  "Ukrainian",
  "Romanian",
  "Dutch"
];
