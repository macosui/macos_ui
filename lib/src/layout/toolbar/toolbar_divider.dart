import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A macOS-styled divider for the toolbar.
class ToolBarDivider extends ToolbarItem {
  /// Builds a macOS-styled divider for the toolbar. It generates a vertical
  /// line (or a horizontal line, if it appears in the overflowed menu) between
  /// the toolbar actions.
  const ToolBarDivider({
    super.key,
    this.padding = const EdgeInsets.all(6.0),
  });

  /// Optional padding to use for the divider.
  ///
  /// Defaults to EdgeInsets.all(6.0).
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode) {
    Color color = MacosTheme.brightnessOf(context).resolve(
      const Color.fromRGBO(0, 0, 0, 0.25),
      const Color.fromRGBO(255, 255, 255, 0.25),
    );
    if (displayMode == ToolbarItemDisplayMode.inToolbar) {
      return Padding(
        padding: padding!,
        child: Container(color: color, width: 1, height: 28),
      );
    } else {
      return Padding(
        padding: padding!,
        child: Container(color: color, height: 1),
      );
    }
  }
}
