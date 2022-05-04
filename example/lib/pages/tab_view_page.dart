import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class TabViewPage extends StatefulWidget {
  const TabViewPage({Key? key}) : super(key: key);

  @override
  State<TabViewPage> createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage> {
  int activeIndex = 0;
  MacosTabPosition positionSelected = MacosTabPosition.top;
  Widget content = const SizedBox.shrink();

  void updatePosition(MacosTabPosition? pos) {
    return setState(() => positionSelected = pos ?? MacosTabPosition.top);
  }

  Widget _radioButton(MacosTabPosition pos) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MacosRadioButton<MacosTabPosition>(
            groupValue: positionSelected,
            value: pos,
            onChanged: updatePosition,
          ),
          const SizedBox(width: 10),
          Text(pos.name),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Selectors'),
        titleWidth: 150.0,
        actions: [
          ToolBarIconButton(
            label: 'Toggle Sidebar',
            icon: const MacosIcon(
              CupertinoIcons.sidebar_left,
            ),
            onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
            showLabel: false,
          ),
        ],
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  children: [
                    const Text('Tab View Controls Position'),
                    const SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _radioButton(MacosTabPosition.top),
                        _radioButton(MacosTabPosition.bottom),
                        _radioButton(MacosTabPosition.left),
                        _radioButton(MacosTabPosition.right),
                      ],
                    ),
                    const SizedBox(height: 30),
                    MacosTabView(
                      position: positionSelected,
                      currentIndex: activeIndex,
                      tabs: [
                        MacosTab(
                          label: 'Sound Effects',
                          active: activeIndex == 0,
                          onClick: () {
                            setState(() {
                              activeIndex = 0;
                              content = const Center(
                                child: Text('Sound Effects'),
                              );
                            });
                          },
                        ),
                        MacosTab(
                          label: 'Input',
                          active: activeIndex == 1,
                          onClick: () {
                            setState(() {
                              activeIndex = 1;
                              content = const Center(
                                child: Text('Input'),
                              );
                            });
                          },
                        ),
                        MacosTab(
                          label: 'Output',
                          active: activeIndex == 2,
                          onClick: () {
                            setState(() {
                              activeIndex = 2;
                              content = const Center(
                                child: Text('Output'),
                              );
                            });
                          },
                        ),
                        MacosTab(
                          label: 'Item 3',
                          active: activeIndex == 3,
                          onClick: () {
                            setState(() {
                              activeIndex = 3;
                              content = const Center(
                                child: Text('Item 3'),
                              );
                            });
                          },
                        ),
                      ],
                      width: 500,
                      height: 400,
                      body: content,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
