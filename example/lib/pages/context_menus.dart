import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

class ContextMenusPage extends StatefulWidget {
  const ContextMenusPage({Key? key}) : super(key: key);

  @override
  State<ContextMenusPage> createState() => _ContextMenusPageState();
}

class _ContextMenusPageState extends State<ContextMenusPage> {
  String? action;

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      onDismissed: () => setState(() => action = 'Menu was dismissed'),
      onItemSelected: (item) => setState(() {
        action = '${item.title} was selected';
        print(action);
      }),
      menuItems: [
        MenuItem(title: 'First item'),
        MenuItem(title: 'Second item'),
        MenuItem(
          title: 'Third item with submenu',
          items: [
            MenuItem(title: 'First subitem'),
            MenuItem(title: 'Second subitem'),
            MenuItem(title: 'Third subitem'),
          ],
        ),
        MenuItem(title: 'Fourth item'),
      ],
      child: MacosScaffold(
        titleBar: const TitleBar(
          title: Text('macOS Context Menus'),
        ),
        children: [
          ContentArea(
            builder: (context, scrollController) {
              return const Center(
                child: Text(
                  'Right click anywhere on this page to see a context menu',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
