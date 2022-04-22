import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

class ToolBarPullDownButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return MacosPulldownButton(
      icon: icon,
      onTap: onTap,
      items: items,
    );
  }
}
