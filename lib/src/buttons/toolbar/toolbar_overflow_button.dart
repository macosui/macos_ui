import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A button to show at the far right side of the toolbar.
class ToolbarOverflowButton extends StatefulWidget {
  /// Builds a button to show at the far right side of the toolbar, when the
  /// toolbar actions are overflowing the available horizontal space.
  ///
  /// When clicked, it opens a [ToolbarOverflowMenu] holding all overflowed
  /// actions in a simplified menu.
  const ToolbarOverflowButton({
    super.key,
    required this.overflowContentBuilder,
    this.isDense = false,
  });

  /// A function that builds the content of the overflowed actions menu.
  final WidgetBuilder overflowContentBuilder;

  /// Whether the icon button should be smaller in size (half the toolbar height).
  final bool isDense;

  @override
  State<ToolbarOverflowButton> createState() => _ToolbarOverflowButtonState();
}

class _ToolbarOverflowButtonState extends State<ToolbarOverflowButton> {
  late final GlobalKey<ToolbarPopupState> popupKey;

  @override
  void initState() {
    super.initState();
    popupKey = GlobalKey<ToolbarPopupState>();
  }

  @override
  Widget build(BuildContext context) {
    return ToolbarPopup(
      key: popupKey,
      content: widget.overflowContentBuilder,
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
        showLabel: widget.isDense,
      ).build(context, ToolbarItemDisplayMode.inToolbar),
    );
  }
}
