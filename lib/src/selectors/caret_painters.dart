import 'package:flutter/widgets.dart';

const _buttonRadius = 5.0;

class DownCaretPainter extends CustomPainter {
  const DownCaretPainter({
    required this.color,
    required this.backgroundColor,
  });

  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final hPadding = size.height / 3;

    /// Draw background
    canvas.drawRRect(
      const BorderRadius.only(
        bottomLeft: Radius.circular(_buttonRadius),
        bottomRight: Radius.circular(_buttonRadius),
      ).toRRect(Offset.zero & size),
      Paint()..color = backgroundColor,
    );

    /// Draw carets
    final p1 = Offset(hPadding, size.height / 2 - 1.0);
    final p2 = Offset(size.width / 2, size.height / 2 + 2.0);
    final p3 = Offset(size.width / 2 + 1.0, size.height / 2 + 1.0);
    final p4 = Offset(size.width - hPadding, size.height / 2 - 1.0);
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.75;
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p3, p4, paint);
  }

  @override
  bool shouldRepaint(DownCaretPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(DownCaretPainter oldDelegate) => false;
}

class UpCaretPainter extends CustomPainter {
  const UpCaretPainter({
    required this.color,
    required this.backgroundColor,
  });

  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final hPadding = size.height / 3;

    /// Draw background
    canvas.drawRRect(
      const BorderRadius.only(
        topLeft: Radius.circular(_buttonRadius),
        topRight: Radius.circular(_buttonRadius),
      ).toRRect(Offset.zero & size),
      Paint()..color = backgroundColor,
    );

    /// Draw carets
    final p1 = Offset(hPadding, size.height / 2 + 1.0);
    final p2 = Offset(size.width / 2, size.height / 2 - 2.0);
    final p3 = Offset(size.width / 2 + 1.0, size.height / 2 - 1.0);
    final p4 = Offset(size.width - hPadding, size.height / 2 + 1.0);
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.75;
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p3, p4, paint);
  }

  @override
  bool shouldRepaint(UpCaretPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(UpCaretPainter oldDelegate) => false;
}
