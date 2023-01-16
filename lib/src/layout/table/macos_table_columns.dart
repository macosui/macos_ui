import 'package:macos_ui/src/library.dart';

/// Horizontal alignment of content inside a table column.
enum ColumnAlignment {
  start,
  center,
  end,
}

/// Definition of a column inside a [MacosTable].
class ColumnDefinition<T> {
  const ColumnDefinition({
    required this.label,
    required this.width,
    this.alignment = ColumnAlignment.start,
    required this.cellBuilder,
  });

  /// The label shown in the column header.
  final String label;

  /// The width of this column.
  /// Usually either a [FlexColumnWidth] or a [FixedColumnWidth].
  final TableColumnWidth width;

  /// The horizontal alignment of the columns content.
  final ColumnAlignment alignment;

  /// The builder that creates the content of a cell.
  /// Receives the current [BuildContext] and the row value.
  final Widget Function(BuildContext, T) cellBuilder;
}
