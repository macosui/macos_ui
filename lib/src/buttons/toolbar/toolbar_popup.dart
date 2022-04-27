import 'package:macos_ui/src/library.dart';
import 'dart:math' as math;

/// Where the flyout will be placed vertically relativelly the child
enum ToolbarPopupPosition {
  /// The flyout will be above the child, if there is enough space available
  above,

  /// The flyout will be below the child, if there is enough space available
  below,

  /// The flyout will be by the side of the child, if there is enough space
  /// available
  side,
}

/// How the flyout will be placed relatively to the child
enum ToolbarPopupPlacement {
  /// The flyout will be placed on the start point of the child.
  ///
  /// If the current directionality it's left-to-right, it's left. Otherwise,
  /// it's right
  start,

  /// The flyout will be placed on the center of the child.
  center,

  /// The flyout will be placed on the end point of the child.
  ///
  /// If the current directionality it's left-to-right, it's right. Otherwise,
  /// it's left
  end,
}

class ToolbarPopUp<T> extends StatefulWidget {
  const ToolbarPopUp({
    Key? key,
    required this.child,
    required this.content,
    this.verticalOffset = 0,
    this.horizontalOffset = 0,
    this.placement = ToolbarPopupPlacement.center,
    this.position = ToolbarPopupPosition.above,
  }) : super(key: key);

  final Widget child;
  final WidgetBuilder content;
  final double verticalOffset;
  final double horizontalOffset;
  final ToolbarPopupPlacement placement;
  final ToolbarPopupPosition position;

  @override
  ToolbarPopUpState<T> createState() => ToolbarPopUpState<T>();
}

class ToolbarPopUpState<T> extends State<ToolbarPopUp<T>> {
  _ToolbarPopUpRoute<T>? _dropdownRoute;

  Future<void> openPopup() {
    print(widget.key);
    assert(_dropdownRoute == null, 'You can NOT open a popup twice');
    final NavigatorState navigator = Navigator.of(context);
    final RenderBox itemBox = context.findRenderObject()! as RenderBox;
    Offset leftTarget = itemBox.localToGlobal(
      itemBox.size.centerLeft(Offset.zero),
      ancestor: navigator.context.findRenderObject(),
    );
    Offset centerTarget = itemBox.localToGlobal(
      itemBox.size.center(Offset.zero),
      ancestor: navigator.context.findRenderObject(),
    );
    Offset rightTarget = itemBox.localToGlobal(
      itemBox.size.centerRight(Offset.zero),
      ancestor: navigator.context.findRenderObject(),
    );

    assert(debugCheckHasDirectionality(context));

    final directionality = Directionality.of(context);
// The target according to the current directionality
    final Offset directionalityTarget = () {
      switch (widget.placement) {
        case ToolbarPopupPlacement.start:
          if (directionality == TextDirection.ltr) {
            return leftTarget;
          } else {
            return rightTarget;
          }
        case ToolbarPopupPlacement.end:
          if (directionality == TextDirection.ltr) {
            return rightTarget;
          } else {
            return leftTarget;
          }
        case ToolbarPopupPlacement.center:
          return centerTarget;
      }
    }();

    // The placement according to the current directionality
    final ToolbarPopupPlacement directionalityPlacement = () {
      switch (widget.placement) {
        case ToolbarPopupPlacement.start:
          if (directionality == TextDirection.rtl) {
            return ToolbarPopupPlacement.end;
          }
          continue next;
        case ToolbarPopupPlacement.end:
          if (directionality == TextDirection.rtl) {
            return ToolbarPopupPlacement.start;
          }
          continue next;
        next:
        default:
          return widget.placement;
      }
    }();

    final Rect itemRect = directionalityTarget & itemBox.size;
    _dropdownRoute = _ToolbarPopUpRoute<T>(
      target: centerTarget,
      placementOffset: directionalityTarget,
      placement: directionalityPlacement,
      position: widget.position,
      content: _PopupContentManager(content: widget.content),
      buttonRect: itemRect,
      elevation: 4,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      transitionAnimationDuration: const Duration(milliseconds: 100),
      verticalOffset: widget.verticalOffset,
      horizontalOffset: widget.horizontalOffset,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    );
    print(itemRect);
    return navigator.push(_dropdownRoute!).then((T? newValue) {
      removeToolbarPopUpRoute();
      if (!mounted || newValue == null) return;
    });
  }

  bool get isOpen => _dropdownRoute != null;

  void removeToolbarPopUpRoute() {
    _dropdownRoute?._dismiss();
    _dropdownRoute = null;
  }

  @override
  void dispose() {
    removeToolbarPopUpRoute();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    return widget.child;
  }
}

class _ToolbarPopUpMenu<T> extends StatefulWidget {
  const _ToolbarPopUpMenu({
    Key? key,
    required this.route,
    required this.buttonRect,
    required this.constraints,
    this.dropdownColor,
  }) : super(key: key);

  final _ToolbarPopUpRoute<T> route;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final Color? dropdownColor;

  @override
  _ToolbarPopUpMenuState<T> createState() => _ToolbarPopUpMenuState<T>();
}

class _ToolbarPopUpMenuState<T> extends State<_ToolbarPopUpMenu<T>> {
  late CurvedAnimation _fadeOpacity;

  @override
  void initState() {
    super.initState();
    _fadeOpacity = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0.0, 0.50),
      reverseCurve: const Interval(0.75, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeOpacity,
      child: Semantics(
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        child: widget.route.content,
      ),
    );
  }
}

class _ToolbarPopUpMenuRouteLayout<T> extends SingleChildLayoutDelegate {
  _ToolbarPopUpMenuRouteLayout({
    required this.buttonRect,
    required this.route,
    required this.textDirection,
    required this.target,
    required this.verticalOffset,
    required this.horizontalOffset,
    required this.placementOffset,
    required this.placement,
    required this.position,
  });

  final Rect buttonRect;
  final _ToolbarPopUpRoute<T> route;
  final TextDirection? textDirection;
  final Offset target;
  final double verticalOffset;
  final double horizontalOffset;
  final Offset placementOffset;
  final ToolbarPopupPlacement placement;
  final ToolbarPopupPosition position;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.loosen();
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final defaultOffset = position == ToolbarPopupPosition.side
        ? horizontalPositionDependentBox(
            size: size,
            childSize: childSize,
            target: target,
            verticalOffset: verticalOffset,
            margin: horizontalOffset,
            preferLeft: placement == ToolbarPopupPlacement.end,
          )
        : positionDependentBox(
            size: size,
            childSize: childSize,
            target: target,
            verticalOffset: verticalOffset,
            preferBelow: position == ToolbarPopupPosition.below,
            margin: horizontalOffset,
          );
    if (position == ToolbarPopupPosition.side) {
      return Offset(defaultOffset.dx, defaultOffset.dy);
    }
    switch (placement) {
      case ToolbarPopupPlacement.start:
        return Offset(placementOffset.dx, defaultOffset.dy);
      case ToolbarPopupPlacement.end:
        return Offset(placementOffset.dx - childSize.width, defaultOffset.dy);
      case ToolbarPopupPlacement.center:
        return defaultOffset;
    }
  }

  @override
  bool shouldRelayout(_ToolbarPopUpMenuRouteLayout<T> oldDelegate) {
    return oldDelegate.target == target ||
        oldDelegate.placementOffset == placementOffset ||
        buttonRect != oldDelegate.buttonRect;
  }
}

class _ToolbarPopUpRoute<T> extends PopupRoute<T> {
  _ToolbarPopUpRoute({
    required this.content,
    required this.buttonRect,
    required this.target,
    required this.placementOffset,
    required this.placement,
    this.elevation = 8,
    required this.capturedThemes,
    required this.transitionAnimationDuration,
    this.barrierLabel,
    required this.verticalOffset,
    required this.horizontalOffset,
    required this.position,
  });

  final Widget content;
  final Rect buttonRect;
  final int elevation;
  final CapturedThemes capturedThemes;
  final double verticalOffset;
  final double horizontalOffset;

  final Duration transitionAnimationDuration;

  final Offset target;
  final Offset placementOffset;
  final ToolbarPopupPlacement placement;
  final ToolbarPopupPosition position;

  @override
  Duration get transitionDuration => transitionAnimationDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(context, animation, secondaryAnimation) {
    return LayoutBuilder(builder: (context, constraints) {
      final page = _ToolbarPopUpRoutePage<T>(
        target: target,
        placementOffset: placementOffset,
        placement: placement,
        route: this,
        constraints: constraints,
        content: content,
        buttonRect: buttonRect,
        elevation: elevation,
        capturedThemes: capturedThemes,
        verticalOffset: verticalOffset,
        horizontalOffset: horizontalOffset,
        position: position,
      );
      return page;
    });
  }

  void _dismiss() {
    if (isActive) {
      navigator?.removeRoute(this);
    }
  }
}

class _ToolbarPopUpRoutePage<T> extends StatelessWidget {
  const _ToolbarPopUpRoutePage({
    Key? key,
    required this.route,
    required this.constraints,
    required this.content,
    required this.buttonRect,
    this.elevation = 8,
    required this.capturedThemes,
    required this.verticalOffset,
    required this.horizontalOffset,
    this.style,
    required this.target,
    required this.placement,
    required this.placementOffset,
    required this.position,
  }) : super(key: key);

  final _ToolbarPopUpRoute<T> route;
  final BoxConstraints constraints;
  final Widget content;
  final Rect buttonRect;
  final int elevation;
  final CapturedThemes capturedThemes;
  final TextStyle? style;
  final double verticalOffset;
  final double horizontalOffset;
  final Offset target;
  final Offset placementOffset;
  final ToolbarPopupPlacement placement;
  final ToolbarPopupPosition position;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    final TextDirection? textDirection = Directionality.maybeOf(context);
    final Widget menu = _ToolbarPopUpMenu<T>(
      route: route,
      buttonRect: buttonRect,
      constraints: constraints,
    );

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _ToolbarPopUpMenuRouteLayout<T>(
              target: target,
              placement: placement,
              position: position,
              placementOffset: placementOffset,
              buttonRect: buttonRect,
              route: route,
              textDirection: textDirection,
              verticalOffset: verticalOffset,
              horizontalOffset: horizontalOffset,
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }
}

class _PopupContentManager extends StatefulWidget {
  const _PopupContentManager({
    Key? key,
    required this.content,
  }) : super(key: key);

  final WidgetBuilder content;

  @override
  State<_PopupContentManager> createState() => __PopupContentManagerState();
}

class __PopupContentManagerState extends State<_PopupContentManager> {
  final GlobalKey key = GlobalKey();

  Size size = Size.zero;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final context = key.currentContext;
      if (context == null) return;
      final RenderBox box = context.findRenderObject() as RenderBox;
      setState(() => size = box.size);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: PopupContentSizeInfo(
        size: size,
        child: widget.content(context),
      ),
    );
  }
}

class PopupContentSizeInfo extends InheritedWidget {
  const PopupContentSizeInfo({
    Key? key,
    required Widget child,
    required this.size,
  }) : super(key: key, child: child);

  final Size size;

  static PopupContentSizeInfo of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PopupContentSizeInfo>()!;
  }

  static PopupContentSizeInfo? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PopupContentSizeInfo>();
  }

  @override
  bool updateShouldNotify(PopupContentSizeInfo oldWidget) {
    return oldWidget.size != size;
  }
}

Offset horizontalPositionDependentBox({
  required Size size,
  required Size childSize,
  required Offset target,
  required bool preferLeft,
  double verticalOffset = 0.0,
  double margin = 10.0,
}) {
  // Horizontal DIRECTION
  final bool fitsLeft =
      target.dx + verticalOffset + childSize.width <= size.width - margin;
  final bool fitsRight = target.dx - verticalOffset - childSize.width >= margin;
  final bool tooltipLeft =
      preferLeft ? fitsLeft || !fitsRight : !(fitsRight || !fitsLeft);
  double x;
  if (tooltipLeft) {
    x = math.min(target.dx + verticalOffset, size.width - margin);
  } else {
    x = math.max(target.dx - verticalOffset - childSize.width, margin);
  }
  // Vertical DIRECTION
  double y;
  if (size.height - margin * 2.0 < childSize.height) {
    y = (size.height - childSize.height) / 2.0;
  } else {
    final double normalizedTargetY =
        target.dy.clamp(margin, size.height - margin);
    final double edge = margin + childSize.height / 2.0;
    if (normalizedTargetY < edge) {
      y = margin;
    } else if (normalizedTargetY > size.height - edge) {
      y = size.height - margin - childSize.height;
    } else {
      y = normalizedTargetY - childSize.height / 2.0;
    }
  }
  return Offset(x, y);
}
