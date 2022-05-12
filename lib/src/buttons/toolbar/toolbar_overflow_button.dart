import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A button to show at the far right side of the toolbar.
class ToolbarOverflowButton extends StatelessWidget {
  /// Builds a button to show at the far right side of the toolbar, when the
  /// toolbar actions are overflowing the available horizontal space.
  ///
  /// When clicked, it opens a [ToolbarOverflowMenu] holding all overflowed
  /// actions in a simplified menu.
  const ToolbarOverflowButton({
    Key? key,
    required this.overflowContentBuilder,
    this.isDense = false,
  }) : super(key: key);

  /// A function that builds the content of the overflowed actions menu.
  final WidgetBuilder overflowContentBuilder;

  /// Whether the icon button should be smaller in size (half the toolbar height).
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    final popupKey = GlobalKey<ToolbarPopupState>();
    return ToolbarPopup(
      key: popupKey,
      content: overflowContentBuilder,
      verticalOffset: 8.0,
      horizontalOffset: 10.0,
      position: ToolbarPopupPosition.below,
      placement: ToolbarPopupPlacement.end,
      child: ToolBarIconButton(
        label: "",
        icon: const MacosIcon(
          CupertinoIcons.chevron_right_2,
        ),
        onPressed: () {
          popupKey.currentState?.openPopup();
        },
        showLabel: isDense,
      ).build(context, ToolbarItemDisplayMode.inToolbar),
    );
  }
}
