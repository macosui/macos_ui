import 'dart:math' as math show max, min;

import 'package:flutter/services.dart' show SystemMouseCursor;
import 'package:macos_ui/src/indicators/scrollbar.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/macos_theme.dart';

/// Default value for [ResizablePane] top padding
const EdgeInsets kResizablePaneSafeArea = EdgeInsets.only(top: 52);

/// Indicates the draggable side of the [ResizablePane] for resizing
enum ResizableSide { left, right }

class ResizablePane extends StatefulWidget {
  /// Creates a widget that can be resized horizontally.
  ///
  /// The [builder], [minWidth] and [resizableSide] can not be null.
  /// The [maxWidth] and the [windowBreakpoint] default to `500.00`.
  /// [isResizable] defaults to `true`.
  ///
  /// The [startWidth] is the initial width.
  const ResizablePane({
    Key? key,
    required this.builder,
    this.decoration,
    this.maxWidth = 500.0,
    required this.minWidth,
    this.isResizable = true,
    required this.resizableSide,
    this.windowBreakpoint,
    required this.startWidth,
  })  : assert(
          maxWidth >= minWidth,
          'minWidth should not be more than maxWidth.',
        ),
        assert(
          (startWidth >= minWidth) && (startWidth <= maxWidth),
          'startWidth must not be less than minWidth or more than maxWidth',
        ),
        super(key: key);

  /// The builder that creates a child to display in this widget, which will
  /// use the provided [_scrollController] to enable the scrollbar to work.
  ///
  /// Pass the [scrollController] obtained from this method, to a scrollable
  /// widget used in this method to work with the internal [MacosScrollbar].
  final ScrollableWidgetBuilder builder;

  /// The [BoxDecoration] to paint behind the child in the [builder].
  final BoxDecoration? decoration;

  /// Specifies if this [ResizablePane] can be resized by dragging the
  /// resizable side of this widget.
  final bool isResizable;

  /// Specifies the maximum width that this [ResizablePane] can have.
  ///
  /// The value can be null and defaults to `500.0`.
  final double maxWidth;

  /// Specifies the minimum width that this [ResizablePane] can have.
  final double minWidth;

  /// Specifies the width that this [ResizablePane] first starts width.
  ///
  /// The [startWidth] should not be more than the [maxWidth] or
  /// less than the [minWidth].
  final double startWidth;

  /// Indicates the draggable side of the [ResizablePane] for resizing
  final ResizableSide resizableSide;

  /// Specifies the width of the window at which this [ResizablePane] will be hidden.
  final double? windowBreakpoint;

  @override
  State<ResizablePane> createState() => _ResizablePaneState();
}

class _ResizablePaneState extends State<ResizablePane> {
  SystemMouseCursor _cursor = SystemMouseCursors.resizeColumn;
  final _scrollController = ScrollController();
  late double _width;
  late double _dragStartWidth;
  late double _dragStartPosition;

  Color get _dividerColor => MacosTheme.of(context).dividerColor;

  bool get _resizeOnRight => widget.resizableSide == ResizableSide.right;

  BoxDecoration get _decoration {
    final borderSide = BorderSide(color: _dividerColor);
    final right = Border(right: borderSide);
    final left = Border(left: borderSide);
    return BoxDecoration(border: _resizeOnRight ? right : left).copyWith(
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

  Widget get _resizeArea {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: _cursor,
        child: const SizedBox(width: 5),
      ),
      onHorizontalDragStart: (details) {
        _dragStartWidth = _width;
        _dragStartPosition = details.globalPosition.dx;
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          final newWidth = _resizeOnRight
              ? _dragStartWidth -
                  (_dragStartPosition - details.globalPosition.dx)
              : _dragStartWidth +
                  (_dragStartPosition - details.globalPosition.dx);
          _width = math.max(
            widget.minWidth,
            math.min(
              widget.maxWidth,
              newWidth,
            ),
          );
          if (_width == widget.minWidth) {
            _cursor = _resizeOnRight
                ? SystemMouseCursors.resizeRight
                : SystemMouseCursors.resizeLeft;
          } else if (_width == widget.maxWidth) {
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
    _width = widget.startWidth;
    _scrollController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ResizablePane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.windowBreakpoint != widget.windowBreakpoint ||
        oldWidget.minWidth != widget.minWidth ||
        oldWidget.maxWidth != widget.maxWidth ||
        oldWidget.resizableSide != widget.resizableSide) {
      setState(() {
        if (widget.minWidth > _width) _width = widget.minWidth;
        if (widget.maxWidth < _width) _width = widget.maxWidth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height;
    final maxWidth = media.size.width;

    if (widget.windowBreakpoint != null &&
        maxWidth <= widget.windowBreakpoint!) {
      return const SizedBox.shrink();
    }

    return Container(
      width: _width,
      height: maxHeight,
      decoration: _decoration,
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth,
        minWidth: widget.minWidth,
      ).normalize(),
      child: Stack(
        children: [
          SafeArea(
            left: false,
            right: false,
            child: MacosScrollbar(
              controller: _scrollController,
              child: widget.builder(context, _scrollController),
            ),
          ),
          if (widget.isResizable && !_resizeOnRight)
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
        ],
      ),
    );
  }
}
