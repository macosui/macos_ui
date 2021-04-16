import 'package:macos_ui/macos_ui.dart';

/// A relevance indicator communicates relevancy using a series
/// of vertical bars. It often appears in a list of search results
/// for reference when sorting and comparing multiple items.
class RelevanceIndicator extends StatelessWidget {
  /// Creates a relevance indicator.
  ///
  /// [value] must be in range of 0 to [amount]
  ///
  /// [amount] must be non-null and greater than 0
  ///
  /// [barHeight] and [barWidth] must be non-null
  const RelevanceIndicator({
    Key? key,
    required this.value,
    this.amount = 20,
    this.barHeight = 20,
    this.barWidth = 0.8,
    this.selectedColor = CupertinoColors.label,
    this.unselectedolor = CupertinoColors.secondaryLabel,
  })  : assert(value >= 0 && value <= amount),
        assert(amount > 0),
        assert(barHeight >= 0),
        assert(barWidth >= 0),
        super(key: key);

  /// The current value of the indicator. It must be in the range
  /// of 0 to [amount]
  final int value;

  /// The amount of bars the indicator will have. Defaults to 20
  final int amount;

  /// The height of each bar. Defaults to 20px
  final double barHeight;

  /// The width of each bar. Defaults to 0.8px
  final double barWidth;

  /// The color of each bar when it's selected. [CupertinoColors.label]
  /// is used by default
  final Color selectedColor;

  /// The color of each bar when it's not selected. [CupertinoColors.secondaryLabel]
  /// is used by default
  final Color unselectedolor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(amount, (index) {
        final selected = value > index;
        return Container(
          height: barHeight,
          width: barWidth,
          margin: EdgeInsets.only(right: index + 1 == amount ? 0 : 2.5),
          color: CupertinoDynamicColor.resolve(
            selected ? selectedColor : unselectedolor,
            context,
          ),
        );
      }),
    );
  }
}
