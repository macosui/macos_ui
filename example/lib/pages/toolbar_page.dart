import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
// ignore: implementation_imports
import 'package:macos_ui/src/library.dart';

class ToolbarPage extends StatefulWidget {
  const ToolbarPage({super.key});

  @override
  State<ToolbarPage> createState() => _ToolbarPageState();
}

class _ToolbarPageState extends State<ToolbarPage> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Toolbar'),
        titleWidth: 100.0,
        actions: [
          ToolBarIconButton(
            icon: const MacosIcon(
              CupertinoIcons.folder_badge_plus,
            ),
            onPressed: () => debugPrint('New Folder...'),
            label: 'New Folder',
            showLabel: true,
            tooltipMessage: 'This is a beautiful tooltip',
          ),
          ToolBarIconButton(
            icon: const MacosIcon(
              CupertinoIcons.add_circled,
            ),
            onPressed: () => debugPrint('Add...'),
            label: 'Add',
            showLabel: true,
            tooltipMessage: 'This is another beautiful tooltip',
          ),
          const ToolBarSpacer(),
          ToolBarIconButton(
            label: 'Delete',
            icon: const MacosIcon(
              CupertinoIcons.trash,
            ),
            onPressed: () => debugPrint('pressed'),
            showLabel: false,
          ),
          const ToolBarIconButton(
            label: 'Change View',
            icon: MacosIcon(
              CupertinoIcons.list_bullet,
            ),
            showLabel: false,
          ),
          ToolBarPullDownButton(
            label: 'Actions',
            icon: CupertinoIcons.ellipsis_circle,
            tooltipMessage: 'Perform tasks with the selected items',
            items: [
              MacosPulldownMenuItem(
                label: 'New Folder',
                title: const Text('New Folder'),
                onTap: () => debugPrint('Creating new folder...'),
              ),
              MacosPulldownMenuItem(
                label: 'Open',
                title: const Text('Open'),
                onTap: () => debugPrint('Opening...'),
              ),
              MacosPulldownMenuItem(
                label: 'Open with...',
                title: const Text('Open with...'),
                onTap: () => debugPrint('Opening with...'),
              ),
              MacosPulldownMenuItem(
                label: 'Import from iPhone...',
                title: const Text('Import from iPhone...'),
                onTap: () => debugPrint('Importing...'),
              ),
              const MacosPulldownMenuDivider(),
              MacosPulldownMenuItem(
                label: 'Remove',
                enabled: false,
                title: const Text('Remove'),
                onTap: () => debugPrint('Deleting...'),
              ),
              MacosPulldownMenuItem(
                label: 'Move to Bin',
                title: const Text('Move to Bin'),
                onTap: () => debugPrint('Moving to Bin...'),
              ),
              const MacosPulldownMenuDivider(),
              MacosPulldownMenuItem(
                label: 'Tags...',
                title: const Text('Tags...'),
                onTap: () => debugPrint('Tags...'),
              ),
            ],
          ),
          const ToolBarDivider(),
          ToolBarIconButton(
            label: 'Table',
            icon: const MacosIcon(
              CupertinoIcons.square_grid_3x2,
            ),
            onPressed: () => debugPrint('Table...'),
            showLabel: false,
          ),
          ToolBarIconButton(
            label: 'Toggle Sidebar',
            icon: const MacosIcon(
              CupertinoIcons.sidebar_left,
            ),
            onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
            showLabel: false,
          ),
          ToolBarPullDownButton(
            label: 'Group',
            icon: CupertinoIcons.rectangle_grid_3x2,
            items: [
              MacosPulldownMenuItem(
                label: 'None',
                title: const Text('None'),
                onTap: () => debugPrint('Remove sorting'),
              ),
              const MacosPulldownMenuDivider(),
              MacosPulldownMenuItem(
                label: 'Name',
                title: const Text('Name'),
                onTap: () => debugPrint('Sorting by name'),
              ),
              MacosPulldownMenuItem(
                label: 'Kind',
                title: const Text('Kind'),
                onTap: () => debugPrint('Sorting by kind'),
              ),
              MacosPulldownMenuItem(
                label: 'Size',
                title: const Text('Size'),
                onTap: () => debugPrint('Sorting by size'),
              ),
              MacosPulldownMenuItem(
                label: 'Date Added',
                title: const Text('Date Added'),
                onTap: () => debugPrint('Sorting by date'),
              ),
            ],
          ),
          ToolBarIconButton(
            label: 'Share',
            icon: const MacosIcon(
              CupertinoIcons.share,
            ),
            onPressed: () => debugPrint('pressed'),
            showLabel: false,
          ),
        ],
      ),
      children: [
        ContentArea(
          builder: (context) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Toolbars provide convenient access to frequently used menu actions and features.',
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      const Text(
                          'There is also a variant of this widget called SliverToolBar.'),
                      const SizedBox(width: 4),
                      PushButton(
                        buttonSize: ButtonSize.small,
                        child: const Text('Check it out'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SliverToolBarPage(),
                            ),
                          );
                        },
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

class SliverToolBarPage extends StatefulWidget {
  const SliverToolBarPage({super.key});

  @override
  State<SliverToolBarPage> createState() => _SliverToolBarPageState();
}

class _SliverToolBarPageState extends State<SliverToolBarPage> {
  double toolbarOpacity = 0.9;
  bool pinned = true;
  bool floating = false;

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);
    return MacosScaffold(
      children: [
        ContentArea(
          builder: (context) {
            return CustomScrollView(
              slivers: [
                SliverToolBar(
                  pinned: pinned,
                  floating: floating,
                  title: const Text('Toolbar'),
                  titleWidth: 100.0,
                  toolbarOpacity: toolbarOpacity,
                  actions: [
                    ToolBarIconButton(
                      label: 'Pinned',
                      icon: MacosIcon(
                        pinned ? CupertinoIcons.pin_fill : CupertinoIcons.pin,
                      ),
                      showLabel: false,
                      tooltipMessage: pinned ? 'Unpin toolbar' : 'Pin toolbar',
                      onPressed: () {
                        setState(() => pinned = !pinned);
                      },
                    ),
                    CustomToolbarItem(
                      inToolbarBuilder: (context) {
                        return MacosTooltip(
                          message: 'Opacity',
                          child: MacosPulldownButtonTheme(
                            data: MacosTheme.of(context)
                                .pulldownButtonTheme
                                .copyWith(
                                  iconColor: brightness.resolve(
                                    const Color.fromRGBO(0, 0, 0, 0.5),
                                    const Color.fromRGBO(255, 255, 255, 0.5),
                                  ),
                                ),
                            child: MacosPulldownButton(
                              icon: CupertinoIcons.square_stack_3d_down_right,
                              items: [
                                MacosPulldownMenuItem(
                                  title: const Text('25%'),
                                  onTap: () {
                                    setState(() => toolbarOpacity = 0.25);
                                  },
                                ),
                                MacosPulldownMenuItem(
                                  title: const Text('50%'),
                                  onTap: () {
                                    setState(() => toolbarOpacity = 0.5);
                                  },
                                ),
                                MacosPulldownMenuItem(
                                  title: const Text('75%'),
                                  onTap: () {
                                    setState(() => toolbarOpacity = 0.75);
                                  },
                                ),
                                MacosPulldownMenuItem(
                                  title: const Text('90% (Default)'),
                                  onTap: () {
                                    setState(() => toolbarOpacity = 0.90);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    ToolBarIconButton(
                      icon: MacosIcon(
                        floating
                            ? CupertinoIcons.arrow_up_down_circle_fill
                            : CupertinoIcons.arrow_up_down_circle,
                      ),
                      tooltipMessage: floating ? 'Floating on' : 'Floating off',
                      label: floating ? 'Floating on' : 'Floating off',
                      showLabel: false,
                      onPressed: () {
                        setState(() => floating = !floating);
                      },
                    ),
                  ],
                ),
                const SliverPadding(
                  padding: EdgeInsets.all(16.0),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'SliverToolBar is similar to Flutter\'s material SliverAppBar in the sense that it can be used directly in a CustomScrollView or a NestedScrollView. It is most useful for allowing content scrolled underneath them to be slightly visible, which is an effect that can be observed in Apple\'s App Store app.',
                    ),
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Try adjusting the options for the SliverToolBar on this page by using the buttons on the toolbar itself.',
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    children: const [
                      FlutterLogo(size: 200.0),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    ...List<Widget>.generate(
                      100,
                      (index) => MacosListTile(
                        title: Text('Item $index'),
                      ),
                    ),
                  ]),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
