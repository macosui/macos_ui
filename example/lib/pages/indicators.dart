import 'package:macos_ui/macos_ui.dart';
// ignore: implementation_imports
import 'package:macos_ui/src/library.dart';

class IndicatorsPage extends StatefulWidget {
  const IndicatorsPage({Key? key}) : super(key: key);

  @override
  _IndicatorsPageState createState() => _IndicatorsPageState();
}

class _IndicatorsPageState extends State<IndicatorsPage> {
  double ratingValue = 0;
  double sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      // titleBar: const TitleBar(
      //   title: Text('macOS UI Indicators'),
      // ),
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
