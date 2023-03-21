import 'dart:math' as math;

import 'package:flutter/cupertino.dart' as c;
import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A [ProgressCircle] that shows progress in a circular form, either as a
/// spinner or as a circle that fills in as progress continues.
class ProgressCircle extends StatelessWidget {
  /// Creates a new progress circle.
  ///
  /// [radius] must be non-negative
  ///
  /// [value] must be in the range of 0 and 100
  const ProgressCircle({
    super.key,
    this.value,
    this.radius = 10,
    this.innerColor,
    this.borderColor,
    this.semanticLabel,
  })  : assert(value == null || value >= 0 && value <= 100),
        assert(radius >= 0);

  /// The value of the progress circle. If non-null, this has to
  /// be non-negative and less the 100. If null, the progress circle
  /// will be considered indeterminate, backed by [c.CupertinoActivityIndicator]
  final double? value;

  /// The radius of the progress circle. Defaults to 10px
  final double radius;

  /// The color of the circle at the middle. If null,
  /// [CupertinoColors.secondarySystemFill] is used
  final Color? innerColor;

  /// The color of the border. If null, [CupertinoColors.secondarySystemFill]
  /// is used
  final Color? borderColor;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  /// Whether the progress circle is determinate or not
  bool get isDeterminate => value != null;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(DoubleProperty('radius', radius));
    properties.add(ColorProperty('innerColor', innerColor));
    properties.add(ColorProperty('borderColor', borderColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties.add(FlagProperty(
      'determinate',
      value: isDeterminate,
      ifFalse: 'indeterminate',
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (isDeterminate) {
      return Semantics(
        label: semanticLabel,
        value: value!.toStringAsFixed(2),
        child: SizedBox(
          height: radius * 2,
          width: radius * 2,
          child: CustomPaint(
            painter: _DeterminateCirclePainter(
              value!,
              innerColor: MacosDynamicColor.resolve(
                innerColor ?? CupertinoColors.secondarySystemFill,
                context,
              ),
              borderColor: MacosDynamicColor.resolve(
                borderColor ?? CupertinoColors.secondarySystemFill,
                context,
              ),
            ),
          ),
        ),
      );
    } else {
      return Semantics(
        label: semanticLabel,
        child: c.CupertinoActivityIndicator(
          radius: radius,
        ),
      );
    }
  }
}

class _DeterminateCirclePainter extends CustomPainter {
  const _DeterminateCirclePainter(
    this.value, {
    this.innerColor,
    this.borderColor,
  });

  final double value;
  final Color? innerColor;
  final Color? borderColor;

  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = 0.001;
  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    /// Draw an arc
    void drawArc(
      double value, {
      Paint? paint,
      bool useCenter = true,
    }) {
      canvas.drawArc(
        Offset.zero & size,
        _startAngle,
        (value / 100).clamp(0, 1) * _sweep,
        useCenter,
        paint ?? Paint()
          ..color = innerColor ?? CupertinoColors.activeBlue,
      );
    }

    // Draw the inner circle
    drawArc(value);

    /// Draw the border
    drawArc(
      100,
      useCenter: false,
      paint: Paint()
        ..color = borderColor ?? CupertinoColors.activeBlue
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_DeterminateCirclePainter old) => value != old.value;

  @override
  bool shouldRebuildSemantics(_DeterminateCirclePainter oldDelegate) => false;
}

/// A [ProgressBar] that shows progress in a horizontal bar.
class ProgressBar extends StatelessWidget {
  /// Creates a new progress bar
  ///
  /// [height] more be non-negative
  ///
  /// [value] must be in the range of 0 and 100
  const ProgressBar({
    super.key,
    this.height = 4.5,
    required this.value,
    this.trackColor,
    this.backgroundColor,
    this.semanticLabel,
  })  : assert(value >= 0 && value <= 100),
        assert(height >= 0);

  /// The value of the progress bar. If non-null, this has to
  /// be non-negative and less the 100. If null, the progress bar
  /// will be considered indeterminate.
  final double value;

  /// The height of the line. Default to 4.5px
  final double height;

  /// The color of the track. If null, [MacosThemeData.accentColor] is used
  final Color? trackColor;

  /// The color of the background. If null, [CupertinoColors.secondarySystemFill]
  /// is used
  final Color? backgroundColor;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(DoubleProperty('height', height));
    properties.add(ColorProperty('trackColor', trackColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final MacosThemeData theme = MacosTheme.of(context);
    return Semantics(
      label: semanticLabel,
      value: value.toStringAsFixed(2),
      child: Container(
        constraints: BoxConstraints(
          minHeight: height,
          maxHeight: height,
          minWidth: 85,
        ),
        child: CustomPaint(
          painter: _DeterminateBarPainter(
            value,
            activeColor: MacosDynamicColor.resolve(
              trackColor ?? theme.primaryColor,
              context,
            ),
            backgroundColor: MacosDynamicColor.resolve(
              backgroundColor ?? CupertinoColors.secondarySystemFill,
              context,
            ),
          ),
        ),
      ),
    );
  }
}

class _DeterminateBarPainter extends CustomPainter {
  const _DeterminateBarPainter(
    this.value, {
    this.backgroundColor,
    this.activeColor,
  });

  final double value;
  final Color? backgroundColor;
  final Color? activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the background line
    canvas.drawRRect(
      const BorderRadius.all(Radius.circular(100)).toRRect(
        Offset.zero & size,
      ),
      Paint()
        ..color = backgroundColor ?? CupertinoColors.secondarySystemFill
        ..style = PaintingStyle.fill,
    );

    // Draw the active tick line
    canvas.drawRRect(
      const BorderRadius.horizontal(left: Radius.circular(100)).toRRect(
        Offset.zero &
            Size(
              (value / 100).clamp(0.0, 1.0) * size.width,
              size.height,
            ),
      ),
      Paint()
        ..color = activeColor ?? CupertinoColors.activeBlue
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_DeterminateBarPainter old) => old.value != value;

  @override
  bool shouldRebuildSemantics(_DeterminateBarPainter oldDelegate) => false;
}
