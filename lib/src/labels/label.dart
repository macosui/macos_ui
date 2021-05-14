import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A label is a static text field that describes an onscreen
/// interface element or provides a short message. Although
/// people can’t edit labels, they can sometimes copy label
/// contents.
///
/// ![Label Example](https://developer.apple.com/design/human-interface-guidelines/macos/images/labels.png)
class Label extends StatelessWidget {
  /// Creates a label.
  const Label({
    Key? key,
    this.icon,
    required this.text,
    this.child,
  }) : super(key: key);

  final Widget? icon;
  final Widget text;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final theme = MacosTheme.of(context);
    final text = DefaultTextStyle(
      style: (theme.typography?.body ?? TextStyle()).copyWith(
        color: DynamicColorX.macosResolve(CupertinoColors.label, context),
        fontWeight: FontWeight.w500,
      ),
      child: this.text,
    );
    return Row(mainAxisSize: MainAxisSize.min, children: [
      if (icon != null)
        Padding(
          padding: EdgeInsets.only(right: 6),
          child: IconTheme(
            data: IconThemeData(size: theme.typography?.body?.fontSize ?? 24),
            child: icon!,
          ),
        ),
      text,
      if (child != null) child!,
    ]);
  }
}
