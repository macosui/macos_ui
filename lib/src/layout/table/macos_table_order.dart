import 'package:macos_ui/macos_ui.dart';

/// Indicates the direction of a [MacosTableOrder].
enum MacosTableOrderDirection {
  ascending,
  descending,
}

/// Specifies by what column and in what direction a [MacosTable] is ordered.
class MacosTableOrder<T> {
  MacosTableOrder({
    required this.column,
    this.direction = MacosTableOrderDirection.descending,
  });

  /// The column by which the table is ordered.
  ColumnDefinition<T> column;

  /// The direction in which the table is ordered.
  MacosTableOrderDirection direction;

  /// Reverse the direction by which the table is ordered.
  void reverseDirection() {
    if (direction == MacosTableOrderDirection.ascending) {
      direction = MacosTableOrderDirection.descending;
    } else {
      direction = MacosTableOrderDirection.ascending;
    }
  }
}
