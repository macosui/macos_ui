import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

import 'package:flutter/widgets.dart';

class IndicatorsPage extends StatefulWidget {
  @override
  _IndicatorsPageState createState() => _IndicatorsPageState();
}

class _IndicatorsPageState extends State<IndicatorsPage> {
  double ratingValue = 0;
  double sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CapacityIndicator(
            value: sliderValue,
            onChanged: (v) => setState(() => sliderValue = v),
            discrete: true,
          ),
          SizedBox(height: 20),
          CapacityIndicator(
            value: sliderValue,
            onChanged: (v) => setState(() => sliderValue = v),
          ),
          SizedBox(height: 20),
          RatingIndicator(
            value: ratingValue,
            onChanged: (v) => setState(() => ratingValue = v),
          ),
          SizedBox(height: 20),
          ProgressCircle(),
          SizedBox(height: 20),
          RelevanceIndicator(
            value: 25,
            amount: 50,
          ),
          SizedBox(height: 20),
          Label(
            icon: Icon(CupertinoIcons.tag),
            text: SelectableText('A determinate progress circle: '),
            child: ProgressCircle(value: 50),
          ),
        ],
      ),
    );
  }
}
