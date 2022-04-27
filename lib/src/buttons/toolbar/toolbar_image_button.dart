import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

class ToolBarImageButton extends ToolbarItem {
  const ToolBarImageButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode) {
    final brightness = MacosTheme.of(context).brightness;
    if (displayMode == ToolbarItemDisplayMode.inToolbar) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MacosIconButton(
              icon: MacosIconTheme(
                data: MacosTheme.of(context).iconTheme.copyWith(
                      color: brightness.resolve(
                        const Color.fromRGBO(0, 0, 0, 0.5),
                        const Color.fromRGBO(255, 255, 255, 0.5),
                      ),
                      size: 16.0,
                    ),
                child: icon,
              ),
              onPressed: onPressed,
              boxConstraints: const BoxConstraints(
                minHeight: 20,
                minWidth: 20,
                maxWidth: 48,
                maxHeight: 38,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11.0,
                  color: MacosColors.systemGrayColor,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return ToolbarOverflowMenuItem(
        label: label,
        onPressed: onPressed,
      );
    }
  }
}
