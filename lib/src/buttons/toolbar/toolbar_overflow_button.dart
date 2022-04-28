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
  }) : super(key: key);

  /// A function that builds the content of the overflowed actions menu.
  final WidgetBuilder overflowContentBuilder;

  @override
  Widget build(BuildContext context) {
    final popupKey = GlobalKey<ToolbarPopupState>();
    return ToolbarPopup(
      key: popupKey,
      child: ToolBarIconButton(
        label: "More",
        icon: const MacosIcon(
          CupertinoIcons.chevron_right_2,
        ),
        onPressed: () {
          popupKey.currentState?.openPopup();
        },
        showLabel: false,
      ).build(context, ToolbarItemDisplayMode.inToolbar),
      content: overflowContentBuilder,
      verticalOffset: 8.0,
      horizontalOffset: 10.0,
      position: ToolbarPopupPosition.below,
      placement: ToolbarPopupPlacement.end,
    );
  }
}
