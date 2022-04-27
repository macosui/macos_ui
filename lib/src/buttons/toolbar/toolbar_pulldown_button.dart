import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

class ToolBarPullDownButton extends ToolbarItem {
  const ToolBarPullDownButton({
    Key? key,
    required this.icon,
    required this.items,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback? onTap;
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
            onTap: onTap,
            items: items,
          ),
        ),
      );
    } else {
      return Text("pulldown");
    }
  }
}
