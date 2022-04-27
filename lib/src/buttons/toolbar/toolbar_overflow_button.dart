import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

class ToolbarOverflowButton extends StatefulWidget {
  ToolbarOverflowButton({
    Key? key,
    required this.overflowContentBuilder,
  }) : super(key: key);

  final WidgetBuilder overflowContentBuilder;

  @override
  State<ToolbarOverflowButton> createState() => _ToolbarOverflowButtonState();
}

class _ToolbarOverflowButtonState extends State<ToolbarOverflowButton> {
  final popupKey = GlobalKey<ToolbarPopUpState>();
  @override
  Widget build(BuildContext context) {
    final popup = ToolbarPopUp(
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
      content: widget.overflowContentBuilder,
      verticalOffset: 14.0,
      horizontalOffset: 10.0,
    );
    return popup;
  }
}
