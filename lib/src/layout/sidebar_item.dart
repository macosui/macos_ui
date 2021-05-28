import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/macos_colors.dart';

class SidebarItem with Diagnosticable {
  SidebarItem({
    this.leading,
    required this.label,
    this.focusColor = CupertinoColors.systemBlue,
    this.semanticLabel,
  });

  /// The widget to lay out first.
  ///
  /// Typically an [Icon] widget.
  final Widget? leading;

  /// Indicates what content this widget represents.
  ///
  /// Typically a [Text] widget.
  final Widget label;

  /// The color to paint this widget as when focused.
  ///
  /// Defaults to [CupertinoColors.systemBlue].
  final Color focusColor;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('focusColor', focusColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }
}

class SidebarItems extends StatelessWidget {
  const SidebarItems({
    Key? key,
    required this.currentIndex,
    required this.onChanged,
    required this.items,
    this.scrollController,
  })  : assert(currentIndex < items.length),
        super(key: key);

  final List<SidebarItem> items;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      children: List.generate(items.length, (index) {
        final item = items[index];
        return _SidebarItem(
          item: item,
          selected: currentIndex == index,
          onClick: () => onChanged(index),
        );
      }),
    );
  }
}

/// A macOS style navigation-list item intended for use in a [Sidebar]
class _SidebarItem extends StatefulWidget {
  /// Builds a [_SidebarItem].
  const _SidebarItem({
    Key? key,
    required this.item,
    required this.onClick,
    required this.selected,
  }) : super(key: key);

  /// The widget to lay out first.
  ///
  /// Typically an [Icon] widget.
  final SidebarItem item;

  /// Whether the item is selected or not
  final bool selected;

  /// A function to perform when the widget is clicked or tapped.
  ///
  /// Typically a [Navigator] call
  final VoidCallback? onClick;

  @override
  _SidebarItemState createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  SidebarItem get item => widget.item;
  bool get hasLeading => item.leading != null;

  @override
  Widget build(BuildContext context) {
    Color textLuminance(Color backgroundColor) {
      return backgroundColor.computeLuminance() > 0.5
          ? MacosColors.black
          : MacosColors.white;
    }

    return Semantics(
      label: item.semanticLabel,
      button: true,
      child: GestureDetector(
        onTap: widget.onClick,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: 134,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0),
              color: widget.selected ? item.focusColor : Color(0x00000000),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8.0),
                if (hasLeading) ...[
                  IconTheme.merge(
                    data: IconThemeData(
                      size: 20,
                      color: widget.selected
                          ? MacosColors.white
                          : CupertinoColors.systemBlue,
                    ),
                    child: item.leading!,
                  ),
                  const SizedBox(width: 8.0),
                ],
                DefaultTextStyle(
                  style: TextStyle(color: textLuminance(item.focusColor)),
                  child: item.label,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
