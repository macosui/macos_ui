import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosTableHeader<T> extends StatelessWidget {
  const MacosTableHeader({
    super.key,
    required this.colDefs,
    required this.order,
    this.columnHeaderClicked,
  });

  static const double horizontalPadding = 10;

  final List<ColumnDefinition<T>> colDefs;
  final Function(ColumnDefinition<T>)? columnHeaderClicked;

  final MacosTableOrder<T>? order;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: [
        const FixedColumnWidth(horizontalPadding),
        ...colDefs.map((colDef) => colDef.width),
        const FixedColumnWidth(horizontalPadding),
      ].asMap(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            const SizedBox.shrink(),
            ...colDefs.asMap().keys.map((labelIndex) {
              final colDef = colDefs[labelIndex];
              final bool isOrderedByThisColumn =
                  colDef.label == order?.column.label;
              TextStyle labelStyle = MacosTheme.of(context).typography.headline;
              if (isOrderedByThisColumn) {
                labelStyle = labelStyle.copyWith(fontWeight: FontWeight.w600);
              }

              Widget orderDirectionArrow = const SizedBox.shrink();
              if (isOrderedByThisColumn) {
                orderDirectionArrow = CustomPaint(
                  size: const Size.square(16),
                  painter: _SortDirectionCaretPainter(
                    color: MacosTheme.of(context).brightness.resolve(
                          MacosColors.disabledControlTextColor.color,
                          MacosColors.disabledControlTextColor.darkColor,
                        ),
                    up: order?.direction == MacosTableOrderDirection.ascending,
                  ),
                );
              }

              return GestureDetector(
                onTap: () {
                  if (columnHeaderClicked != null) {
                    columnHeaderClicked!(colDef);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: (labelIndex == colDefs.length - 1)
                            ? BorderSide.none
                            : BorderSide(
                                color: MacosTheme.of(context).dividerColor,
                              ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      child: Row(
                        children: [
                          const Spacer(),
                          Text(colDef.label, style: labelStyle),
                          const Spacer(),
                          orderDirectionArrow,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox.shrink(),
          ],
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: MacosTheme.of(context).dividerColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SortDirectionCaretPainter extends CustomPainter {
  const _SortDirectionCaretPainter({
    required this.color,
    required this.up,
  });

  final Color color;
  final bool up;

  @override
  void paint(Canvas canvas, Size size) {
    final hPadding = size.height / 3;

    /// Draw carets
    if (!up) {
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
    } else {
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
  }

  @override
  bool shouldRepaint(_SortDirectionCaretPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_SortDirectionCaretPainter oldDelegate) => false;
}
