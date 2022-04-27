import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

class ToolBarPullDownButton extends ToolbarItem {
  const ToolBarPullDownButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.items,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final List<MacosPulldownMenuEntry>? items;

  @override
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode) {
    final brightness = MacosTheme.of(context).brightness;

    if (displayMode == ToolbarItemDisplayMode.inToolbar) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: MacosPulldownButtonTheme(
          data: MacosPulldownButtonTheme.of(context).copyWith(
            iconColor: brightness.resolve(
              const Color.fromRGBO(0, 0, 0, 0.5),
              const Color.fromRGBO(255, 255, 255, 0.5),
            ),
          ),
          child: MacosPulldownButton(
            icon: icon,
            items: items,
          ),
        ),
      );
    } else {
      final subMenuKey = GlobalKey<ToolbarPopUpState>();
      List<ToolbarOverflowMenuItem> subMenuItems = [];
      items?.forEach((element) {
        if (element is MacosPulldownMenuItem) {
          assert(element.label != null,
              'When you use a MacosPulldownButton in the Toolbar, you must set the label property for all MacosPulldownMenuItems.');
          subMenuItems.add(
            ToolbarOverflowMenuItem(
              label: element.label!,
              onPressed: element.onTap,
            ),
          );
        }
      });
      return StatefulBuilder(
        builder: (context, setState) {
          return ToolbarPopUp(
            key: subMenuKey,
            child: MouseRegion(
              onEnter: (e) {
                subMenuKey.currentState?.openPopup();
              },
              child: ToolbarOverflowMenuItem(
                label: label,
                subMenuItems: subMenuItems,
                onPressed: () {
                  print("pressed submenu");
                  subMenuKey.currentState?.openPopup();
                },
              ),
            ),
            content: (context) => ToolbarOverflowMenu(children: subMenuItems),
            verticalOffset: 50.0,
            horizontalOffset: -200.0,
            position: ToolbarPopupPosition.side,
            placement: ToolbarPopupPlacement.start,
          );
        },
      );
    }
  }
}
