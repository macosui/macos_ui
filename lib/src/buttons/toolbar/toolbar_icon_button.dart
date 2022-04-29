import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// An icon button suitable for the toolbar.
class ToolBarIconButton extends ToolbarItem {
  /// Builds an icon button suitable for the toolbar.
  ///
  /// It essentially wraps a [MacosIconButton] with the appropriate toolbar
  /// styling.
  ///
  /// If it overflows the available toolbar width, it becomes
  /// a [ToolbarOverflowMenuItem].
  ///
  /// If [showLabel] is set to false, the button looks similar to the
  /// "system control" toolbar item from Apple's design guidelines. If true,
  /// it replicates the "image button" toolbar item.
  const ToolBarIconButton({
    Key? key,
    required this.label,
    required this.icon,
    this.onPressed,
    required this.showLabel,
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

  /// Whether the tool bar icon button should show its label below the icon.
  ///
  /// If set to false, the button looks similar to the "system control"
  /// toolbar item from Apple's design guidelines. If true, it replicates the
  /// "image button" toolbar item.
  final bool showLabel;

  @override
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode) {
    final brightness = MacosTheme.of(context).brightness;
    if (displayMode == ToolbarItemDisplayMode.inToolbar) {
      final Widget iconButton = MacosIconButton(
        disabledColor: Colors.transparent,
        icon: MacosIconTheme(
          data: MacosTheme.of(context).iconTheme.copyWith(
                color: brightness.resolve(
                  const Color.fromRGBO(0, 0, 0, 0.5),
                  const Color.fromRGBO(255, 255, 255, 0.5),
                ),
                size: showLabel ? 16.0 : 20.0,
              ),
          child: icon,
        ),
        onPressed: onPressed,
        boxConstraints: BoxConstraints(
          minHeight: showLabel ? 20 : 26,
          minWidth: 20,
          maxWidth: 48,
          maxHeight: 38,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
      );

      if (showLabel) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 0.0),
          child: Column(
            children: [
              iconButton,
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.0,
                    color: MacosColors.systemGrayColor,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return iconButton;
      }
    } else {
      return ToolbarOverflowMenuItem(
        label: label,
        onPressed: onPressed,
      );
    }
  }
}
