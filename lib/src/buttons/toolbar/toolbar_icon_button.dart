import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A icon button suitable for the toolbar.
///
/// It essentially wraps a [MacosIconButton] with the appropriate toolbar
/// styling.
///
/// If it overflows the available toolbar width, it becomes
/// a [ToolbarOverflowMenuItem].
class ToolBarIconButton extends ToolbarItem {
  const ToolBarIconButton({
    Key? key,
    required this.label,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  /// The label that describes this button's action.
  ///
  /// Must be provided, so that it can be shown in the [ToolbarOverflowMenu].
  final String label;

  /// The widget to use as the icon.
  ///
  /// Typically an [Icon] widget.
  final Widget icon;

  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled (greyed out).
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode) {
    final brightness = MacosTheme.of(context).brightness;
    if (displayMode == ToolbarItemDisplayMode.inToolbar) {
      return MacosIconButton(
        icon: MacosIconTheme(
          data: MacosTheme.of(context).iconTheme.copyWith(
                color: brightness.resolve(
                  const Color.fromRGBO(0, 0, 0, 0.5),
                  const Color.fromRGBO(255, 255, 255, 0.5),
                ),
                size: 20.0,
              ),
          child: icon,
        ),
        onPressed: onPressed,
        boxConstraints: const BoxConstraints(
          minHeight: 26,
          minWidth: 20,
          maxWidth: 48,
          maxHeight: 38,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
      );
    } else {
      return ToolbarOverflowMenuItem(
        label: label,
        onPressed: onPressed,
      );
    }
  }
}
