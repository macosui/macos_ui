import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class TabViewPage extends StatefulWidget {
  const TabViewPage({super.key});

  @override
  State<TabViewPage> createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage> {
  final _controller = MacosTabController(
    initialIndex: 0,
    length: 3,
  );

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('TabView'),
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: MacosTabView(
                controller: _controller,
                tabs: const [
                  MacosTab(
                    label: 'Tab 1',
                  ),
                  MacosTab(
                    label: 'Tab 2',
                  ),
                  MacosTab(
                    label: 'Tab 3',
                  ),
                ],
                children: const [
                  Center(
                    child: Text('Tab 1'),
                  ),
                  Center(
                    child: Text('Tab 2'),
                  ),
                  Center(
                    child: Text('Tab 3'),
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
