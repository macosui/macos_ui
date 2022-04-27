import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const kToolbarItemWidth = 44.0;

class ToolBarSpacer extends ToolbarItem {
  const ToolBarSpacer({
    Key? key,
    this.spacerUnits = 1.0,
  }) : super(key: key);

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
