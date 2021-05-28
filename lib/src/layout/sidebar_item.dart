import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/src/library.dart';

/// A macOS style navigation-list item intended for use in a [Sidebar]
class SidebarItem extends StatefulWidget {
  /// Builds a [SidebarItem].
  const SidebarItem({
    Key? key,
    required this.leading,
    required this.label,
    required this.onClick,
    this.focusColor = CupertinoColors.systemBlue,
    this.semanticsLabel,
  }) : super(key: key);

  /// The widget to lay out first.
  ///
  /// Typically an [Icon] widget.
  final Widget? leading;

  /// Indicates what content this widget represents.
  ///
  /// Typically a [Text] widget.
  final Widget label;

  /// A function to perform when the widget is clicked or tapped.
  ///
  /// Typically a [Navigator] call
  final VoidCallback? onClick;

  /// The color to paint this widget as when focused.
  ///
  /// Defaults to [CupertinoColors.systemBlue].
  final Color focusColor;

  /// The semantic label used by screen readers.
  final String? semanticsLabel;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('focusColor', focusColor));
    properties.add(StringProperty('semanticLabel', semanticsLabel));
  }

  @override
  _SidebarItemState createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool get hasLeading => widget.leading != null;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: GestureDetector(
        onTap: () {
          widget.onClick!();
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: 134,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0),
              //color: _on ? widget.focusColor : Color(0x00000000),
              color: widget.focusColor,
            ),
            child: Row(
              children: [
                const SizedBox(width: 8.0),
                if (hasLeading) ...[
                  widget.leading!,
                  const SizedBox(width: 8.0),
                ],
                widget.label,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
