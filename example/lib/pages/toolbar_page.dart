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
            onPressed: () => debugPrint("New Folder..."),
            label: "New Folder",
            showLabel: true,
            tooltipMessage: "This is a beautiful tooltip",
          ),
          ToolBarIconButton(
            icon: const MacosIcon(
              CupertinoIcons.add_circled,
            ),
            onPressed: () => debugPrint("Add..."),
            label: "Add",
            showLabel: true,
            tooltipMessage: "This is another beautiful tooltip",
          ),
          const ToolBarSpacer(),
          ToolBarIconButton(
            label: "Delete",
            icon: const MacosIcon(
              CupertinoIcons.trash,
            ),
            onPressed: () => debugPrint("pressed"),
            showLabel: false,
          ),
          const ToolBarIconButton(
            label: "Change View",
            icon: MacosIcon(
              CupertinoIcons.list_bullet,
            ),
            showLabel: false,
          ),
          ToolBarPullDownButton(
            label: "Actions",
            icon: CupertinoIcons.ellipsis_circle,
            tooltipMessage: "Perform tasks with the selected items",
            items: [
              MacosPulldownMenuItem(
                label: "New Folder",
                title: const Text("New Folder"),
                onTap: () => debugPrint("Creating new folder..."),
              ),
              MacosPulldownMenuItem(
                label: "Open",
                title: const Text("Open"),
                onTap: () => debugPrint("Opening..."),
              ),
              MacosPulldownMenuItem(
                label: "Open with...",
                title: const Text('Open with...'),
                onTap: () => debugPrint("Opening with..."),
              ),
              MacosPulldownMenuItem(
                label: "Import from iPhone...",
                title: const Text('Import from iPhone...'),
                onTap: () => debugPrint("Importing..."),
              ),
              const MacosPulldownMenuDivider(),
              MacosPulldownMenuItem(
                label: "Remove",
                enabled: false,
                title: const Text('Remove'),
                onTap: () => debugPrint("Deleting..."),
              ),
              MacosPulldownMenuItem(
                label: "Move to Bin",
                title: const Text('Move to Bin'),
                onTap: () => debugPrint("Moving to Bin..."),
              ),
              const MacosPulldownMenuDivider(),
              MacosPulldownMenuItem(
                label: "Tags...",
                title: const Text('Tags...'),
                onTap: () => debugPrint("Tags..."),
              ),
            ],
          ),
          const ToolBarDivider(),
          ToolBarIconButton(
            label: "Table",
            icon: const MacosIcon(
              CupertinoIcons.square_grid_3x2,
            ),
            onPressed: () => debugPrint("Table..."),
            showLabel: false,
          ),
          ToolBarIconButton(
            label: "Toggle Sidebar",
            icon: const MacosIcon(
              CupertinoIcons.sidebar_left,
            ),
            onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
            showLabel: false,
          ),
          ToolBarPullDownButton(
            label: "Group",
            icon: CupertinoIcons.rectangle_grid_3x2,
            items: [
              MacosPulldownMenuItem(
                label: "None",
                title: const Text('None'),
                onTap: () => debugPrint("Remove sorting"),
              ),
              const MacosPulldownMenuDivider(),
              MacosPulldownMenuItem(
                label: "Name",
                title: const Text('Name'),
                onTap: () => debugPrint("Sorting by name"),
              ),
              MacosPulldownMenuItem(
                label: "Kind",
                title: const Text('Kind'),
                onTap: () => debugPrint("Sorting by kind"),
              ),
              MacosPulldownMenuItem(
                label: "Size",
                title: const Text('Size'),
                onTap: () => debugPrint("Sorting by size"),
              ),
              MacosPulldownMenuItem(
                label: "Date Added",
                title: const Text('Date Added'),
                onTap: () => debugPrint("Sorting by date"),
              ),
            ],
          ),
          ToolBarIconButton(
            label: "Share",
            icon: const MacosIcon(
              CupertinoIcons.share,
            ),
            onPressed: () => debugPrint("pressed"),
            showLabel: false,
          ),
        ],
      ),
      children: [
        ContentArea(builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(30),
            child: Center(
              child: Column(
                children: const [
                  Text(
                    "The toolbar appears below the title bar of the macOS app or integrates with it.",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "It provides convenient access to frequently used commands and features.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
