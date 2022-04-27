import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

class ToolBarIconButton extends ToolbarItem {
  const ToolBarIconButton({
    Key? key,
    required this.label,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode) {
    final brightness = MacosTheme.of(context).brightness;
    if (displayMode == ToolbarItemDisplayMode.inToolbar) {
      return MacosIconButton(
        icon: MacosIconTheme(
          data: MacosTheme.of(context).iconTheme.copyWith(
                color: brightness.resolve(
                  const Color.fromRGBO(0, 0, 0, 0.5),
                  const Color.fromRGBO(255, 255, 255, 0.5),
                ),
                size: 20.0,
              ),
          child: icon,
        ),
        onPressed: onPressed,
        boxConstraints: const BoxConstraints(
          minHeight: 26,
          minWidth: 20,
          maxWidth: 48,
          maxHeight: 38,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
      );
    } else {
      return ToolbarOverflowMenuItem(
        label: label,
        onPressed: onPressed,
      );
    }
  }
}
