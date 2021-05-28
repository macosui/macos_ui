import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/macos_colors.dart';

/// A macOS style navigation-list item intended for use in a [Sidebar]
class SidebarItem with Diagnosticable {
  /// Creates a sidebar item.
  const SidebarItem({
    this.leading,
    required this.label,
    this.selectedColor = CupertinoColors.systemBlue,
    this.unselectedColor = const Color(0x00000000),
    this.shape = const RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(const Radius.circular(7.0)),
    ),
    this.selectedHoverColor,
    this.unselectedHoverColor = const CupertinoDynamicColor.withBrightness(
      color: Color(0x1A000000),
      darkColor: Color(0x42FFFFFF),
    ),
    this.semanticLabel,
  });

  /// The widget to lay out first.
  ///
  /// Typically an [Icon]
  final Widget? leading;

  /// Indicates what content this widget represents.
  ///
  /// Typically a [Text]
  final Widget label;

  /// The color to paint this widget as when selected.
  ///
  /// If null, [MacosThemeData.primaryColor] is used.
  final Color? selectedColor;

  /// The color to paint this widget as when unselected.
  ///
  /// Defaults to transparent.
  final Color unselectedColor;

  /// The color to paint this widget as when hovering and selected.
  ///
  /// If null, [MacosThemeData.primaryColor] with some opacity applied is used.
  final Color? selectedHoverColor;

  /// The color to paint this widget as when hovering and unselected.
  ///
  /// If null, black with 0.52 of opacity is used
  final Color unselectedHoverColor;

  /// The [shape] property specifies the outline (border) of the
  /// decoration. The shape must not be null. It's used alonside
  /// [selectedColor].
  final ShapeBorder shape;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('selectedColor', selectedColor));
    properties.add(ColorProperty('unselectedColor', unselectedColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape));
  }
}

/// A scrollable widget that renders [SidebarItem]s.
///
/// See also:
///
///  * [SidebarItem], the items used by this sidebar
///  * [Sidebar], a side bar used alongside [MacosScaffold]
class SidebarItems extends StatelessWidget {
  /// Creates a scrollable widget that renders [SidebarItem]s.
  const SidebarItems({
    Key? key,
    required this.currentIndex,
    required this.onChanged,
    required this.items,
    this.scrollController,
  })  : assert(currentIndex >= 0 && currentIndex < items.length),
        super(key: key);

  /// The [SidebarItem]s used by the sidebar. If no items are provided,
  /// the sidebar is not rendered.
  final List<SidebarItem> items;

  /// The current selected index. It must be in the range of 0 to
  /// [items.length]
  final int currentIndex;

  /// Called when the current selected index should be changed.
  final ValueChanged<int> onChanged;

  /// The scroll controller used by this sidebar. If null, a local scroll
  /// controller is created.
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return SizedBox.shrink();
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
  /// Typically an [Icon]
  final SidebarItem item;

  /// Whether the item is selected or not
  final bool selected;

  /// A function to perform when the widget is clicked or tapped.
  ///
  /// Typically a [Navigator] call
  final VoidCallback? onClick;

  @override
  __SidebarItemState createState() => __SidebarItemState();
}

class __SidebarItemState extends State<_SidebarItem> {
  bool get hasLeading => widget.item.leading != null;

  bool _hovering = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    Color textLuminance(Color backgroundColor) {
      return backgroundColor.computeLuminance() >= 0.5
          ? MacosColors.black
          : MacosColors.white;
    }

    assert(debugCheckHasMacosTheme(context));

    final theme = MacosTheme.of(context);

    final selectedColor = MacosDynamicColor.resolve(
      _hovering || _focused
          ? widget.item.selectedHoverColor ??
              theme.primaryColor.withOpacity(0.54)
          : widget.item.selectedColor ?? theme.primaryColor,
      context,
    );
    final unselectedColor = MacosDynamicColor.resolve(
      _hovering || _focused
          ? widget.item.unselectedHoverColor
          : widget.item.unselectedColor,
      context,
    );

    return Semantics(
      label: widget.item.semanticLabel,
      button: true,
      focusable: true,
      child: GestureDetector(
        onTap: widget.onClick,
        child: FocusableActionDetector(
          mouseCursor: SystemMouseCursors.click,
          onShowHoverHighlight: (v) => setState(() => _hovering = v),
          onShowFocusHighlight: (v) => setState(() => _focused = v),
          child: Container(
            width: 134.0,
            height: 38.0,
            decoration: ShapeDecoration(
              color: widget.selected ? selectedColor : unselectedColor,
              shape: widget.item.shape,
            ),
            child: Row(children: [
              const SizedBox(width: 8.0),
              if (hasLeading)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconTheme.merge(
                    data: IconThemeData(
                      size: 20,
                      color: widget.selected
                          ? MacosColors.white
                          : CupertinoColors.systemBlue,
                    ),
                    child: widget.item.leading!,
                  ),
                ),
              DefaultTextStyle(
                style: theme.typography.title3.copyWith(
                  color: widget.selected ? textLuminance(selectedColor) : null,
                ),
                child: widget.item.label,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
