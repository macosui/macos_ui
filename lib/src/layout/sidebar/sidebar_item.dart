import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A macOS style navigation-list item intended for use in a [Sidebar]
///
/// See also:
///
///  * [Sidebar], a side bar used alongside [MacosScaffold]
///  * [SidebarItems], the widget that displays [SidebarItem]s vertically
class SidebarItem with Diagnosticable {
  /// Creates a sidebar item.
  const SidebarItem({
    this.leading,
    required this.label,
    this.selectedColor,
    this.unselectedColor,
    this.shape,
    this.focusNode,
    this.semanticLabel,
    this.disclosureItems,
  });

  /// The widget before [label].
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
  final Color? unselectedColor;

  /// The [shape] property specifies the outline (border) of the
  /// decoration. The shape must not be null. It's used alonside
  /// [selectedColor].
  final ShapeBorder? shape;

  /// The focus node used by this item.
  final FocusNode? focusNode;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  /// The disclosure items. If null, there will be no disclosure items.
  ///
  /// If non-null and [leading] is null, a local animated icon is created
  final List<SidebarItem>? disclosureItems;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('selectedColor', selectedColor));
    properties.add(ColorProperty('unselectedColor', unselectedColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
    properties.add(IterableProperty<SidebarItem>(
      'disclosure items',
      disclosureItems,
    ));
  }
}
