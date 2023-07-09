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
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
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
