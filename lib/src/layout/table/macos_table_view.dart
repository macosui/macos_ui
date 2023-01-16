import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/src/layout/table/macos_table_order.dart';
import './macos_table_header.dart';
import './macos_table_row.dart';
import './macos_table_datasource.dart';

/// {@template macosTable}
/// A scrollable data table which allows sorting by columns and row selection.
/// Displays a set of values of some type `T`, each in one row.
/// Data is provided and accessed through a [MacosTableDataSource],
/// this widget simply serves as a view of such a data source.
/// {@endtemplate}
class MacosTable<T> extends StatelessWidget {
  /// {@macro macosTable}
  const MacosTable({
    super.key,
    this.scrollController,
    required this.rowHeight,
    required this.dataSource,
  });

  /// The height of every row.
  final double rowHeight;

  /// Optionally override the scrollController.
  final ScrollController? scrollController;

  /// The [MacosTableDataSource] providing the data displayed by this table.
  final MacosTableDataSource<T> dataSource;

  @override
  Widget build(BuildContext context) {
    /// A map from column index to its [TableColumnWidth].
    /// Every Table widget needs this, so it is created once and cached here.
    final Map<int, TableColumnWidth> columnWidths = dataSource.columnDefinitions
        .map((colDef) => colDef.width)
        .toList()
        .asMap();

    return StreamBuilder<MacosTableOrder<T>?>(
      initialData: dataSource.tableOrder,
      stream: dataSource.onOrderChanged,
      builder: (context, order) => Column(
        children: [
          MacosTableHeader<T>(
            columnDefinitions: dataSource.columnDefinitions,
            tableOrder: order.data,
            columnHeaderClicked: (colDef) {
              if (colDef == order.data?.column) {
                dataSource.reverseOrderDirection();
              } else {
                dataSource.orderBy(MacosTableOrder(column: colDef));
              }
            },
          ),
          Expanded(
            child: StreamBuilder<void>(
              initialData: Null,
              stream: dataSource.onDataChanged,
              builder: (context, _) => ListView.builder(
                controller: scrollController,
                itemCount: dataSource.rowCount,
                itemExtent: rowHeight,
                itemBuilder: (context, index) {
                  return MacosTableRow(
                    data: dataSource,
                    index: index,
                    rowHeight: rowHeight,
                    columnWidths: columnWidths,
                    columnDefinitions: dataSource.columnDefinitions,
                    row: dataSource.getRowValue(index),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
