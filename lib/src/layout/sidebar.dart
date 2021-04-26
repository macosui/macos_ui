import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class Sidebar {
  /// Creates a macOS-style side bar at left side of the [Scaffold].
  ///
  /// The [builder] and [minWidth] properties are required.
  /// The sidebar builds with a scrollbar internally.
  Sidebar({
    required this.builder,
    required this.minWidth,
    this.key,
    this.decoration,
    this.resizerColor,
    this.isResizable = true,
    this.maxWidth = 400.0,
    this.padding,
  });

  /// The builder that creates a child to display in this widget, which will
  /// use the provided [_scrollController] to enable the scrollbar to work.
  ///
  /// Pass the [scrollController] obtained from this method, to a scrollable
  /// widget used in this method to work with the internal [Scrollbar].
  final ScrollableWidgetBuilder builder;

  /// The [BoxDecoration] to paint behind the child in the [builder].
  final BoxDecoration? decoration;

  /// Specifies whether the [Sidebar] can be resized by dragging or not.
  final bool? isResizable;

  /// A [Key] is an identifier for [Widget]s, [Element]s and [SemanticsNode]s.
  ///
  /// A new widget will only be used to update an existing element if its key is
  /// the same as the key of the current widget associated with the element.
  ///
  /// {@youtube 560 315 https://www.youtube.com/watch?v=kn0EOS-ZiIc}
  ///
  /// Keys must be unique amongst the [Element]s with the same parent.
  ///
  /// Subclasses of [Key] should either subclass [LocalKey] or [GlobalKey].
  ///
  /// See also:
  ///
  ///  * [Widget.key], which discusses how widgets use keys.
  final Key? key;

  /// The maximum width that this sidebar can be resized to.
  ///
  /// The [maxWidth] should not be less than the [minWidth].
  ///
  /// Defaults to `400.0`
  final double? maxWidth;

  /// /// The minimum width that this sidebar can be resized to.
  ///
  /// The [minWidth] should not be more than the [maxWidth].
  final double minWidth;

  /// Empty space to inscribe inside the title bar. The [child], if any, is
  /// placed inside this padding.
  ///
  /// Defaults to `EdgeInsets.only(top: 52.0)`.
  final EdgeInsets? padding;

  /// Specifies the color the resizer on the right side of the [Sidebar].
  final Color? resizerColor;
}
