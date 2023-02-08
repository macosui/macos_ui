import 'dart:math' as math show max, min;

import 'package:flutter/services.dart' show SystemMouseCursor;
import 'package:macos_ui/src/indicators/scrollbar.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/macos_theme.dart';

/// Default value for [BottomResizablePane] top padding
const EdgeInsets kResizablePaneSafeArea = EdgeInsets.only(top: 52);

/// {@template resizablePane}
/// A widget that can be resized vertically.
///
/// The [builder], [minHeight] and [resizableSide] can not be null.
/// The [maxHeight] and the [windowBreakpoint] default to `500.00`.
/// [isResizable] defaults to `true`.
///
/// The [startHeight] is the initial height.
/// {@endtemplate}
class BottomResizablePane extends StatefulWidget {
  /// {@macro resizablePane}
  const BottomResizablePane({
    super.key,
    required this.builder,
    required this.minHeight,
    required this.startHeight,
    this.decoration,
    this.maxHeight = 500.0,
    this.isResizable = true,
    this.windowBreakpoint,
  })  : assert(
          maxHeight >= minHeight,
          'minHeight should not be more than maxHeight.',
        ),
        assert(
          (startHeight >= minHeight) && (startHeight <= maxHeight),
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
  final double maxHeight;

  /// Specifies the minimum height that this [BottomResizablePane] can have.
  final double minHeight;

  /// Specifies the height that this [BottomResizablePane] first starts height.
  ///
  /// The [startHeight] should not be more than the [maxHeight] or
  /// less than the [minHeight].
  final double startHeight;

  /// Specifies the height of the window at which this [BottomResizablePane] will be hidden.
  final double? windowBreakpoint;

  @override
  State<BottomResizablePane> createState() => _BottomResizablePaneState();
}

class _BottomResizablePaneState extends State<BottomResizablePane> {
  SystemMouseCursor _cursor = SystemMouseCursors.resizeRow;
  final _scrollController = ScrollController();
  late double _height;
  late double _dragStartHeight;
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
        _dragStartHeight = _height;
        _dragStartPosition = details.globalPosition.dy;
      },
      onVerticalDragUpdate: (details) {
        setState(() {
          final newHeight = _dragStartHeight +
              (_dragStartPosition - details.globalPosition.dy);
          _height = math.max(
            widget.minHeight,
            math.min(
              widget.maxHeight,
              newHeight,
            ),
          );
          if (_height == widget.minHeight) {
            _cursor = SystemMouseCursors.resizeUp;
          } else if (_height == widget.maxHeight) {
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
    _height = widget.startHeight;
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
        oldWidget.minHeight != widget.minHeight ||
        oldWidget.maxHeight != widget.maxHeight) {
      setState(() {
        if (widget.minHeight > _height) _height = widget.minHeight;
        if (widget.maxHeight < _height) _height = widget.maxHeight;
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
      height: _height,
      decoration: _decoration,
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight,
        minHeight: widget.minHeight,
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
