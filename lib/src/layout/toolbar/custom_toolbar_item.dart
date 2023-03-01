import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A custom widget for the toolbar.
class CustomToolbarItem extends ToolbarItem {
  /// Builds a custom widget for the toolbar.
  ///
  /// Example:
  ///
  /// ```dart
  /// // Add a grey vertical line as a custom toolbar item:
  /// CustomToolbarItem(
  ///   inToolbarBuilder: (context) => Padding(
  ///     padding: const EdgeInsets.all(8.0),
  ///     child: Container(
  ///       color: Colors.grey,
  ///       width: 1,
  ///       height: 30,
  ///     ),
  ///   ),
  ///   inOverflowedBuilder: (context) => Container(
  ///     color: Colors.grey,
  ///     width: 30,
  ///     height: 1,
  ///   ),
  /// ),
  /// // Add a search field as a custom toolbar item:
  /// CustomToolbarItem(
  ///   inToolbarBuilder: (context) => const SizedBox(
  ///     width: 200,
  ///     child: MacosSearchField(),
  ///   ),
  /// ),
  /// ```
  ///
  /// If [inOverflowedBuilder] is not provided, the custom toolbar item will not
  /// have an entry in the toolbar's overflowed menu (>>).
  const CustomToolbarItem({
    super.key,
    required this.inToolbarBuilder,
    this.inOverflowedBuilder,
    this.tooltipMessage,
  });

  /// Builds a custom widget to include in the [Toolbar].
  ///
  /// Can be any widget
  final WidgetBuilder inToolbarBuilder;

  /// Builds a widget to include as an entry in the overflowed menu (>>).
  ///
  /// Normally, a [ToolbarOverflowMenuItem] with [label] and [onPressed]
  /// properties.
  ///
  /// Defaults to [SizedBox.shrink].
  final WidgetBuilder? inOverflowedBuilder;

  /// An optional message to appear in a tooltip when user hovers over the
  /// custom toolbar item.
  final String? tooltipMessage;

  @override
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode) {
    if (displayMode == ToolbarItemDisplayMode.inToolbar) {
      Widget widget = inToolbarBuilder(context);
      if (tooltipMessage != null) {
        widget = MacosTooltip(
          message: tooltipMessage!,
          child: widget,
        );
      }
      return widget;
    } else {
      return (inOverflowedBuilder != null)
          ? inOverflowedBuilder!(context)
          : const SizedBox.shrink();
    }
  }
}
