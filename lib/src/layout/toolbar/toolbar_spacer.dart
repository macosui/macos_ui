import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const kToolbarItemWidth = 32.0;

/// A spacer utility widget for the toolbar.
class ToolBarSpacer extends ToolbarItem {
  /// Builds a spacer utility widget for the toolbar. It generates blank space
  /// between the toolbar actions.
  const ToolBarSpacer({
    Key? key,
    this.spacerUnits = 1.0,
  }) : super(key: key);

  /// How much space to generate, expressed in multiples of [kToolbarItemWidth]
  ///
  /// Defaults to 1.0.
  final double spacerUnits;

  @override
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode) {
    if (displayMode == ToolbarItemDisplayMode.inToolbar) {
      return SizedBox(
        width: spacerUnits * kToolbarItemWidth,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
