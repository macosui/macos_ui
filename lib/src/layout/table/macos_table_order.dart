import 'package:macos_ui/macos_ui.dart';

enum MacosTableOrderDirection {
  ascending,
  descending,
}

class MacosTableOrder<T> {
  MacosTableOrder({
    required this.column,
    this.direction = MacosTableOrderDirection.descending,
  });

  ColumnDefinition<T> column;
  MacosTableOrderDirection direction;

  void reverseDirection() {
    if (direction == MacosTableOrderDirection.ascending) {
      direction = MacosTableOrderDirection.descending;
    } else {
      direction = MacosTableOrderDirection.ascending;
    }
  }
}
