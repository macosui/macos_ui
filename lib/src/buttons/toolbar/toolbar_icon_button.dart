import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

class ToolBarIconButton extends StatelessWidget {
  const ToolBarIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MacosIconButton(
      icon: MacosIconTheme(
        data: MacosTheme.of(context)
            .iconTheme
            .copyWith(color: MacosColors.systemGrayColor, size: 20.0),
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
  }
}
