import 'dart:math' as math show max, min;

import 'package:flutter/services.dart' show SystemMouseCursor;
import 'package:macos_ui/src/layout/scrollbar.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/macos_theme.dart';

/// Default value for [ResizablePane] top padding
const EdgeInsets kResizablePaneSafeArea = EdgeInsets.only(top: 52);

/// Indicates the draggable side of the [ResizablePane] for resizing
enum ResizableSide {
  /// The left side of the [ResizablePane].
  left,

  /// The right side of the [ResizablePane].
  right,

  /// The top side of the [ResizablePane].
  top,
}

/// {@template resizablePane}
/// A widget that can be resized horizontally or vertically.
///
/// The [builder], [minSize] and [resizableSide] can not be null.
/// The [maxSize] and the [windowBreakpoint] default to `500.00`.
/// [isResizable] defaults to `true`.
///
/// The [startSize] is the initial width or height depending on the orientation of the pane.
/// {@endtemplate}
class ResizablePane extends StatefulWidget {
  /// Creates a [ResizablePane] with an internal [MacosScrollbar].
  ///
  /// Consider using [ResizablePane.noScrollBar] constructor when the internal
  /// [MacosScrollbar] is not needed or when working with widgets which do not
  /// expose their scroll controllers.
  /// {@macro resizablePane}.
  const ResizablePane({
    super.key,
    required ScrollableWidgetBuilder this.builder,
    this.decoration,
    this.maxSize = 500.0,
    required this.minSize,
    this.isResizable = true,
    required this.resizableSide,
    this.windowBreakpoint,
    required this.startSize,
  })  : child = null,
        useScrollBar = true,
        assert(
          maxSize >= minSize,
          'minSize should not be more than maxSize.',
        ),
        assert(
          (startSize >= minSize) && (startSize <= maxSize),
          'startSize must not be less than minSize or more than maxWidth',
        );

  /// Creates a [ResizablePane] without an internal [MacosScrollbar].
  ///
  /// Useful when working with widgets which do not expose their scroll
  /// controllers or when not using the platform scroll bar is preferred.
  ///
  /// Consider using the default constructor if showing a [MacosScrollbar]
  /// when scrolling the content of this widget is the expected behavior.
  /// {@macro resizablePane}.
  const ResizablePane.noScrollBar({
    super.key,
    required Widget this.child,
    this.decoration,
    this.maxSize = 500.0,
    required this.minSize,
    this.isResizable = true,
    required this.resizableSide,
    this.windowBreakpoint,
    required this.startSize,
  })  : builder = null,
        useScrollBar = false,
        assert(
          maxSize >= minSize,
          'minSize should not be more than maxSize.',
        ),
        assert(
          (startSize >= minSize) && (startSize <= maxSize),
          'startSize must not be less than minSize or more than maxWidth',
        );

  /// The builder that creates a child to display in this widget, which will
  /// use the provided [_scrollController] to enable the scrollbar to work.
  ///
  /// Pass the [scrollController] obtained from this method, to a scrollable
  /// widget used in this method to work with the internal [MacosScrollbar].
  final ScrollableWidgetBuilder? builder;

  /// The child to display in this widget.
  ///
  /// This is only referenced when the constructor used is [ResizablePane.noScrollbar].
  final Widget? child;

  /// Specify if this [ResizablePane] should have an internal [MacosScrollbar].
  final bool useScrollBar;

  /// The [BoxDecoration] to paint behind the child in the [builder].
  final BoxDecoration? decoration;

  /// Specifies if this [ResizablePane] can be resized by dragging the
  /// resizable side of this widget.
  final bool isResizable;

  /// Specifies the maximum width or height that this [ResizablePane] can have
  /// according to its orientation.
  ///
  /// The orientation is horizontal if the [resizableSide] is
  /// [ResizableSide.left] or [ResizableSide.right] and vertical if the
  /// [resizableSide] is [ResizableSide.top]).
  ///
  /// If this value is null, it defaults to `500.0`.
  final double maxSize;

  /// Specifies the minimum width of height that this [ResizablePane] can have
  /// according to its orientation.
  ///
  /// The orientation is horizontal if the [resizableSide] is
  /// [ResizableSide.left] or [ResizableSide.right] and vertical if the
  /// [resizableSide] is [ResizableSide.top].
  final double minSize;

  /// Specifies the width or height that this [ResizablePane] first starts with
  /// according to its orientation.
  ///
  /// The orientation is horizontal if the [resizableSide] is
  /// [ResizableSide.left] or [ResizableSide.right] and vertical if the
  /// [resizableSide] is [ResizableSide.top]).
  ///
  /// The [startSize] should not be more than the [maxSize] or
  /// less than the [minSize].
  final double startSize;

  /// Indicates the draggable side of the [ResizablePane] for resizing
  final ResizableSide resizableSide;

  /// Specifies the width of the window at which this [ResizablePane] will be hidden.
  final double? windowBreakpoint;

  @override
  State<ResizablePane> createState() => _ResizablePaneState();
}

class _ResizablePaneState extends State<ResizablePane> {
  late SystemMouseCursor _cursor;
  final _scrollController = ScrollController();
  late double _size;
  late double _dragStartSize;
  late double _dragStartPosition;

  Color get _dividerColor => MacosTheme.of(context).dividerColor;

  bool get _resizeOnRight => widget.resizableSide == ResizableSide.right;

  bool get _resizeOnTop => widget.resizableSide == ResizableSide.top;

  BoxDecoration get _decoration {
    final borderSide = BorderSide(color: _dividerColor);
    final right = Border(right: borderSide);
    final left = Border(left: borderSide);
    final top = Border(top: borderSide);
    return BoxDecoration(
      border: _resizeOnTop ? top : (_resizeOnRight ? right : left),
    ).copyWith(
      color: widget.decoration?.color,
      border: widget.decoration?.border,
      borderRadius: widget.decoration?.borderRadius,
      boxShadow: widget.decoration?.boxShadow,
      backgroundBlendMode: widget.decoration?.backgroundBlendMode,
      gradient: widget.decoration?.gradient,
      image: widget.decoration?.image,
      shape: widget.decoration?.shape,
    );
  }

  BoxConstraints get _boxConstraint {
    if (_resizeOnTop) {
      return BoxConstraints(
        maxHeight: widget.maxSize,
        minHeight: widget.minSize,
      ).normalize();
    }
    return BoxConstraints(
      maxWidth: widget.maxSize,
      minWidth: widget.minSize,
    ).normalize();
  }

  Widget get _resizeArea {
    return _resizeOnTop
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: MouseRegion(
              cursor: _cursor,
              child: const SizedBox(width: 5),
            ),
            onVerticalDragStart: (details) {
              _dragStartSize = _size;
              _dragStartPosition = details.globalPosition.dy;
            },
            onVerticalDragUpdate: (details) {
              setState(() {
                final newHeight = _dragStartSize +
                    (_dragStartPosition - details.globalPosition.dy);
                _size = math.max(
                  widget.minSize,
                  math.min(
                    widget.maxSize,
                    newHeight,
                  ),
                );
                if (_size == widget.minSize) {
                  _cursor = SystemMouseCursors.resizeUp;
                } else if (_size == widget.maxSize) {
                  _cursor = SystemMouseCursors.resizeDown;
                } else {
                  _cursor = SystemMouseCursors.resizeRow;
                }
              });
            },
          )
        : GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: MouseRegion(
              cursor: _cursor,
              child: const SizedBox(width: 5),
            ),
            onHorizontalDragStart: (details) {
              _dragStartSize = _size;
              _dragStartPosition = details.globalPosition.dx;
            },
            onHorizontalDragUpdate: (details) {
              setState(() {
                final newWidth = _resizeOnRight
                    ? _dragStartSize -
                        (_dragStartPosition - details.globalPosition.dx)
                    : _dragStartSize +
                        (_dragStartPosition - details.globalPosition.dx);
                _size = math.max(
                  widget.minSize,
                  math.min(
                    widget.maxSize,
                    newWidth,
                  ),
                );
                if (_size == widget.minSize) {
                  _cursor = _resizeOnRight
                      ? SystemMouseCursors.resizeRight
                      : SystemMouseCursors.resizeLeft;
                } else if (_size == widget.maxSize) {
                  _cursor = _resizeOnRight
                      ? SystemMouseCursors.resizeLeft
                      : SystemMouseCursors.resizeRight;
                } else {
                  _cursor = SystemMouseCursors.resizeColumn;
                }
              });
            },
          );
  }

  @override
  void initState() {
    super.initState();
    _cursor = _resizeOnTop
        ? SystemMouseCursors.resizeRow
        : SystemMouseCursors.resizeColumn;
    _size = widget.startSize;
    _scrollController.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant ResizablePane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.windowBreakpoint != widget.windowBreakpoint ||
        oldWidget.minSize != widget.minSize ||
        oldWidget.maxSize != widget.maxSize ||
        oldWidget.resizableSide != widget.resizableSide) {
      if (widget.minSize > _size) _size = widget.minSize;
      if (widget.maxSize < _size) _size = widget.maxSize;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height;
    final maxWidth = media.size.width;

    if (_resizeOnTop) {
      if (widget.windowBreakpoint != null &&
          maxHeight <= widget.windowBreakpoint!) {
        return const SizedBox.shrink();
      }
    } else {
      if (widget.windowBreakpoint != null &&
          maxWidth <= widget.windowBreakpoint!) {
        return const SizedBox.shrink();
      }
    }

    return Container(
      width: _resizeOnTop ? maxWidth : _size,
      height: _resizeOnTop ? _size : maxHeight,
      decoration: _decoration,
      constraints: _boxConstraint,
      child: Stack(
        children: [
          SafeArea(
            left: false,
            right: false,
            child: widget.useScrollBar
                ? MacosScrollbar(
                    controller: _scrollController,
                    child: widget.builder!(context, _scrollController),
                  )
                : widget.child!,
          ),
          if (widget.isResizable && !_resizeOnRight && !_resizeOnTop)
            Positioned(
              left: 0,
              width: 5,
              height: maxHeight,
              child: _resizeArea,
            ),
          if (widget.isResizable && _resizeOnRight)
            Positioned(
              right: 0,
              width: 5,
              height: maxHeight,
              child: _resizeArea,
            ),
          if (widget.isResizable && _resizeOnTop)
            Positioned(
              top: 0,
              width: maxWidth,
              height: 5,
              child: _resizeArea,
            ),
        ],
      ),
    );
  }
}
