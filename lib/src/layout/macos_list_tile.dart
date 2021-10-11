import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

class MacosListTile extends StatelessWidget {
  const MacosListTile({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) leading!,
        const SizedBox(width: 8),
        Column(
          children: [
            title,
            if (subtitle != null) subtitle!,
          ],
        ),
      ],
    );
  }
}
