import 'package:macos_ui/macos_ui.dart';
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
    this.leadingWhitespace = 8,
  }) : super(key: key);

  /// A widget to display before the [title].
  final Widget? leading;

  /// The primary content of the list tile.
  final Widget title;

  /// Additional content displayed below the [title].
  final Widget? subtitle;

  /// The amount of whitespace between the [leading] and [title] widgets.
  ///
  /// Defaults to `8`.
  final double? leadingWhitespace;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) leading!,
        SizedBox(width: leadingWhitespace),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: MacosTheme.of(context).typography.headline.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              child: title,
            ),
            if (subtitle != null)
              DefaultTextStyle(
                style: MacosTheme.of(context).typography.subheadline.copyWith(
                      color: MacosTheme.brightnessOf(context).isDark
                          ? MacosColors.systemGrayColor
                          : const MacosColor(0xff88888C),
                    ),
                child: subtitle!,
              ),
          ],
        ),
      ],
    );
  }
}
