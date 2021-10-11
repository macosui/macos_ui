import 'package:macos_ui/src/library.dart';

/// A widget that aims to approximate the [ListTile] widget found in
/// Flutter's material library.
class MacosListTile extends StatelessWidget {
  /// Builds a [MacosListTile].
  const MacosListTile({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  /// A widget to display before the [title].
  final Widget? leading;

  /// The primary content of the list tile.
  final Widget title;

  /// Additional content displayed below the [title].
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) leading!,
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            if (subtitle != null) subtitle!,
          ],
        ),
      ],
    );
  }
}
