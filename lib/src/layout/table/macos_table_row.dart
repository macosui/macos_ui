import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/layout/table/macos_table_selection.dart';

/// A widget to display a single row inside a [MacosTable].
class MacosTableRow<T> extends StatelessWidget {
  const MacosTableRow({
    super.key,
    required this.index,
    required this.columnWidths,
    required this.columnDefinitions,
    required this.row,
    required this.rowHeight,
    required this.data,
  }) : hasEvenRowHighlight = index % 2 == 1;

  /// A map from column index to its [TableColumnWidth].
  /// The same information is also contained in the [columnDefinitions],
  /// but this is calculated once in the [MacosTable]
  /// and reused here for performance reasons.
  final Map<int, TableColumnWidth> columnWidths;

  /// Definition of the columns of the table.
  final List<ColumnDefinition<T>> columnDefinitions;

  /// The value shown in this row.
  final MacosTableValue<T> row;

  /// The height of this row.
  final double rowHeight;

  /// All rows in a table are numbered, this is the index of this row.
  /// Used to highlight every other row through [hasEvenRowHighlight].
  final int index;

  /// The data source of the table this row is a part of.
  final MacosTableDataSource<T> data;

  /// Whether this row has an even [index] and should be highlighted.
  final bool hasEvenRowHighlight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        data.select(MacosTableSelection(row: row));
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: StreamBuilder<MacosTableSelectionChange>(
          stream: data.onSelectionChanged.where((change) =>
              change.oldSelection?.row.key == row.key ||
              change.newSelection?.row.key == row.key),
          builder: (context, selection) {
            final bool isSelected = data.selectedKeys.contains(row.key);
            return _RowHighlight(
              hasEvenRowHighlight: hasEvenRowHighlight,
              isSelected: isSelected,
              columnWidths: columnWidths,
              children: columnDefinitions.map((colDef) {
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

  /// Whether this rows index is even and it should be highlighted.
  final bool hasEvenRowHighlight;

  /// Whether this row is selected.
  final bool isSelected;

  /// A map from column index to its [TableColumnWidth].
  final Map<int, TableColumnWidth> columnWidths;

  /// The content for all of the rows cells.
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
