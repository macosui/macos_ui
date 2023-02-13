import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const double _kCapacityIndicatorMinWidth = 100.0;

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
    super.key,
    required this.value,
    this.onChanged,
    this.discrete = false,
    this.splits = 10,
    this.color = CupertinoColors.systemGreen,
    this.borderColor = CupertinoColors.tertiaryLabel,
    this.backgroundColor = CupertinoColors.tertiarySystemGroupedBackground,
    this.semanticLabel,
  }) : assert(value >= 0 && value <= 100);

  /// The current value of the indicator. Must be in the range of 0 to 100.
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

  /// The color to fill the cells. [CupertinoColors.systemGreen] is
  /// used by default.
  final Color color;

  /// The background color of the cells. [CupertinoColors.tertiarySystemGroupedBackground]
  /// is used by default
  final Color backgroundColor;

  /// The border color of the cells. [CupertinoColors.tertiaryLabel]
  /// is used by default
  final Color borderColor;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(ObjectFlagProperty.has('onChanged', onChanged));
    properties
        .add(FlagProperty('discrete', value: discrete, ifFalse: 'continuous'));
    properties.add(IntProperty('splits', splits));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('borderColor', borderColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }

  void _handleUpdate(Offset lp, double width) {
    double value = (lp.dx / width) * 100 / splits;
    onChanged?.call(value.clamp(0.0, 100.0));
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      slider: true,
      label: semanticLabel,
      value: value.toStringAsFixed(2),
      child: Container(
        constraints:
            const BoxConstraints(minWidth: _kCapacityIndicatorMinWidth),
        child: LayoutBuilder(builder: (context, consts) {
          double width = consts.maxWidth;
          if (width.isInfinite) width = 100;
          final splitWidth = width / splits;
          if (discrete) {
            final fillToIndex = (value / 100) * splits - 1;
            return SizedBox(
              width: width,
              child: GestureDetector(
                onPanStart: (event) =>
                    _handleUpdate(event.localPosition, splitWidth),
                onPanUpdate: (event) =>
                    _handleUpdate(event.localPosition, splitWidth),
                onPanDown: (event) =>
                    _handleUpdate(event.localPosition, splitWidth),
                child: Row(
                  children: List.generate(splits, (index) {
                    return Container(
                      padding: EdgeInsets.only(
                        right: index == splits - 1 ? 0 : 2.0,
                      ),
                      width: splitWidth,
                      child: CapacityIndicatorCell(
                        value: value > 0 && fillToIndex >= index ? 100 : 0,
                        backgroundColor: backgroundColor,
                        borderColor: borderColor,
                        color: color,
                      ),
                    );
                  }),
                ),
              ),
            );
          } else {
            return SizedBox(
              width: width,
              child: GestureDetector(
                onPanStart: (event) =>
                    _handleUpdate(event.localPosition, splitWidth),
                onPanUpdate: (event) =>
                    _handleUpdate(event.localPosition, splitWidth),
                onPanDown: (event) =>
                    _handleUpdate(event.localPosition, splitWidth),
                child: CapacityIndicatorCell(
                  value: value,
                  backgroundColor: backgroundColor,
                  borderColor: borderColor,
                  color: color,
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}

/// The cell [CapacityIndicator] uses to draw itself.
class CapacityIndicatorCell extends StatelessWidget {
  /// Creates a capacity indicator cell.
  ///
  /// [value] must be in the range of 0 to 100
  const CapacityIndicatorCell({
    super.key,
    this.value = 100,
    this.color = CupertinoColors.systemGreen,
    this.borderColor = CupertinoColors.tertiaryLabel,
    this.backgroundColor = CupertinoColors.tertiarySystemGroupedBackground,
  }) : assert(value >= 0 && value <= 100);

  /// The color of the cell.
  final Color color;

  /// The background color of the cell.
  final Color backgroundColor;

  /// The border color of the cell.
  final Color borderColor;

  /// The current value of the cell.
  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: CustomPaint(
        painter: _CapacityCellPainter(
          color: MacosDynamicColor.resolve(color, context),
          backgroundColor: MacosDynamicColor.resolve(backgroundColor, context),
          borderColor: MacosDynamicColor.resolve(borderColor, context),
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
    const radius = 2.0;

    /// Draw background
    canvas.drawRRect(
      BorderRadius.circular(radius).toRRect(Offset.zero & size),
      Paint()..color = backgroundColor,
    );

    /// Draw inside
    canvas.drawRRect(
      BorderRadius.horizontal(
        left: const Radius.circular(radius),
        right: value == 100 ? const Radius.circular(radius) : Radius.zero,
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
