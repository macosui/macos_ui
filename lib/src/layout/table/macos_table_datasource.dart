import 'dart:async';

import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/layout/table/macos_table_columns.dart';
import 'package:macos_ui/src/layout/table/macos_table_order.dart';
import 'package:macos_ui/src/layout/table/macos_table_selection.dart';

/// A combination of a row [value] and a persistent identifier [key] for the row.
@immutable
class MacosTableValue<T> {
  const MacosTableValue({
    required this.key,
    required this.value,
  });

  /// A persistent identifier for this row.
  ///
  /// The key allows the table to know which row is selected,
  /// even after the order or data is changed.
  ///
  /// If the object instances displayed by the table are never changed,
  /// use an [ObjectKey] of the value object.
  /// Normally, this should be a [ValueKey] of some unique attribute
  /// of the row value.
  ///
  /// Even if the order is never changed, a [ValueKey] of the index
  /// would also suffice.
  final Key key;

  /// The row value.
  ///
  /// Passed to [rowBuilder] to build a rows cell widgets.
  final T value;
}

/// The state of a [MacosTable].
///
/// Supplies the data to a [MacosTable] and serves as a handle to execute
/// operations on it.
class MacosTableDataSource<T> {
  MacosTableDataSource({
    this.changeTableOrder,
    required List<ColumnDefinition<T>> columnDefinitions,
    required this.getRowCount,
    required this.getRowValue,
  })  : _columnDefinitions = columnDefinitions,
        _rowCount = getRowCount();

  // Various streams to enable partial rebuilding using StreamBuilder
  final StreamController<void> _dataChangedController =
      StreamController<void>.broadcast();
  Stream<void> get onDataChanged => _dataChangedController.stream;

  final StreamController<MacosTableOrder<T>?> _orderChangedController =
      StreamController<MacosTableOrder<T>?>.broadcast();
  Stream<MacosTableOrder<T>?> get onOrderChanged =>
      _orderChangedController.stream;

  final StreamController<MacosTableSelectionChange>
      _selectionChangedController =
      StreamController<MacosTableSelectionChange>.broadcast();
  Stream<MacosTableSelectionChange> get onSelectionChanged =>
      _selectionChangedController.stream;

  // TODO: Add functions to change columns (if possible with animations)

  /// Define which columns are shown.
  final List<ColumnDefinition<T>> _columnDefinitions;
  List<ColumnDefinition<T>> get columnDefinitions => _columnDefinitions;

  /// The order and direction with which the table is sorted.
  MacosTableOrder<T>? tableOrder;

  /// Callback to update the row count.
  final int Function() getRowCount;

  /// The number of rows in the table.
  ///
  /// Limits with which indices `getRow` is called.
  int _rowCount = 0;

  int get rowCount => _rowCount;

  /// The main function through which data is fed into the table.
  ///
  /// The rows need to be numbered (between 0 and rowCount - 1),
  /// so that this function can return the value at some index.
  /// This function gets called when the row at a given index is rebuilt.
  final MacosTableValue<T> Function(int index) getRowValue;

  /// A function called when the table order should change.
  ///
  /// Should either reject the order (by returning `false`),
  /// or change the order of items returned by [getRowValue] according to
  /// the given [MacosTableOrder].
  final bool Function(MacosTableOrder<T>?)? changeTableOrder;

  // TODO: Allow selecting multiple rows.

  /// The current selection of the table.
  MacosTableSelection? _tableSelection;

  /// Change which rows are selected.
  ///
  /// Updates the internal selection and rebuilds
  /// the selected and previously selected rows.
  void select(MacosTableSelection? selection) {
    final selectionChange =
        MacosTableSelectionChange(_tableSelection, selection);
    _tableSelection = selection;
    _selectionChangedController.add(selectionChange);
  }

  List<T> get selectedRows =>
      _tableSelection == null ? [] : [_tableSelection!.row.value];

  List<Key> get selectedKeys =>
      _tableSelection == null ? [] : [_tableSelection!.row.key];

  /// Notify the view about a change in the table order.
  ///
  /// Emits an event in [onOrderChanged].
  _updateOrder() {
    // Call the callback first, so the actual data is reordered.
    if (changeTableOrder != null) {
      changeTableOrder!(tableOrder);
    }
    // Update the view through the [StreamBuilder] afterwards.
    _orderChangedController.add(tableOrder);
  }

  /// Notify the table about new or modified data.
  ///
  /// Must be called after every data change. If it is not called, 
  /// the updated data may not be shown.
  ///
  /// Only call this function once after a series of data changes,
  /// since it causes most of the table to rebuild, which is expensive.
  dataChanged() {
    _rowCount = getRowCount();
    _dataChangedController.add(Null);
  }

  /// Toggle between ascending and descending order.
  void reverseOrderDirection() {
    tableOrder?.reverseDirection();
    _updateOrder();
  }

  void orderBy(MacosTableOrder<T>? newOrder) {
    tableOrder = newOrder;
    _updateOrder();
  }
}
