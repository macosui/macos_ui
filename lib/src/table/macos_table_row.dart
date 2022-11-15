import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/table/macos_table_selection.dart';

class MacosTableRow<T> extends StatelessWidget {
  const MacosTableRow({
    super.key,
    required this.index,
    required this.columnWidths,
    required this.colDefs,
    required this.row,
    required this.rowHeight,
    required this.data,
  }) : hasEvenRowHighlight = index % 2 == 1;

  final Map<int, TableColumnWidth> columnWidths;
  final List<ColumnDefinition<T>> colDefs;
  final MacosTableValue<T> row;

  final double rowHeight;

  final int index;

  final MacosTableDataSource<T> data;

  final bool hasEvenRowHighlight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        data.select(MacosTableSelection(key: row.key, value: row.value));
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: StreamBuilder<MacosTableSelectionChange>(
          stream: data.onSelectionChanged.where((change) =>
              change.oldSelection?.key == row.key ||
              change.newSelection?.key == row.key),
          builder: (context, selection) {
            final bool isSelected = data.selectedKeys.contains(row.key);
            return _RowHighlight(
              hasEvenRowHighlight: hasEvenRowHighlight,
              isSelected: isSelected,
              columnWidths: columnWidths,
              children: colDefs.map((colDef) {
                final AlignmentGeometry alignmentGeometry =
                    (colDef.alignment == ColumnAlignment.start)
                        ? Alignment.centerLeft
                        : (colDef.alignment == ColumnAlignment.center)
                            ? Alignment.center
                            : Alignment.centerRight;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox.fromSize(
                    size: Size(0, rowHeight),
                    child: Align(
                      alignment: alignmentGeometry,
                      child: colDef.cellBuilder(context, row.value),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

/// Add selection and even / odd highlighting to table rows
class _RowHighlight extends StatelessWidget {
  const _RowHighlight({
    required this.hasEvenRowHighlight,
    required this.isSelected,
    required this.columnWidths,
    required this.children,
  });

  final bool hasEvenRowHighlight;
  final bool isSelected;
  final Map<int, TableColumnWidth> columnWidths;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    Decoration? decoration;
    TextStyle textStyle = MacosTheme.of(context)
        .typography
        .body
        .copyWith(fontFeatures: [const FontFeature.tabularFigures()]);
    if (hasEvenRowHighlight && !isSelected) {
      decoration = const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.05),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      );
    } else if (isSelected) {
      decoration = BoxDecoration(
        color: MacosTheme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      );
      textStyle = textStyle.copyWith(color: MacosColors.white);
    }
    return DefaultTextStyle(
      style: textStyle,
      child: Table(
        columnWidths: columnWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: decoration,
            children: children,
          ),
        ],
      ),
    );
  }
}
