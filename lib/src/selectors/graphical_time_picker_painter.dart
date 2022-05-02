import 'dart:math';

import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/macos_colors.dart';

class GraphicalTimePickerPainter extends CustomPainter {
  GraphicalTimePickerPainter({
    required this.clockHeight,
    required this.time,
    required this.dayPeriod,
    required this.backgroundColor,
    required this.hourHandColor,
    required this.minuteHandColor,
    required this.secondHandColor,
    required this.dayPeriodTextColor,
    required this.outerBorderColor,
  });

  final double clockHeight;
  final DateTime time;
  final String dayPeriod;
  final Color backgroundColor;
  final Color hourHandColor;
  final Color minuteHandColor;
  final Color secondHandColor;
  final Color dayPeriodTextColor;
  final Color outerBorderColor;

  static const double handPinHoleSize = 3.0;
  static const double strokeWidth = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleFactor = size.shortestSide / clockHeight;
    _paintClockBorder(canvas, size);
    _paintBackgroundColor(canvas, size);
    _paintInnerShadow(canvas, size);
    //_paintLightInnerShadow(canvas, size);
    _paintDayPeriod(canvas, size);
    _paintHours(canvas, size, scaleFactor);
    _paintPinHole(canvas, size);
    _paintClockHands(canvas, size, scaleFactor);
  }

  @override
  bool shouldRepaint(GraphicalTimePickerPainter oldDelegate) {
    return true;
  }

  void _paintPinHole(Canvas canvas, Size size) {
    Paint pinHolePainter = Paint()
      ..color = MacosColors.black
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      size.center(Offset.zero),
      handPinHoleSize,
      pinHolePainter,
    );
  }

  Offset _getHandOffset(double percentage, double length) {
    final radians = 2 * pi * percentage;
    final angle = -pi / 2.0 + radians;

    return Offset(length * cos(angle), length * sin(angle));
  }

  void _paintClockBorder(Canvas canvas, Size size) {
    Paint clockBorderPainter = Paint()
      ..color = outerBorderColor
      ..strokeWidth = 12.0
      ..isAntiAlias = true
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.bottomLeft,
        colors: [
          outerBorderColor,
          const MacosColor(0xFF767574),
        ],
      ).createShader(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: clockHeight / 2,
        ),
      )
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      size.center(Offset.zero),
      size.shortestSide / 2.0,
      clockBorderPainter,
    );
  }

  void _paintBackgroundColor(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      size.center(Offset.zero),
      clockHeight / 2,
      backgroundPaint,
    );
  }

  void _paintInnerShadow(Canvas canvas, Size size) {
    Paint innerShadowPainter = Paint()
      ..strokeWidth = 2.0
      ..isAntiAlias = true
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.bottomLeft,
        stops: [0.0, 0.5],
        colors: [
          MacosColor(0xFFA3A4A5),
          MacosColors.white,
        ],
      ).createShader(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: clockHeight / 2,
        ),
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 1.0)
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      size.center(Offset.zero),
      size.shortestSide / 2.0,
      innerShadowPainter,
    );
  }

  void _paintClockHands(Canvas canvas, Size size, double scaleFactor) {
    double r = size.shortestSide / 2;
    double p = 0.0;
    double hourHandLength = r - (p + 22.0) * scaleFactor;
    double minuteHandLength = r - (p * scaleFactor) - 3.0;
    double secondHandLength = r - (p * scaleFactor) - 2.0;

    Paint handPaint = Paint()
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
      handPaint..color = hourHandColor,
    );

    // Draw minute hand
    canvas.drawLine(
      size.center(_getHandOffset(minutes, handPinHoleSize * scaleFactor)),
      size.center(_getHandOffset(minutes, minuteHandLength)),
      handPaint..color = minuteHandColor,
    );

    // Draw second hand
    canvas.drawLine(
      size.center(_getHandOffset(seconds, handPinHoleSize * scaleFactor)),
      size.center(_getHandOffset(seconds, secondHandLength)),
      handPaint
        ..color = secondHandColor
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.square,
    );

    final secondHandPinPaint = Paint()
      ..color = secondHandColor
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
        ..color = secondHandColor
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.square,
    );
  }

  void _paintDayPeriod(Canvas canvas, Size size) {
    TextStyle style = TextStyle(
      color: dayPeriodTextColor,
      fontSize: 13.0,
    );
    TextSpan span = TextSpan(
      style: style,
      text: dayPeriod,
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(
      canvas,
      size.center(const Offset(0.0, 20.0) - tp.size.center(Offset.zero)),
    );
  }

  void _paintHours(
    Canvas canvas,
    Size size,
    double scaleFactor,
  ) {
    TextStyle style = const TextStyle(
      color: MacosColors.black,
      fontWeight: FontWeight.w400,
      fontSize: 13.0,
    );
    double distanceFromBorder = 10.0;

    double r = size.shortestSide / 2;
    double longHandLength = r - (distanceFromBorder * scaleFactor);

    for (var h = 1; h <= 12; h++) {
      double angle = (h * pi / 6) - pi / 2;
      Offset offset = Offset(
        longHandLength * cos(angle),
        longHandLength * sin(angle),
      );
      TextSpan span = TextSpan(style: style, text: h.toString());
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, size.center(offset - tp.size.center(Offset.zero)));
    }
  }
}
