import 'package:example/widgets/widget_text_title1.dart';
import 'package:example/widgets/widget_text_title2.dart';
import 'package:macos_ui/macos_ui.dart';
// ignore: implementation_imports
import 'package:macos_ui/src/library.dart';

class IndicatorsPage extends StatefulWidget {
  const IndicatorsPage({super.key});

  @override
  State<IndicatorsPage> createState() => _IndicatorsPageState();
}

class _IndicatorsPageState extends State<IndicatorsPage> {
  double ratingValue = 0;
  double capacitorValue = 0;
  double sliderValue = 0.3;

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Indicators'),
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WidgetTextTitle1(widgetName: 'CapacityIndicator'),
                  Divider(color: MacosTheme.of(context).dividerColor),
                  Row(
                    children: [
                      const Text('Standard'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CapacityIndicator(
                          value: capacitorValue,
                          onChanged: (v) => setState(() => capacitorValue = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Discrete'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CapacityIndicator(
                          value: capacitorValue,
                          onChanged: (v) => setState(() => capacitorValue = v),
                          splits: 20,
                          discrete: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const WidgetTextTitle1(widgetName: 'MacosSlider'),
                  Divider(color: MacosTheme.of(context).dividerColor),
                  Row(
                    children: [
                      const Text('Standard'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MacosSlider(
                          value: sliderValue,
                          onChanged: (v) => setState(() => sliderValue = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Discrete'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MacosSlider(
                          value: sliderValue,
                          discrete: true,
                          onChanged: (v) => setState(() => sliderValue = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const WidgetTextTitle1(widgetName: 'RatingIndicator'),
                  Divider(color: MacosTheme.of(context).dividerColor),
                  RatingIndicator(
                    value: ratingValue,
                    onChanged: (v) => setState(() => ratingValue = v),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Progress Indicators',
                    style: MacosTypography.of(context).title1,
                  ),
                  Divider(color: MacosTheme.of(context).dividerColor),
                  const WidgetTextTitle2(widgetName: 'ProgressBar'),
                  const SizedBox(height: 8),
                  const ProgressBar(value: 50),
                  const SizedBox(height: 16),
                  const WidgetTextTitle2(widgetName: 'ProgressCircle'),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Text('Indeterminate'),
                      SizedBox(width: 8),
                      ProgressCircle(),
                    ],
                  ),
                  const Row(
                    children: [
                      Text('Determinate'),
                      SizedBox(width: 8),
                      ProgressCircle(value: 50),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const WidgetTextTitle1(widgetName: 'RelevanceIndicator'),
                  Divider(color: MacosTheme.of(context).dividerColor),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
