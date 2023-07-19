import 'package:example/widgets/widget_text_title1.dart';
import 'package:example/widgets/widget_text_title2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date & Time Pickers',
                    style: MacosTypography.of(context).title1,
                  ),
                  Divider(color: MacosTheme.of(context).dividerColor),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const WidgetTextTitle2(widgetName: 'MacosDatePicker'),
                          const SizedBox(height: 12),
                          MacosDatePicker(
                            onDateChanged: (date) => debugPrint('$date'),
                          ),
                        ],
                      ),
                      const SizedBox(width: 50),
                      Column(
                        children: [
                          const WidgetTextTitle2(widgetName: 'MacosTimePicker'),
                          const SizedBox(height: 12),
                          MacosTimePicker(
                            onTimeChanged: (time) => debugPrint('$time'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (!kIsWeb) ...[
                    const WidgetTextTitle1(widgetName: 'MacosColorWell'),
                    Divider(color: MacosTheme.of(context).dividerColor),
                    MacosColorWell(
                      onColorSelected: (color) => debugPrint('$color'),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
