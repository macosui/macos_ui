import 'package:macos_ui/src/layout/table/table_cell.dart';
import 'package:macos_ui/src/library.dart';

/// {@template macosTableRow}
/// A horizontal group of [MacosTableCell]s in a [MacosTable].
///
/// Every row in a table must have the same number of children.
/// {@endtemplate}
class MacosTableRow {
  /// {@macro macosTableRow}
  const MacosTableRow({
    this.key,
    required this.cells,
    this.selectable = true,
    required this.onSelect,
    required this.onRightClick,
  });

  final LocalKey? key;
  final List<MacosTableCell> cells;
  final bool selectable;
  final VoidCallback onSelect;
  final VoidCallback onRightClick;
}
