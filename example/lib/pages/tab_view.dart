import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class TabViewPage extends StatefulWidget {
  const TabViewPage({Key? key}) : super(key: key);

  @override
  State<TabViewPage> createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage> {
  int activeIndex = 0;
  MacosTabPosition positionSelected = MacosTabPosition.top;
  Widget content = Container();

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
      titleBar: const TitleBar(
        title: Text('macOS Tab View'),
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    const Text('Tab View Controls Position'),
                    const SizedBox(height: 15),
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
                      width: 500,
                      height: 400,
                      position: positionSelected,
                      body: content,
                      tabs: [
                        MacosTab(
                          label: 'Sound Effects',
                          active: activeIndex == 0,
                          onTap: () {
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
                          onTap: () {
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
                          onTap: () {
                            setState(() {
                              activeIndex = 2;
                              content = const Center(
                                child: Text('Output'),
                              );
                            });
                          },
                        ),
                      ],
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
