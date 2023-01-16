import 'package:macos_ui/src/library.dart';

enum ColumnAlignment {
  start,
  center,
  end,
}

class ColumnDefinition<T> {
  const ColumnDefinition({
    required this.label,
    required this.width,
    this.alignment = ColumnAlignment.start,
    required this.cellBuilder,
  });

  final String label;
  final TableColumnWidth width;
  final ColumnAlignment alignment;
  final Widget Function(BuildContext, T) cellBuilder;
}
