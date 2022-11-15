import 'package:macos_ui/src/library.dart';

@immutable
class MacosTableSelection<T> {
  const MacosTableSelection({
    required this.key,
    required this.value,
  });

  final Key key;
  final T value;
}

@immutable
class MacosTableSelectionChange {
  const MacosTableSelectionChange(
    this.oldSelection,
    this.newSelection,
  );

  final MacosTableSelection? oldSelection;
  final MacosTableSelection? newSelection;
}
