import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';

const double _kSliderMinWidth = 100.0;
const double _kSliderBorderRadius = 16.0;
const double _kSliderHeight = 4.0;
const double _kContinuousThumbSize = 20;
const double _kOverallHeight = 20;
const double _kTickWidth = 2.0;
const double _kTickHeight = 8.0;

const double _kDiscreteThumbWidth = 6.0;
const double _kDiscreteThumbBorderRadius = 8;

/// {@template macosSlider}
/// A slider is a horizontal track with a control, called a thumb,
/// that people can adjust between a minimum and maximum value.
///
/// The slider doesn't maintain any state itself, instead the user is expected to
/// update this widget with a new [value] whenever the slider changes.
///
/// {@endtemplate}
class MacosSlider extends StatelessWidget {
  /// {@macro macosSlider}
  const MacosSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.discrete = false,
    this.splits = 15,
    this.min = 0.0,
    this.max = 1.0,
    this.color = CupertinoColors.systemBlue,
    this.backgroundColor = MacosColors.sliderBackgroundColor,
    this.tickBackgroundColor = MacosColors.tickBackgroundColor,
    this.thumbColor = MacosColors.sliderThumbColor,
    this.semanticLabel,
  })  : assert(value >= min && value <= max),
        assert(min < max),
        assert(splits >= 2);

  /// The value of this slider.
  ///
  /// This value must be between [min] and [max], inclusive.
  final double value;

  /// Called whenever the value of the slider changes
  final ValueChanged<double> onChanged;

  /// Whether the slider is discrete or continuous.
  ///
  /// Continuous sliders have a thumb that can be dragged anywhere along the track.
  /// Discrete sliders have a thumb that can only be dragged to the tick marks.
  ///
  /// [splits] will only be considered if this is true.
  final bool discrete;

  /// The minimum value of this slider
  final double min;

  /// The maximum value of this slider
  final double max;

  /// The number of discrete splits when using [discrete] mode.
  ///
  /// This includes the split at [min] and [max]
  final int splits;

  /// The color of the slider (the part where the thumb is sliding on) that is not
  /// considered selected.
  ///
  /// Defaults to [CupertinoColors.quaternaryLabel]
  final Color backgroundColor;

  /// The color of background ticks when using [discrete] mode.
  final Color tickBackgroundColor;

  /// The color of the slider (the part where the thumb is sliding on) that is
  /// considered selected.
  ///
  /// Defaults to [CupertinoColors.systemBlue]
  final Color color;

  /// The color of the thumb.
  final Color thumbColor;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(ObjectFlagProperty.has('onChanged', onChanged));
    properties.add(DoubleProperty('min', min));
    properties.add(DoubleProperty('max', max));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('tickBackgroundColor', tickBackgroundColor));
    properties.add(ColorProperty('thumbColor', thumbColor));
    properties
        .add(FlagProperty('discrete', value: discrete, ifTrue: 'discrete'));
    properties.add(IntProperty('splits', splits));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }

  double get _percentage {
    if (discrete) {
      final double splitPercentage = 1 / (splits - 1);
      final int splitIndex = (value / splitPercentage).round();
      return splitIndex * splitPercentage;
    } else {
      return (value - min) / (max - min);
    }
  }

  void _update(double sliderWidth, double localPosition) {
    if (discrete) {
      final double splitPercentage = 1 / (splits - 1);
      final int splitIndex = (localPosition / sliderWidth / splitPercentage)
          .round()
          .clamp(0, splits - 1);
      onChanged(splitIndex * splitPercentage);
    } else {
      final double newValue = (localPosition / sliderWidth) * (max - min) + min;
      onChanged(newValue.clamp(min, max));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      slider: true,
      label: semanticLabel,
      value: value.toStringAsFixed(2),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: _kSliderMinWidth),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            if (width.isInfinite) width = _kSliderMinWidth;

            // Padding around every element so the thumb is clickable as it never
            // leaves the edge of the stack
            double horizontalPadding;
            if (discrete) {
              horizontalPadding = _kDiscreteThumbWidth / 2;
            } else {
              horizontalPadding = _kContinuousThumbSize / 2;
            }
            width -= horizontalPadding * 2;

            return SizedBox(
              height: _kOverallHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragStart: (details) {
                  _update(width, details.localPosition.dx - horizontalPadding);
                },
                onHorizontalDragUpdate: (details) {
                  _update(width, details.localPosition.dx - horizontalPadding);
                },
                onTapDown: (details) {
                  _update(width, details.localPosition.dx - horizontalPadding);
                },
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: horizontalPadding),
                        height: _kSliderHeight,
                        width: width,
                        decoration: BoxDecoration(
                          color: MacosDynamicColor.resolve(
                            backgroundColor,
                            context,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(_kSliderBorderRadius),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: horizontalPadding),
                        height: _kSliderHeight,
                        width: width * _percentage,
                        decoration: BoxDecoration(
                          color: MacosDynamicColor.resolve(color, context),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(_kSliderBorderRadius),
                          ),
                        ),
                      ),
                    ),
                    if (discrete)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: SizedBox(
                          height: _kOverallHeight,
                          width: width,
                          child: CustomPaint(
                            size: Size(width, _kOverallHeight),
                            painter: _DiscreteTickPainter(
                              color: MacosDynamicColor.resolve(color, context),
                              backgroundColor: MacosDynamicColor.resolve(
                                backgroundColor,
                                context,
                              ),
                              selectedPercentage: _percentage,
                              ticks: splits,
                            ),
                          ),
                        ),
                      ),
                    if (!discrete)
                      Positioned(
                        left: width * _percentage - _kContinuousThumbSize / 2,
                        width: _kContinuousThumbSize * 2,
                        height: _kContinuousThumbSize,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          child: _ContinuousThumb(
                            color:
                                MacosDynamicColor.resolve(thumbColor, context),
                          ),
                        ),
                      ),
                    if (discrete)
                      Positioned(
                        left: width * _percentage - _kDiscreteThumbWidth / 2,
                        width: _kDiscreteThumbWidth * 2,
                        height: _kContinuousThumbSize,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          child: _DiscreteThumb(
                            color:
                                MacosDynamicColor.resolve(thumbColor, context),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ContinuousThumb extends StatelessWidget {
  const _ContinuousThumb({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kContinuousThumbSize,
      width: _kContinuousThumbSize,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            const BorderRadius.all(Radius.circular(_kContinuousThumbSize)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

class _DiscreteThumb extends StatelessWidget {
  const _DiscreteThumb({
    required this.color,
  });

  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kContinuousThumbSize,
      width: _kDiscreteThumbWidth,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(_kDiscreteThumbBorderRadius),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

class _DiscreteTickPainter extends CustomPainter {
  _DiscreteTickPainter({
    required this.ticks,
    required this.selectedPercentage,
    required this.backgroundColor,
    required this.color,
  });

  final int ticks;
  final double selectedPercentage;
  final Color backgroundColor;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;

    var spaceBetween = width / (ticks - 1);

    var paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    var backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < ticks; i++) {
      var x = spaceBetween * i;

      var isPastSelectedPercentage = x / width > selectedPercentage;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x - 1,
            (size.height / 2) - (_kTickHeight / 2),
            _kTickWidth,
            _kTickHeight,
          ),
          const Radius.circular(8),
        ),
        isPastSelectedPercentage ? backgroundPaint : paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DiscreteTickPainter oldDelegate) {
    return oldDelegate.ticks != ticks ||
        oldDelegate.selectedPercentage != selectedPercentage ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.color != color;
  }
}
