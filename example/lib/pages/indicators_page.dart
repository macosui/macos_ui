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
  double sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Indicators'),
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
        ContentArea(builder: (context, scrollController) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            controller: scrollController,
            child: Column(
              children: [
                CapacityIndicator(
                  value: sliderValue,
                  onChanged: (v) => setState(() => sliderValue = v),
                  discrete: true,
                ),
                const SizedBox(height: 20),
                CapacityIndicator(
                  value: sliderValue,
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
        }),
      ],
    );
  }
}
