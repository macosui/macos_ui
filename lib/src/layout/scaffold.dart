import 'package:macos_ui/macos_ui.dart';

/// Experimental
///
/// todo: determine breakpoints for showing/hiding sidebars
class Scaffold extends StatelessWidget {
  const Scaffold({
    Key? key,
    this.leftSidebar,
    this.body,
    this.backgroundColor,
    this.rightSidebar,
  }) : super(key: key);

  final Color? backgroundColor;
  final Widget? leftSidebar;
  final Widget? body;
  final Widget? rightSidebar;

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
          if (this.leftSidebar != null) leftSidebar!,
          Expanded(
            child: Column(
              children: [
                if (body != null) Expanded(child: body!),
              ],
            ),
          ),
          if (this.rightSidebar != null) rightSidebar!,
        ],
      ),
    );
  }
}
