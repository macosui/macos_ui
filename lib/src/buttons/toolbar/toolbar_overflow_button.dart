import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

class ToolbarOverflowButton extends StatelessWidget {
  ToolbarOverflowButton({
    Key? key,
    required this.overflowContentBuilder,
  }) : super(key: key);

  final WidgetBuilder overflowContentBuilder;

  @override
  Widget build(BuildContext context) {
    final popupKey = GlobalKey<ToolbarPopUpState>();
    return ToolbarPopUp(
      key: popupKey,
      child: ToolBarIconButton(
        label: "More",
        icon: const MacosIcon(
          CupertinoIcons.chevron_down,
        ),
        onPressed: () {
          popupKey.currentState?.openPopup();
        },
      ).build(context, ToolbarItemDisplayMode.inToolbar),
      content: overflowContentBuilder,
      verticalOffset: 8.0,
      horizontalOffset: 10.0,
      position: ToolbarPopupPosition.below,
      placement: ToolbarPopupPlacement.end,
    );
  }
}
