import 'dart:math' as math show max, min;

import 'package:flutter/rendering.dart' show SystemMouseCursors;
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/layout/resizable_pane_notifier.dart';
import 'package:macos_ui/src/layout/scaffold.dart';
import 'package:macos_ui/src/library.dart';

/// Default value for [SideBar] top padding
const EdgeInsets kResizablePaneSafeArea = EdgeInsets.only(top: 50);

/// Indicates the draggable side of the sidebar for resizing
enum ResizableSide { left, right }

class ResizablePane extends StatefulWidget {
  /// Creates a widget that can be resized horizontally.
  ///
  /// The [builder], [minWidth] and [resizableSide] can not be null.
  /// The [maxWidth] and the [scaffoldBreakpoint] default to `500.00`.
  /// [isResizable] defaults to `true`.
  const ResizablePane({
    Key? key,
    required this.builder,
    this.decoration,
    this.maxWidth = 500.0,
    required this.minWidth,
    this.isResizable = true,
    required this.resizableSide,
    this.scaffoldBreakpoint,
  })  : assert(maxWidth >= minWidth),
        super(key: key);

  /// The builder that creates a child to display in this widget, which will
  /// use the provided [_scrollController] to enable the scrollbar to work.
  ///
  /// Pass the [scrollController] obtained from this method, to a scrollable
  /// widget used in this method to work with the internal [Scrollbar].
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

  /// Indicates the draggable side of the sidebar for resizing
  final ResizableSide resizableSide;

  /// Specifies the width of the scaffold at which this [ResizablePane] will be hidden.
  final double? scaffoldBreakpoint;

  static UniqueKey _uniqueKey = UniqueKey();

  @override
  _ResizablePaneState createState() => _ResizablePaneState(_uniqueKey);
}

class _ResizablePaneState extends State<ResizablePane> {
  final UniqueKey _key;
  _ResizablePaneState(this._key);

  final _scrollController = ScrollController();
  late double _width;

  Color get _dividerColor => MacosTheme.of(context).dividerColor;

  ScaffoldScope get _scaffoldScope => ScaffoldScope.of(context);

  ResizablePaneNotifier get _notifier => _scaffoldScope.valueNotifier;

  BoxConstraints get _constraints => _scaffoldScope.constraints;

  double? get _maxWidth => _constraints.maxWidth;

  double? get _maxHeight => _constraints.maxHeight;

  bool get _resizeOnRight => widget.resizableSide == ResizableSide.right;

  BoxDecoration get _decoration {
    final _borderSide = BorderSide(color: _dividerColor);
    final right = Border(right: _borderSide);
    final left = Border(left: _borderSide);
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
        cursor: SystemMouseCursors.resizeColumn,
        child: SizedBox(width: 5),
      ),
      onHorizontalDragUpdate: (details) {
        setState(() {
          _width = math.max(
            widget.minWidth,
            math.min(
              math.min(widget.maxWidth, _maxWidth!),
              _resizeOnRight
                  ? _width + details.delta.dx
                  : _width - details.delta.dx,
            ),
          );
          if (_width >= widget.minWidth && _width < widget.maxWidth) {
            _notifier.update(_key, _width);
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _width = widget.minWidth;
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
    if (oldWidget.scaffoldBreakpoint != widget.scaffoldBreakpoint ||
        oldWidget.minWidth != widget.minWidth ||
        oldWidget.maxWidth != widget.maxWidth)
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _notifier.remove(_key, notify: false);
        setState(() {
          if (widget.minWidth > _width) _width = widget.minWidth;
          if (widget.maxWidth < _width) _width = widget.maxWidth;
        });
        _notifier.update(_key, _width);
      });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scaffoldBreakpoint != null) {
      if (_maxWidth! <= widget.scaffoldBreakpoint!) {
        _notifier.remove(_key, notify: false);
        return SizedBox.shrink();
      } else {
        _notifier.update(_key, _width, notify: false);
      }
    } else if (!_notifier.value.containsKey(_key)) {
      _notifier.update(_key, _width, notify: false);
    }

    return SizedBox(
      width: _width,
      height: _maxHeight,
      child: DecoratedBox(
        decoration: _decoration,
        child: Stack(
          children: [
            SafeArea(
              left: false,
              right: false,
              child: Scrollbar(
                controller: _scrollController,
                child: widget.builder(context, _scrollController),
              ),
            ),
            if (widget.isResizable && !_resizeOnRight)
              Positioned(
                left: 0,
                width: 5,
                height: _maxHeight,
                child: _resizeArea,
              ),
            if (widget.isResizable && _resizeOnRight)
              Positioned(
                right: 0,
                width: 5,
                height: _maxHeight,
                child: _resizeArea,
              ),
          ],
        ),
      ),
    );
  }
}
