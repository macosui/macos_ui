import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The intent for incrementing a textual picker element.
class IncrementIntent extends Intent {}

/// The intent for decrementing a textual picker element.
class DecrementIntent extends Intent {}

/// The keyset for incrementing a textual picker element.
final incrementKeyset = LogicalKeySet(LogicalKeyboardKey.arrowUp);

/// The keyset for decrementing a textual picker element.
final decrementKeyset = LogicalKeySet(LogicalKeyboardKey.arrowDown);

/// {@template keyboardShortcutRunner}
/// A widget that executes functions when specific physical keyboard shortcuts
/// are performed.
///
/// Used by the textual variants of [MacosDatePicker] and [MacosTimePicker].
/// {@endtemplate}
class KeyboardShortcutRunner extends StatelessWidget {
  /// {@macro keyboardShortcutRunner}.
  const KeyboardShortcutRunner({
    Key? key,
    required this.child,
    required this.onUpArrowKeypress,
    required this.onDownArrowKeypress,
    this.focusNode,
  }) : super(key: key);

  /// This child of this widget.
  final Widget child;

  /// The function to execute when the "enter" key is pressed.
  final VoidCallback onUpArrowKeypress;

  /// The function to execute when the "escape" key is pressed.
  final VoidCallback onDownArrowKeypress;

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      focusNode: focusNode,
      shortcuts: {
        incrementKeyset: IncrementIntent(),
        decrementKeyset: DecrementIntent(),
      },
      actions: {
        IncrementIntent: CallbackAction(
          onInvoke: (e) => onUpArrowKeypress.call(),
        ),
        DecrementIntent: CallbackAction(
          onInvoke: (e) => onDownArrowKeypress.call(),
        ),
      },
      child: child,
    );
  }
}
