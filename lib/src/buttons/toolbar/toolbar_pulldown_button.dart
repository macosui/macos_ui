import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A pulldown button suitable for the toolbar.
class ToolBarPullDownButton extends ToolbarItem {
  /// Builds a pulldown button suitable for the toolbar.
  ///
  /// It essentially wraps a [MacosPulldownButton] with the appropriate toolbar
  /// styling.
  ///
  /// If it overflows the available toolbar width, it becomes a
  /// [ToolbarOverflowMenuItem], that opens a subsequent submenu with the
  /// pulldown items.
  const ToolBarPullDownButton({
    super.key,
    required this.label,
    required this.icon,
    required this.items,
    this.tooltipMessage,
  });

  /// The label that describes this button's action.
  ///
  /// Must be provided so that it can be shown in the [ToolbarOverflowMenu].
  final String label;

  /// An icon to use as title for the pull-down button.
  ///
  /// It is recommended to use icons from the [CupertinoIcons] library for this.
  final IconData icon;

  /// The list of menu entries for the pull-down menu.
  ///
  /// Can be either [MacosPulldownMenuItem]s or [MacosPulldownMenuDivider]s.
  ///
  /// If the list of items is null, then the pull-down button will be disabled,
  /// i.e. it will be displayed in grey and not respond to input.
  ///
  /// If the button overflows the available toolbar width, its items will be
  /// shown in a submenu next to the button's [ToolbarOverflowMenuItem].
  ///
  /// For this reason, you must set the [label] property of all
  /// [MacosPulldownMenuItem]s, as it's necessary for setting the submenu's
  /// content.
  final List<MacosPulldownMenuEntry>? items;

  /// An optional message to appear in a tooltip when user hovers over the
  /// pull-down button.
  final String? tooltipMessage;

  @override
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode) {
    final brightness = MacosTheme.of(context).brightness;

    if (displayMode == ToolbarItemDisplayMode.inToolbar) {
      Widget pulldownButton = Padding(
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

      if (tooltipMessage != null) {
        pulldownButton = MacosTooltip(
          message: tooltipMessage!,
          child: pulldownButton,
        );
      }
      return pulldownButton;
    } else {
      // We should show a submenu for the pulldown button items.
      final subMenuKey = GlobalKey<ToolbarPopupState>();
      List<ToolbarOverflowMenuItem> subMenuItems = [];
      bool isSelected = false;
      // Convert the original pulldown menu items to toolbar overflow menu items.
      items?.forEach((element) {
        if (element is MacosPulldownMenuItem) {
          assert(element.label != null,
              'When you use a MacosPulldownButton in the Toolbar, you must set the label property for all MacosPulldownMenuItems.');
          subMenuItems.add(
            ToolbarOverflowMenuItem(
              label: element.label!,
              onPressed: () {
                element.onTap?.call();
                // Close the initial overflow menu as well.
                Navigator.of(context).pop();
              },
            ),
          );
        }
      });
      return StatefulBuilder(
        builder: (context, setState) {
          return ToolbarPopup(
            key: subMenuKey,
            content: (context) => MouseRegion(
              child: ToolbarOverflowMenu(children: subMenuItems),
              onExit: (e) {
                // Moving the mouse cursor outside of the submenu should
                // dismiss it.
                subMenuKey.currentState?.removeToolbarPopupRoute();
                setState(() => isSelected = false);
              },
            ),
            verticalOffset: 0.0,
            horizontalOffset: 0.0,
            position: ToolbarPopupPosition.side,
            placement: ToolbarPopupPlacement.start,
            child: MouseRegion(
              onHover: (e) {
                subMenuKey.currentState
                    ?.openPopup()
                    .then((value) => setState(() => isSelected = false));
                setState(() => isSelected = true);
              },
              child: ToolbarOverflowMenuItem(
                label: label,
                subMenuItems: subMenuItems,
                onPressed: () {},
                isSelected: isSelected,
              ),
            ),
          );
        },
      );
    }
  }
}
