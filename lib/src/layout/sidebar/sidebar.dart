import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

/// A macOS-style side bar at left side of the [MacosScaffold].
class Sidebar {
  /// Creates a [Sidebar].
  ///
  /// The [builder] and [minWidth] properties are required.
  /// The sidebar builds with a scrollbar internally.
  const Sidebar({
    required this.builder,
    required this.minWidth,
    this.key,
    this.decoration,
    this.isResizable = true,
    this.dragClosed = true,
    double? dragClosedBuffer,
    this.snapToStartBuffer,
    this.maxWidth = 400.0,
    this.startWidth,
    this.padding = EdgeInsets.zero,
    this.windowBreakpoint = 556.0,
    this.top,
    this.bottom,
    this.topOffset = 51.0,
    this.shownByDefault = true,
  }) : dragClosedBuffer = dragClosedBuffer ?? minWidth / 2;

  /// The builder that creates a child to display in this widget, which will
  /// use the provided [_scrollController] to enable the scrollbar to work.
  ///
  /// Pass the [scrollController] obtained from this method to a scrollable
  /// widget used in this method to work with the internal [MacosScrollbar].
  final ScrollableWidgetBuilder builder;

  /// The [BoxDecoration] to paint behind the child in the [builder].
  final BoxDecoration? decoration;

  /// Specifies whether the [Sidebar] can be resized by dragging or not.
  final bool? isResizable;

  /// If true, the sidebar will close when dragged below [minWidth]. Use
  /// [dragClosedBuffer] configure how far below [minWidth] it needs to be
  /// dragged to trigger this behavior.
  ///
  /// Defaults to `true`.
  final bool dragClosed;

  /// If [dragClosed] is true, the sidebar will be hidden when dragged this far
  /// below [minWidth].  Defaults to half of [minWidth]. Set to 0 to cause the
  /// sidebar to close at exactly [minWidth].
  final double dragClosedBuffer;

  /// If this and [startWidth] are both set, the sidebar will snap back to
  /// [startWidth] when dragged within this many pixels of it.
  final double? snapToStartBuffer;

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

  /// The minimum width that this sidebar can be resized to.
  ///
  /// The [minWidth] should not be more than the [maxWidth].
  final double minWidth;

  /// The default width that this `Sidebar` first starts with.
  ///
  /// The [startWidth] should not be more than the [maxWidth] or
  /// less than the [minWidth].
  final double? startWidth;

  /// Empty space to inscribe inside the title bar. The [child], if any, is
  /// placed inside this padding.
  ///
  /// Defaults to `EdgeInsets.zero`.
  final EdgeInsets padding;

  /// Specifies the width of the window at which this [Sidebar] will be hidden.
  final double windowBreakpoint;

  /// Widget that should be displayed at the top of the [Sidebar].
  ///
  /// Commonly a [MacosSearchField].
  final Widget? top;

  /// Widget that should be displayed at the bottom of the [Sidebar].
  ///
  /// Commonly a [MacosListTile].
  final Widget? bottom;

  /// Specifies the top offset of the sidebar.
  ///
  /// Defaults to `51.0` which levels it up with the default height of the [TitleBar]
  final double topOffset;

  /// Whether the sidebar should be open by default or not.
  ///
  /// Most useful for end sidebars.
  ///
  /// Defaults to `true`.
  final bool shownByDefault;
}
