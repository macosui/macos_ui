import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/src/table/macos_table_order.dart';
import './macos_table_header.dart';
import './macos_table_row.dart';
import './macos_table_datasource.dart';

/// A scrollable data table with sorting and selection.
class MacosTable<T> extends StatelessWidget {
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
  final MacosTableDataSource<T> dataSource;

  @override
  Widget build(BuildContext context) {
    /// A map from column index to its TableColumnWidth.
    /// Every Table widget needs this, so it is created once and cached here.
    final Map<int, TableColumnWidth> columnWidths =
        dataSource.colDefs.map((colDef) => colDef.width).toList().asMap();

    return StreamBuilder<MacosTableOrder<T>?>(
      initialData: dataSource.order,
      stream: dataSource.onOrderChanged,
      builder: (context, order) => Column(
        children: [
          MacosTableHeader<T>(
            colDefs: dataSource.colDefs,
            order: order.data,
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
                    colDefs: dataSource.colDefs,
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
