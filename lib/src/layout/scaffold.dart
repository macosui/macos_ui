import 'package:macos_ui/macos_ui.dart';

/// Experimental
class Scaffold extends StatelessWidget {
  const Scaffold({
    Key? key,
    this.left,
    this.body,
    this.backgroundColor,
  }) : super(key: key);

  final Color? backgroundColor;
  final Widget? left;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    debugCheckHasMacosTheme(context);
    final style = context.theme;
    late Color color;
    if (style.brightness == Brightness.light) {
      color = backgroundColor ?? CupertinoColors.systemBackground.color;
    } else {
      color = backgroundColor ?? CupertinoColors.systemGrey4.darkColor;
    }
    return AnimatedContainer(
      duration: style.mediumAnimationDuration ?? Duration.zero,
      curve: style.animationCurve ?? Curves.linear,
      color: color,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (this.left != null) left!,
          Expanded(
            child: Column(
              children: [
                if (body != null) Expanded(child: body!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
