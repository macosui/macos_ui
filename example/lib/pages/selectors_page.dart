import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class SelectorsPage extends StatefulWidget {
  const SelectorsPage({super.key});

  @override
  State<SelectorsPage> createState() => _SelectorsPageState();
}

class _SelectorsPageState extends State<SelectorsPage> {
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
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MacosDatePicker(
                        onDateChanged: (date) => debugPrint('$date'),
                      ),
                      MacosTimePicker(
                        onTimeChanged: (time) => debugPrint('$time'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  MacosColorWell(
                    onColorSelected: (color) => debugPrint('$color'),
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
