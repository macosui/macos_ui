import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// The selection state of a [MacosTable].
@immutable
class MacosTableSelection<T> {
  // TODO: Implement selecting multiple rows.
  const MacosTableSelection({
    required this.row,
  });

  /// The row currently selected.
  final MacosTableValue<T> row;
}

/// Represents a change of a [MacosTable] selection.
/// Includes the old and the new selection.
/// Used to figure out whether a row should rebuild after a selection change.
@immutable
class MacosTableSelectionChange {
  const MacosTableSelectionChange(
    this.oldSelection,
    this.newSelection,
  );

  /// The old selection state.
  final MacosTableSelection? oldSelection;

  /// The updated new selection state.
  final MacosTableSelection? newSelection;
}
