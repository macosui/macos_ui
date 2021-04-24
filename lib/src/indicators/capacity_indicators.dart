import 'package:macos_ui/macos_ui.dart';

/// A capacity indicator illustrates the current level in
/// relation to a finite capacity. Capacity indicators are
/// often used when communicating factors like disk and
/// battery usage. Mail, for example, uses a capacity indicator
/// to show the percentage of data used in relation to an
/// email account’s quota.
///
/// There are two types of capacity indicators:
///
/// * Continuous
///
/// A horizontal translucent track that fills with a colored bar
/// to indicate the current value. Tick marks are often displayed
/// to provide context.
///
/// ![Continuous Capacity Indicator](https://developer.apple.com/design/human-interface-guidelines/macos/images/indicators-continous.png)
///
/// * Discrete
///
/// A horizontal row of separate, equally sized, rectangular segments.
/// The number of segments matches the total capacity, and the segments
/// fill completely—never partially—with color to indicate the current
/// value.
///
/// ![Discrete Capacity Indicator](https://developer.apple.com/design/human-interface-guidelines/macos/images/indicators-discrete.png)
class CapacityIndicator extends StatelessWidget {
  /// Creates a capacity indicator.
  ///
  /// [value] must be in range of 0 to 100.
  const CapacityIndicator({
    Key? key,
    required this.value,
    this.onChanged,
    this.discrete = false,
    this.splits = 10,
  })  : assert(value >= 0 && value <= 100),
        super(key: key);

  /// The current value of the indicator. Must be in range of 0 to 100.
  final double value;

  /// Called when the current value of the indicator changes.
  final ValueChanged<double>? onChanged;

  /// Whether the indicator is discrete or not
  ///
  /// ![Discrete Capacity Indicator](https://developer.apple.com/design/human-interface-guidelines/macos/images/indicators-discrete.png)
  final bool discrete;

  /// How many parts the indicator will be splitted in if [discrete]
  /// is true. Defaults to 10.
  final int splits;

  void _handleUpdate(Offset lp) {
    double value = discrete ? lp.dx / splits : lp.dx;
    if (value.isNegative)
      value = 0;
    else if (value > 100) value = 100;
    onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 100),
      child: GestureDetector(
        onPanStart: (event) => _handleUpdate(event.localPosition),
        onPanUpdate: (event) => _handleUpdate(event.localPosition),
        onPanDown: (event) => _handleUpdate(event.localPosition),
        child: discrete
            ? LayoutBuilder(builder: (context, consts) {
                double width = consts.biggest.width;
                if (width.isInfinite) width = 100;
                final splitWidth = width / splits;
                final fillToIndex = (100 - -(value - 100)) * (splits / 10);
                return SizedBox(
                  width: width,
                  child: Row(
                    children: List.generate(splits, (index) {
                      return Container(
                        padding: EdgeInsets.only(
                          right: index == splits - 1 ? 0 : 2.0,
                        ),
                        width: splitWidth,
                        child: CapacityIndicatorCell(
                          value:
                              value > 0 && fillToIndex / 10 >= index ? 100 : 0,
                        ),
                      );
                    }),
                  ),
                );
              })
            : CapacityIndicatorCell(value: value),
      ),
    );
  }
}

class CapacityIndicatorCell extends StatelessWidget {
  const CapacityIndicatorCell({
    Key? key,
    this.value = 100,
    this.color = CupertinoColors.systemGreen,
    this.borderColor = CupertinoColors.tertiaryLabel,
    this.backgroundColor = CupertinoColors.tertiarySystemGroupedBackground,
  })  : assert(value >= 0 && value <= 100),
        super(key: key);

  final Color color;
  final Color backgroundColor;
  final Color borderColor;

  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      child: CustomPaint(
        painter: _CapacityCellPainter(
          color: DynamicColorX.macosResolve(color, context),
          backgroundColor: DynamicColorX.macosResolve(backgroundColor, context),
          borderColor: DynamicColorX.macosResolve(borderColor, context),
          value: value,
        ),
      ),
    );
  }
}

class _CapacityCellPainter extends CustomPainter {
  const _CapacityCellPainter({
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
    required this.value,
  });

  final Color color;
  final Color backgroundColor;
  final Color borderColor;
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = 2.0;

    /// Draw background
    canvas.drawRRect(
      BorderRadius.circular(radius).toRRect(Offset.zero & size),
      Paint()..color = backgroundColor,
    );

    /// Draw inside
    canvas.drawRRect(
      BorderRadius.horizontal(
        left: Radius.circular(radius),
        right: value == 100 ? Radius.circular(radius) : Radius.zero,
      ).toRRect(
        Offset.zero & Size(size.width * (value / 100).clamp(0, 1), size.height),
      ),
      Paint()..color = color,
    );

    /// Draw border
    canvas.drawRRect(
      BorderRadius.circular(radius).toRRect(Offset.zero & size),
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
  }

  @override
  bool shouldRepaint(_CapacityCellPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_CapacityCellPainter oldDelegate) => false;
}
