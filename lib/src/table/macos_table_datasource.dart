import 'dart:async';

import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/table/macos_table_columns.dart';
import 'package:macos_ui/src/table/macos_table_order.dart';
import 'package:macos_ui/src/table/macos_table_selection.dart';

/// A combination of a row [value] and a persistent identifier [key] for the row.
@immutable
class MacosTableValue<T> {
  const MacosTableValue({
    required this.key,
    required this.value,
  });

  /// A persistent identifier for this row.
  ///
  /// If you select a row and change the data or order,
  /// the key is how the table knows which row was selected.
  ///
  /// If you never change the object instances displayed by the table,
  /// use an `ObjectKey` of the value object.
  /// Normally, this should be a ValueKey of some unique attribute of the row value.
  /// If you never even change the order, you could also use a
  /// ValueKey of the index.
  final Key key;

  /// The row value.
  ///
  /// Passed to [rowBuilder] to build a rows cell widgets.
  final T value;
}

/// The state of a [MacosTableView].
///
/// Supplies the data to a [MacosTableView] and serves as a handle to execute
/// operations on the table.
class MacosTableDataSource<T> {
  MacosTableDataSource({
    this.changeOrder,
    required List<ColumnDefinition<T>> colDefs,
    required this.getRowCount,
    required this.getRowValue,
  })  : _colDefs = colDefs,
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
  final List<ColumnDefinition<T>> _colDefs;
  List<ColumnDefinition<T>> get colDefs => _colDefs;

  // By what column and in what direction the table is ordered.
  MacosTableOrder<T>? order;

  // Callback to update the row count.
  final int Function() getRowCount;

  /// The number of rows in the table.
  /// Limits with which indices `getRow` is called.
  int _rowCount = 0;

  int get rowCount => _rowCount;

  /// The main function through which data is fed into the table.
  /// You need to maintain some order from index (between 0 and rowCount)
  /// to rows.
  /// This function gets called when the row at a given index is rebuilt.
  final MacosTableValue<T> Function(int index) getRowValue;

  /// A function called when the table order should change.
  ///
  /// Should either reject the order (by returning `false`),
  /// or change the order of items returned by [getRowValue] according to
  /// the given [MacosTableOrder].
  final bool Function(MacosTableOrder<T>?)? changeOrder;

  // TODO: Allow selecting multiple rows.

  /// The current selection of the table.
  MacosTableSelection? _selection;

  /// Change which rows are selected.
  ///
  /// Updates the internal selection and rebuilds
  /// the selected and previously selected rows.
  void select(MacosTableSelection? selection) {
    final selectionChange = MacosTableSelectionChange(_selection, selection);
    _selection = selection;
    _selectionChangedController.add(selectionChange);
  }

  List<T> get selectedRows => _selection == null ? [] : [_selection!.value];

  List<Key> get selectedKeys => _selection == null ? [] : [_selection!.key];

  /// Notify the view about a change in the table order.
  ///
  /// Emits an event in [onOrderChanged].
  _updateOrder() {
    // Call the callback first, so the actual data is reordered.
    if (changeOrder != null) {
      changeOrder!(order);
    }
    // Update the view through the [StreamBuilder] afterwards.
    _orderChangedController.add(order);
  }

  /// Notify the table about new or modified data.
  ///
  /// Call this after every data change you want to see,
  /// if you don't call this function, the new data may not be shown.
  /// Only call this function once after a series of data changes,
  /// since it causes most of the table to rebuild, which is expensive.
  dataChanged() {
    _rowCount = getRowCount();
    _dataChangedController.add(Null);
  }

  /// Toggle between ascending and descending order.
  void reverseOrderDirection() {
    order?.reverseDirection();
    _updateOrder();
  }

  void orderBy(MacosTableOrder<T>? newOrder) {
    order = newOrder;
    _updateOrder();
  }
}
