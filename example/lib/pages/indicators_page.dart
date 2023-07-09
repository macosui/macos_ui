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
                children: [
                  CapacityIndicator(
                    value: capacitorValue,
                    onChanged: (v) => setState(() => capacitorValue = v),
                    splits: 20,
                    discrete: true,
                  ),
                  const SizedBox(height: 20),
                  CapacityIndicator(
                    value: capacitorValue,
                    onChanged: (v) => setState(() => capacitorValue = v),
                  ),
                  const SizedBox(height: 20),
                  MacosSlider(
                    value: sliderValue,
                    onChanged: (v) => setState(() => sliderValue = v),
                  ),
                  const SizedBox(height: 20),
                  MacosSlider(
                    value: sliderValue,
                    discrete: true,
                    onChanged: (v) => setState(() => sliderValue = v),
                  ),
                  const SizedBox(height: 20),
                  RatingIndicator(
                    value: ratingValue,
                    onChanged: (v) => setState(() => ratingValue = v),
                  ),
                  const SizedBox(height: 20),
                  const ProgressCircle(),
                  const SizedBox(height: 20),
                  const RelevanceIndicator(
                    value: 25,
                    amount: 50,
                  ),
                  const SizedBox(height: 20),
                  const Label(
                    icon: MacosIcon(CupertinoIcons.tag),
                    text: SelectableText('A determinate progress circle: '),
                    child: ProgressCircle(value: 50),
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
