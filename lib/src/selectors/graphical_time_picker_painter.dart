import 'dart:math';

import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// {@template graphicalTimePickerPainter}
/// A [CustomPainter] that recreates the native macOS graphical time picker.
/// {@endtemplate}
class GraphicalTimePickerPainter extends CustomPainter {
  /// {@macro graphicalTimePickerPainter}
  GraphicalTimePickerPainter({
    required this.clockHeight,
    required this.time,
    required this.dayPeriod,
    required this.theme,
  });

  /// The height of the clock.
  final double clockHeight;

  /// The time to display.
  final DateTime time;

  /// The day period to display (AM/PM).
  final String dayPeriod;

  /// The theme to use.
  final MacosTimePickerThemeData theme;

  static const double handPinHoleSize = 3.0;
  static const double strokeWidth = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleFactor = size.shortestSide / clockHeight;
    _paintBaseClock(canvas, size);
    _paintDayPeriod(canvas, size);
    _paintHours(canvas, size, scaleFactor);
    _paintPinHole(canvas, size);
    _paintClockHands(canvas, size, scaleFactor);
  }

  @override
  bool shouldRepaint(GraphicalTimePickerPainter oldDelegate) {
    return true;
  }

  Offset _getHandOffset(double percentage, double length) {
    final radians = 2 * pi * percentage;
    final angle = -pi / 2.0 + radians;

    return Offset(length * cos(angle), length * sin(angle));
  }

  /// Paints the clock border, inner shadow, and background
  void _paintBaseClock(Canvas canvas, Size size) {
    //---Border---//
    const borderWidth = 5.0;
    final center = size.center(Offset.zero);
    final radius1 = size.shortestSide / 2.0;
    final radius2 = radius1 - borderWidth;
    final rect1 = Rect.fromCircle(center: center, radius: radius1);
    final rect2 = Rect.fromCircle(center: center, radius: radius2);
    final shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        theme.clockViewBorderColor!,
        Color.alphaBlend(
          const MacosColor(0xFF767574),
          theme.clockViewBorderColor!,
        ),
      ],
    ).createShader(rect1);
    // Draw the border
    canvas.drawOval(rect1, Paint()..shader = shader);

    //---Background---//
    canvas.drawOval(rect2, Paint()..color = theme.clockViewBackgroundColor!);

    //---Inner shadow---//
    const blurRadius = 3.0;
    final shadowPainter = Paint()
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        blurRadius,
      )
      ..color = MacosColors.black;
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(
        const EdgeInsets.all(blurRadius)
            .copyWith(bottom: -rect2.height / 2)
            .inflateRect(rect2),
      )
      ..addArc(
        const EdgeInsets.symmetric(horizontal: blurRadius).inflateRect(rect2),
        pi,
        pi,
      );
    canvas.clipPath(Path()..addOval(rect2));
    canvas.drawPath(path, shadowPainter);
    canvas.drawPath(path, shadowPainter);
  }

  void _paintDayPeriod(Canvas canvas, Size size) {
    TextStyle style = TextStyle(
      color: theme.dayPeriodTextColor,
      fontSize: 13.0,
    );
    TextSpan span = TextSpan(
      style: style,
      text: dayPeriod,
    );
    TextPainter periodPainter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    periodPainter.layout();
    periodPainter.paint(
      canvas,
      size.center(
        const Offset(0.0, 20.0) - periodPainter.size.center(Offset.zero),
      ),
    );
  }

  void _paintHours(
    Canvas canvas,
    Size size,
    double scaleFactor,
  ) {
    TextStyle style = const TextStyle(
      color: MacosColors.black,
      fontWeight: FontWeight.w300,
      fontSize: 13.0,
    );
    double distanceFromBorder = 16.0;

    double radius = size.shortestSide / 2;
    double longHandLength = radius - (distanceFromBorder * scaleFactor);

    for (var hour = 1; hour <= 12; hour++) {
      double angle = (hour * pi / 6) - pi / 2;
      Offset offset = Offset(
        longHandLength * cos(angle),
        longHandLength * sin(angle),
      );
      TextSpan span = TextSpan(style: style, text: hour.toString());
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, size.center(offset - tp.size.center(Offset.zero)));
    }
  }

  void _paintPinHole(Canvas canvas, Size size) {
    final pinHolePainter = Paint()
      ..color = MacosColors.black
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      size.center(Offset.zero),
      handPinHoleSize,
      pinHolePainter,
    );
  }

  void _paintClockHands(Canvas canvas, Size size, double scaleFactor) {
    double r = size.shortestSide / 2;
    double p = 0.0;
    double hourHandLength = r - (p + 26.0) * scaleFactor;
    double minuteHandLength = r - (p * scaleFactor) - 9.5;
    double secondHandLength = r - (p * scaleFactor) - 8.0;

    final handPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.bevel
      ..strokeWidth = strokeWidth * scaleFactor;
    double seconds = time.second / 60.0;
    double minutes = (time.minute + seconds) / 60.0;
    double hour = (time.hour + minutes) / 12.0;

    // Draw hour hand
    canvas.drawLine(
      size.center(_getHandOffset(hour, handPinHoleSize * scaleFactor)),
      size.center(_getHandOffset(hour, hourHandLength)),
      handPaint..color = theme.hourHandColor!,
    );

    // Draw minute hand
    canvas.drawLine(
      size.center(_getHandOffset(minutes, handPinHoleSize * scaleFactor)),
      size.center(_getHandOffset(minutes, minuteHandLength)),
      handPaint..color = theme.minuteHandColor!,
    );

    // Draw second hand
    canvas.drawLine(
      size.center(_getHandOffset(seconds, handPinHoleSize * scaleFactor)),
      size.center(_getHandOffset(seconds, secondHandLength)),
      handPaint
        ..color = theme.secondHandColor!
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.square,
    );

    final secondHandPinPaint = Paint()
      ..color = theme.secondHandColor!
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    // Draw second hand pin hole
    canvas.drawCircle(
      size.center(Offset.zero),
      2.0,
      secondHandPinPaint,
    );

    // Draw second hand tail
    canvas.drawLine(
      size.center(Offset.zero),
      size.center(_getHandOffset(seconds, -6.3)),
      handPaint
        ..color = theme.secondHandColor!
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.square,
    );
  }
}
