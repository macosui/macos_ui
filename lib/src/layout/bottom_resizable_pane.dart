import 'dart:math' as math show max, min;

import 'package:flutter/services.dart' show SystemMouseCursor;
import 'package:macos_ui/src/indicators/scrollbar.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/macos_theme.dart';

/// {@template bottomResizablePane}
/// A widget that can be resized vertically.
///
/// The [builder], [minSize] and [resizableSide] can not be null.
/// The [maxSize] and the [windowBreakpoint] default to `500.00`.
/// [isResizable] defaults to `true`.
///
/// The [startSize] is the initial height.
/// {@endtemplate}
class BottomResizablePane extends StatefulWidget {
  /// {@macro bottomResizablePane}
  const BottomResizablePane({
    super.key,
    required this.builder,
    required this.minSize,
    required this.startSize,
    this.decoration,
    this.maxSize = 500.0,
    this.isResizable = true,
    this.windowBreakpoint,
  })  : assert(
          maxSize >= minSize,
          'minHeight should not be more than maxHeight.',
        ),
        assert(
          (startSize >= minSize) && (startSize <= maxSize),
          'startHeight must not be less than minHeight or more than maxHeight',
        );

  /// The builder that creates a child to display in this widget, which will
  /// use the provided [_scrollController] to enable the scrollbar to work.
  ///
  /// Pass the [scrollController] obtained from this method, to a scrollable
  /// widget used in this method to work with the internal [MacosScrollbar].
  final ScrollableWidgetBuilder builder;

  /// The [BoxDecoration] to paint behind the child in the [builder].
  final BoxDecoration? decoration;

  /// Specifies if this [BottomResizablePane] can be resized by dragging the
  /// resizable side of this widget.
  final bool isResizable;

  /// Specifies the maximum height that this [BottomResizablePane] can have.
  ///
  /// The value can be null and defaults to `500.0`.
  final double maxSize;

  /// Specifies the minimum height that this [BottomResizablePane] can have.
  final double minSize;

  /// Specifies the height that this [BottomResizablePane] first starts height.
  ///
  /// The [startSize] should not be more than the [maxSize] or
  /// less than the [minSize].
  final double startSize;

  /// Specifies the height of the window at which this [BottomResizablePane] will be hidden.
  final double? windowBreakpoint;

  @override
  State<BottomResizablePane> createState() => _BottomResizablePaneState();
}

class _BottomResizablePaneState extends State<BottomResizablePane> {
  SystemMouseCursor _cursor = SystemMouseCursors.resizeRow;
  final _scrollController = ScrollController();
  late double _size;
  late double _dragStartSize;
  late double _dragStartPosition;

  Color get _dividerColor => MacosTheme.of(context).dividerColor;

  BoxDecoration get _decoration {
    final borderSide = BorderSide(color: _dividerColor);
    final top = Border(top: borderSide);
    return BoxDecoration(border: top).copyWith(
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
    );
  }

  @override
  void initState() {
    super.initState();
    _size = widget.startSize;
    _scrollController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BottomResizablePane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.windowBreakpoint != widget.windowBreakpoint ||
        oldWidget.minSize != widget.minSize ||
        oldWidget.maxSize != widget.maxSize) {
      setState(() {
        if (widget.minSize > _size) _size = widget.minSize;
        if (widget.maxSize < _size) _size = widget.maxSize;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height;
    final maxWidth = media.size.width;

    if (widget.windowBreakpoint != null &&
        maxHeight <= widget.windowBreakpoint!) {
      return const SizedBox.shrink();
    }

    return Container(
      width: maxWidth,
      height: _size,
      decoration: _decoration,
      constraints: BoxConstraints(
        maxHeight: widget.maxSize,
        minHeight: widget.minSize,
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
          if (widget.isResizable)
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
