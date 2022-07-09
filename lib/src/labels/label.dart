import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A label is a static text field that describes an onscreen interface
/// element or provides a short message. Although people can’t edit labels,
/// they can sometimes copy label contents.
///
/// ![Label Example](https://developer.apple.com/design/human-interface-guidelines/macos/images/labels.png)
class Label extends StatelessWidget {
  /// Creates a label.
  const Label({
    super.key,
    this.icon,
    required this.text,
    this.child,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  /// The icon used by the label. If non-null, it's rendered horizontally
  /// before [text].
  ///
  /// Usually an [Icon].
  final Widget? icon;

  /// The text of the label. Usually a [Text]. To make it selectable, use
  /// [SelectableText] instead
  final Widget text;

  /// The widget at the right of [text].
  final Widget? child;

  /// The cross-axis alignment of the label.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final theme = MacosTheme.of(context);
    final text = DefaultTextStyle(
      style: (theme.typography.body).copyWith(
        color: MacosDynamicColor.resolve(CupertinoColors.label, context),
        fontWeight: FontWeight.w500,
      ),
      child: this.text,
    );
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconTheme(
              data: IconThemeData(
                size: theme.typography.body.fontSize ?? 24,
                color: theme.primaryColor,
              ),
              child: icon!,
            ),
          ),
        text,
        if (child != null) child!,
      ],
    );
  }
}
