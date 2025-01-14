import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';

enum PulldownButtonState {
  enabled,
  hovered,
  pressed,
}

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuItemHeight = 20.0;
const double _kMenuDividerHeight = 10.0;
const EdgeInsets _kMenuItemPadding = EdgeInsets.symmetric(horizontal: 6.0);
const BorderRadius _kBorderRadius = BorderRadius.all(Radius.circular(5.0));
const double _kMenuLeftOffset = 8.0;

enum PulldownMenuAlignment {
  left,
  right,
}

// The widget that is the button wrapping the menu items.
class _MacosPulldownMenuItemButton extends StatefulWidget {
  // ignore: use_super_parameters
  const _MacosPulldownMenuItemButton({
    Key? key,
    this.padding,
    required this.route,
    required this.buttonRect,
    required this.constraints,
    required this.itemIndex,
  }) : super(key: key);

  final _MacosPulldownRoute route;
  final EdgeInsets? padding;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final int itemIndex;

  @override
  _MacosPulldownMenuItemButtonState createState() =>
      _MacosPulldownMenuItemButtonState();
}

class _MacosPulldownMenuItemButtonState
    extends State<_MacosPulldownMenuItemButton> {
  bool _isHovered = false;

  void _handleFocusChange(bool focused) {
    setState(() {
      if (focused) {
        _isHovered = true;
      } else {
        _isHovered = false;
      }
    });
  }

  void _handleOnTap() {
    final MacosPulldownMenuEntry menuEntity =
        widget.route.items[widget.itemIndex].item!;
    if (menuEntity is MacosPulldownMenuItem) {
      Navigator.of(context).pop();
      menuEntity.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final MacosThemeData theme = MacosTheme.of(context);
    final brightness = MacosTheme.brightnessOf(context);
    final MacosPulldownMenuEntry menuEntity =
        widget.route.items[widget.itemIndex].item!;
    if (menuEntity is MacosPulldownMenuItem) {
      Widget child = Container(
        padding: widget.padding,
        height: widget.route.itemHeight,
        child: widget.route.items[widget.itemIndex],
      );
      if (menuEntity.enabled) {
        child = MouseRegion(
          cursor: SystemMouseCursors.basic,
          onEnter: (_) {
            setState(() => _isHovered = true);
          },
          onExit: (_) {
            setState(() => _isHovered = false);
          },
          child: GestureDetector(
            onTap: _handleOnTap,
            child: Focus(
              onKeyEvent: (FocusNode node, KeyEvent event) {
                if (event.logicalKey == LogicalKeyboardKey.enter) {
                  _handleOnTap();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              onFocusChange: _handleFocusChange,
              child: Container(
                decoration: BoxDecoration(
                  color: _isHovered
                      ? MacosPulldownButtonTheme.of(context).highlightColor
                      : Colors.transparent,
                  borderRadius: _kBorderRadius,
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 13.0,
                    color: _isHovered
                        ? MacosColors.white
                        : brightness.resolve(
                            MacosColors.black,
                            MacosColors.white,
                          ),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        );
      } else {
        final textColor = brightness.resolve(
          MacosColors.disabledControlTextColor,
          MacosColors.disabledControlTextColor.darkColor,
        );
        child = DefaultTextStyle(
          style: theme.typography.body.copyWith(color: textColor),
          child: child,
        );
      }
      return child;
    } else {
      return menuEntity;
    }
  }
}

class _MacosPulldownMenu extends StatefulWidget {
  // ignore: use_super_parameters
  const _MacosPulldownMenu({
    Key? key,
    this.padding,
    required this.route,
    required this.buttonRect,
    required this.constraints,
  }) : super(key: key);

  final _MacosPulldownRoute route;
  final EdgeInsets? padding;
  final Rect buttonRect;
  final BoxConstraints constraints;

  @override
  _MacosPulldownMenuState createState() => _MacosPulldownMenuState();
}

class _MacosPulldownMenuState extends State<_MacosPulldownMenu> {
  late CurvedAnimation _fadeOpacity;

  @override
  void initState() {
    super.initState();
    // We need to hold these animations as state because of their curve
    // direction. When the route's animation reverses, if we were to recreate
    // the CurvedAnimation objects in build, we'd lose
    // CurvedAnimation._curveDirection.
    _fadeOpacity = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0.0, 0.25),
      reverseCurve: const Interval(0.75, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _MacosPulldownRoute route = widget.route;
    final List<Widget> children = <Widget>[
      for (int itemIndex = 0; itemIndex < route.items.length; ++itemIndex)
        _MacosPulldownMenuItemButton(
          route: widget.route,
          padding: widget.padding,
          buttonRect: widget.buttonRect,
          constraints: widget.constraints,
          itemIndex: itemIndex,
        ),
    ];

    return FadeTransition(
      opacity: _fadeOpacity,
      child: Semantics(
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        child: IntrinsicWidth(
          child: MacosOverlayFilter(
            color: MacosPulldownButtonTheme.of(context)
                .pulldownColor
                ?.withValues(alpha: 0.25),
            borderRadius: _kBorderRadius,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MacosPulldownMenuRouteLayout extends SingleChildLayoutDelegate {
  _MacosPulldownMenuRouteLayout({
    required this.buttonRect,
    required this.route,
    required this.textDirection,
    required this.menuAlignment,
  });

  final Rect buttonRect;
  final _MacosPulldownRoute route;
  final TextDirection? textDirection;
  final PulldownMenuAlignment menuAlignment;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: kMinInteractiveDimension,
      maxWidth: constraints.maxWidth,
      maxHeight: constraints.maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final _MenuLimits menuLimits = route.getMenuLimits(buttonRect, size.height);

    assert(() {
      final Rect container = Offset.zero & size;
      if (container.intersect(buttonRect) == buttonRect) {
        // If the button was entirely on-screen, then verify
        // that the menu is also on-screen.
        // If the button was a bit off-screen, then, oh well.
        assert(menuLimits.top >= 0.0);
        assert(menuLimits.top + menuLimits.height <= size.height);
      }
      return true;
    }());
    assert(textDirection != null);
    double left;
    switch (menuAlignment) {
      case PulldownMenuAlignment.left:
        switch (textDirection!) {
          case TextDirection.rtl:
            left = buttonRect.right.clamp(0.0, size.width) - childSize.width;
            break;
          case TextDirection.ltr:
            left = buttonRect.left + _kMenuLeftOffset;
            break;
        }
        break;
      case PulldownMenuAlignment.right:
        switch (textDirection!) {
          case TextDirection.rtl:
            left = buttonRect.left + _kMenuLeftOffset;
            break;
          case TextDirection.ltr:
            left = buttonRect.left - childSize.width + buttonRect.width;
            break;
        }
        break;
    }
    if (left + childSize.width >= size.width) {
      left = left.clamp(0.0, size.width - childSize.width) - _kMenuLeftOffset;
    }
    return Offset(left, menuLimits.top);
  }

  @override
  bool shouldRelayout(_MacosPulldownMenuRouteLayout oldDelegate) {
    return buttonRect != oldDelegate.buttonRect ||
        textDirection != oldDelegate.textDirection;
  }
}

class _MenuLimits {
  const _MenuLimits(
    this.top,
    this.bottom,
    this.height,
  );
  final double top;
  final double bottom;
  final double height;
}

class _MacosPulldownRoute extends PopupRoute {
  _MacosPulldownRoute({
    required this.items,
    required this.padding,
    required this.buttonRect,
    required this.capturedThemes,
    required this.style,
    this.barrierLabel,
    this.itemHeight,
    required this.menuAlignment,
  }) : itemHeights = List<double>.filled(
          items.length,
          itemHeight ?? _kMenuItemHeight,
        );

  final List<_MenuItem> items;
  final EdgeInsetsGeometry padding;
  final Rect buttonRect;
  final CapturedThemes capturedThemes;
  final TextStyle style;
  final double? itemHeight;
  final PulldownMenuAlignment menuAlignment;
  final List<double> itemHeights;

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _MacosPulldownRoutePage(
          route: this,
          constraints: constraints,
          items: items,
          padding: padding,
          buttonRect: buttonRect,
          capturedThemes: capturedThemes,
          style: style,
          menuAlignment: menuAlignment,
        );
      },
    );
  }

  void _dismiss() {
    if (isActive) {
      navigator?.removeRoute(this);
    }
  }

  _MenuLimits getMenuLimits(
    Rect buttonRect,
    double availableHeight,
  ) {
    double computedMaxHeight = availableHeight - 2.0 * _kMenuItemHeight;

    final double buttonTop = buttonRect.top;
    final double buttonBottom = math.min(buttonRect.bottom, availableHeight);

    // If the button is placed on the bottom or top of the screen, its top or
    // bottom may be less than [_kMenuItemHeight] from the edge of the screen.
    // In this case, we want to change the menu limits to align with the top
    // or bottom edge of the button.
    final double bottomLimit =
        math.max(availableHeight - _kMenuItemHeight, buttonBottom);

    double menuTop = buttonTop + buttonRect.height;
    double preferredMenuHeight = 8.0;
    if (items.isNotEmpty) {
      preferredMenuHeight +=
          itemHeights.reduce((double total, double height) => total + height);
    }

    // If there are too many elements in the menu, we need to shrink it down
    // so it is at most the computedMaxHeight.
    final double menuHeight = math.min(computedMaxHeight, preferredMenuHeight);
    double menuBottom = menuTop + menuHeight;

    if (menuBottom > bottomLimit) {
      // Move the menu above the button and add some margin.
      menuBottom = buttonTop - 5.0;
      menuTop = buttonTop - menuHeight - 5.0;
    } else {
      menuBottom += 1.0;
      menuTop += 1.0;
    }

    assert((menuBottom - menuTop - menuHeight).abs() < precisionErrorTolerance);
    return _MenuLimits(
      menuTop,
      menuBottom,
      menuHeight,
    );
  }
}

class _MacosPulldownRoutePage extends StatelessWidget {
  // ignore: use_super_parameters
  const _MacosPulldownRoutePage({
    Key? key,
    required this.route,
    required this.constraints,
    this.items,
    required this.padding,
    required this.buttonRect,
    required this.capturedThemes,
    this.style,
    required this.menuAlignment,
  }) : super(key: key);

  final _MacosPulldownRoute route;
  final BoxConstraints constraints;
  final List<_MenuItem>? items;
  final EdgeInsetsGeometry padding;
  final Rect buttonRect;
  final CapturedThemes capturedThemes;
  final TextStyle? style;
  final PulldownMenuAlignment menuAlignment;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    final TextDirection? textDirection = Directionality.maybeOf(context);
    final Widget menu = _MacosPulldownMenu(
      route: route,
      padding: padding.resolve(textDirection),
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
            delegate: _MacosPulldownMenuRouteLayout(
              buttonRect: buttonRect,
              route: route,
              textDirection: textDirection,
              menuAlignment: menuAlignment,
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }
}

// This widget enables _MacosPulldownRoute to look up the sizes of
// each menu item.
class _MenuItem extends SingleChildRenderObjectWidget {
  // ignore: use_super_parameters
  const _MenuItem({
    Key? key,
    required this.onLayout,
    this.item,
  }) : super(key: key, child: item);

  final ValueChanged<Size> onLayout;

  final MacosPulldownMenuEntry? item;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(onLayout);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMenuItem renderObject,
  ) {
    renderObject.onLayout = onLayout;
  }
}

class _RenderMenuItem extends RenderProxyBox {
  _RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  void performLayout() {
    super.performLayout();
    onLayout(size);
  }
}

/// An entry in a menu created by a [MacosPulldownButton]. It can be either a
/// [MacosPulldownMenuItem] or a [MacosPulldownMenuDivider].
abstract class MacosPulldownMenuEntry extends Widget {
  const MacosPulldownMenuEntry({super.key});

  double get itemHeight;
}

/// A divider (horizontal line) in a menu created by a [MacosPulldownButton].
class MacosPulldownMenuDivider extends StatelessWidget
    implements MacosPulldownMenuEntry {
  /// Creates a divider for a macOS-style pulldown menu.
  const MacosPulldownMenuDivider({super.key});

  @override
  double get itemHeight => _kMenuDividerHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kMenuDividerHeight,
      padding: _kMenuItemPadding,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          color: MacosTheme.of(context).brightness.resolve(
                MacosColors.disabledControlTextColor,
                MacosColors.disabledControlTextColor.darkColor,
              ),
          height: 0.5,
        ),
      ),
    );
  }
}

/// An item in a menu created by a [MacosPulldownButton], typically a [Text]
/// widget.
class MacosPulldownMenuItem extends StatelessWidget
    implements MacosPulldownMenuEntry {
  /// Creates an item for a macOS-style pulldown menu.
  const MacosPulldownMenuItem({
    super.key,
    required this.title,
    this.onTap,
    this.enabled = true,
    this.alignment = AlignmentDirectional.centerStart,
    this.label,
  });

  @override
  double get itemHeight => _kMenuItemHeight;

  /// The widget to use as a menu item.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Called when the pulldown menu item is tapped.
  final VoidCallback? onTap;

  /// Whether or not a user can select this menu item.
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// Defines how the item is positioned within the container.
  ///
  /// This property must not be null. It defaults to [AlignmentDirectional.centerStart].
  final AlignmentGeometry alignment;

  /// An optional label to describe the action of this menu item.
  ///
  /// It must be set when the pulldown menu is used in the toolbar.
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: _kMenuItemHeight),
      alignment: alignment,
      child: title,
    );
  }
}

/// A macOS-style pull-down button.
///
/// A pull-down button (often referred to as a pull-down menu) is a type of
/// pop-up button that, when clicked, displays a menu containing a list of
/// choices. The menu appears below the button.
///
/// Use a pull-down button to present a list of commands.
///
/// A pull-down button can either show a [title] or an [icon] to describe the
/// contents of the button's menu. If you use an icon, make sure it clearly
/// communicates the button’s purpose.
///
/// See also:
///
///  * [MacosPulldownMenuItem], the class used to represent the menu options.
///  * [MacosPulldownMenuDivider], the class used to represent a horizontal
///    divider for the menu.
class MacosPulldownButton extends StatefulWidget {
  /// Creates a macOS-style pull-down button.
  ///
  /// If [items] is null, the button will be disabled, the down caret
  /// icon will be greyed out.
  ///
  /// A [title] or an [icon] must be provided, to be displayed as the
  /// pull-down button's title, but not both at the same time.
  ///
  /// If the button is disabled and [icon] is null, [disabledTitle] will be
  /// displayed if it is non-null. If [disabledTitle] is null, then [title]
  /// will be displayed if it is non-null.
  ///
  /// The [autofocus] argument must not be null.
  const MacosPulldownButton({
    super.key,
    required this.items,
    this.title,
    this.disabledTitle,
    this.icon,
    this.onTap,
    this.style,
    this.itemHeight = _kMenuItemHeight,
    this.focusNode,
    this.autofocus = false,
    this.alignment = AlignmentDirectional.centerStart,
    this.menuAlignment = PulldownMenuAlignment.left,
  })  : assert(itemHeight == null || itemHeight >= _kMenuItemHeight),
        assert(
            (title != null || icon != null) && !(title != null && icon != null),
            "There should be either a title or an icon argument provided, and not both at at the same time.");

  /// The list of menu entries for the pull-down menu.
  ///
  /// Can be either [MacosPulldownMenuItem]s or [MacosPulldownMenuDivider]s.
  ///
  /// If the list of items is null, then the pull-down button will be disabled,
  /// i.e. it will be displayed in grey and not respond to input.
  final List<MacosPulldownMenuEntry>? items;

  /// The text to display as title for the pull-down button.
  ///
  /// If this is provided, [icon] should be null.
  ///
  /// If the pull-down is disabled and [disabledTitle] is null, then this
  /// is displayed instead.
  final String? title;

  /// The text that is displayed when the pull-down is disabled.
  ///
  /// If the pulldown is disabled ([items] is null), this is displayed as a
  /// title for the pull-down button.
  final String? disabledTitle;

  /// An icon to use as title for the pull-down button. Makes the pull-down
  /// button behave and render as an icon-button with a caret.
  ///
  /// If this is provided, [title] should be null.
  ///
  /// It is recommended to use icons from the CupertinoIcons library for this.
  final IconData? icon;

  /// Called when the pull-down button is tapped.
  ///
  /// The callback will not be invoked if the pull-down button is disabled.
  final VoidCallback? onTap;

  /// The text style to use for text in the pull-down button and the pull-down
  /// menu that appears when you tap the button.
  ///
  /// Defaults to MacosTheme.of(context).typography.body.
  final TextStyle? style;

  /// If null, then the menu item heights will vary according to each menu
  /// item's intrinsic height.
  ///
  /// The default value is [_kMenuItemHeight], which is also the minimum
  /// height for menu items.
  final double? itemHeight;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Defines how the title is positioned within the button.
  ///
  /// This property must not be null. It defaults to [AlignmentDirectional.centerStart].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  /// Defines the pulldown menu's alignment relevant to the button.
  ///
  /// Defaults to [PulldownMenuAlignment.left].
  final PulldownMenuAlignment menuAlignment;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty(
      'itemHeight',
      itemHeight,
    ));
    properties.add(
      FlagProperty('hasAutofocus', value: autofocus, ifFalse: 'noAutofocus'),
    );
    properties.add(DiagnosticsProperty('alignment', alignment));
    properties.add(DiagnosticsProperty('menuAlignment', menuAlignment));
  }

  @override
  State<MacosPulldownButton> createState() => _MacosPulldownButtonState();
}

class _MacosPulldownButtonState extends State<MacosPulldownButton>
    with WidgetsBindingObserver {
  _MacosPulldownRoute? _pulldownRoute;
  FocusNode? _internalNode;
  FocusNode? get focusNode => widget.focusNode ?? _internalNode;
  bool _hasPrimaryFocus = false;
  late Map<Type, Action<Intent>> _actionMap;
  late FocusHighlightMode _focusHighlightMode;
  PulldownButtonState _pullDownButtonState = PulldownButtonState.enabled;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _internalNode ??= _createFocusNode();
    }
    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => _handleTap(),
      ),
      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
        onInvoke: (ButtonActivateIntent intent) => _handleTap(),
      ),
    };
    focusNode!.addListener(_handleFocusChanged);
    final FocusManager focusManager = WidgetsBinding.instance.focusManager;
    _focusHighlightMode = focusManager.highlightMode;
    focusManager.addHighlightModeListener(_handleFocusHighlightModeChange);
  }

  @override
  void didUpdateWidget(MacosPulldownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      if (widget.focusNode == null) {
        _internalNode ??= _createFocusNode();
      }
      _hasPrimaryFocus = focusNode!.hasPrimaryFocus;
      focusNode!.addListener(_handleFocusChanged);
    }
  }

  // Only used if needed to create _internalNode.
  FocusNode _createFocusNode() {
    return FocusNode(debugLabel: '${widget.runtimeType}');
  }

  void _removeMacosPulldownRoute() {
    _pulldownRoute?._dismiss();
    _pulldownRoute = null;
  }

  void _handleFocusChanged() {
    if (_hasPrimaryFocus != focusNode!.hasPrimaryFocus) {
      setState(() => _hasPrimaryFocus = focusNode!.hasPrimaryFocus);
    }
  }

  void _handleFocusHighlightModeChange(FocusHighlightMode mode) {
    if (!mounted) {
      return;
    }
    setState(() => _focusHighlightMode = mode);
  }

  TextStyle? get _textStyle =>
      widget.style ?? MacosTheme.of(context).typography.body;

  void _handleTap() {
    final TextDirection? textDirection = Directionality.maybeOf(context);
    const EdgeInsetsGeometry menuMargin = EdgeInsets.symmetric(horizontal: 4.0);

    final List<_MenuItem> menuItems = <_MenuItem>[
      for (int index = 0; index < widget.items!.length; index += 1)
        _MenuItem(
          item: widget.items![index],
          onLayout: (Size size) {
            // If [_pulldownRoute] is null and onLayout is called, this means
            // that performLayout was called on a _MacosPulldownRoute that has not
            // left the widget tree but is already on its way out.
            //
            // Since onLayout is used primarily to collect the desired heights
            // of each menu item before laying them out, not having the _MacosPulldownRoute
            // collect each item's height to lay out is fine since the route is
            // already on its way out.
            if (_pulldownRoute == null) return;

            _pulldownRoute!.itemHeights[index] = size.height;
          },
        ),
    ];

    setState(() => _pullDownButtonState = PulldownButtonState.pressed);

    final NavigatorState navigator = Navigator.of(context);
    assert(_pulldownRoute == null);
    final RenderBox itemBox = context.findRenderObject()! as RenderBox;
    final Rect itemRect = itemBox.localToGlobal(
          Offset.zero,
          ancestor: navigator.context.findRenderObject(),
        ) &
        itemBox.size;
    _pulldownRoute = _MacosPulldownRoute(
      items: menuItems,
      buttonRect: menuMargin.resolve(textDirection).inflateRect(itemRect),
      padding: _kMenuItemPadding.resolve(textDirection),
      capturedThemes:
          InheritedTheme.capture(from: context, to: navigator.context),
      style: _textStyle!,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      itemHeight: widget.itemHeight,
      menuAlignment: widget.menuAlignment,
    );

    navigator.push(_pulldownRoute!).then<void>((_) {
      setState(() => _pullDownButtonState = PulldownButtonState.enabled);
      _removeMacosPulldownRoute();
      if (!mounted) return;
    });

    widget.onTap?.call();
  }

  bool get _enabled => widget.items != null && widget.items!.isNotEmpty;

  bool get _hasIcon => widget.icon != null && widget.title == null;

  bool get _showHighlight {
    switch (_focusHighlightMode) {
      case FocusHighlightMode.touch:
        return false;
      case FocusHighlightMode.traditional:
        return _hasPrimaryFocus;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeMacosPulldownRoute();
    WidgetsBinding.instance.focusManager
        .removeHighlightModeListener(_handleFocusHighlightModeChange);
    focusNode!.removeListener(_handleFocusChanged);
    _internalNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonHeight = _hasIcon ? 28.0 : 20.0;
    final borderRadius = _hasIcon
        ? const BorderRadius.all(Radius.circular(7.0))
        : _kBorderRadius;
    final buttonStyles =
        _getButtonStyles(_pullDownButtonState, _enabled, _hasIcon, context);

    Widget result = Container(
      decoration: _showHighlight
          ? BoxDecoration(
              color: MacosColors.findHighlightColor,
              borderRadius: borderRadius,
            )
          : BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: buttonStyles.borderColor,
                  offset: const Offset(0, 0.5),
                  blurRadius: 0.2,
                  spreadRadius: 0,
                ),
              ],
              border: Border.all(width: 0.5, color: buttonStyles.borderColor),
              color: buttonStyles.bgColor,
              borderRadius: borderRadius,
            ),
      padding: const EdgeInsets.only(left: 8.0, right: 2.0),
      height: buttonHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _hasIcon
              ? MacosIcon(widget.icon!, color: buttonStyles.textColor)
              : _enabled
                  ? Text(
                      widget.title!,
                      style: TextStyle(color: buttonStyles.textColor),
                    )
                  : Text(
                      widget.disabledTitle ?? widget.title!,
                      style: TextStyle(color: buttonStyles.textColor),
                    ),
          Padding(
            padding: EdgeInsets.only(left: _hasIcon ? 2.0 : 8.0),
            child: SizedBox(
              height: 16.0,
              width: 16.0,
              child: CustomPaint(
                painter: _DownCaretPainter(
                  color: buttonStyles.caretColor,
                  backgroundColor: buttonStyles.caretBgColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Semantics(
      button: true,
      child: Actions(
        actions: _actionMap,
        child: Focus(
          canRequestFocus: _enabled,
          focusNode: focusNode,
          autofocus: widget.autofocus,
          child: MouseRegion(
            cursor: SystemMouseCursors.basic,
            onEnter: (_) => setState(
              () => _pullDownButtonState = PulldownButtonState.hovered,
            ),
            onExit: (_) {
              setState(() {
                if (_pullDownButtonState == PulldownButtonState.hovered) {
                  _pullDownButtonState = PulldownButtonState.enabled;
                }
              });
            },
            child: GestureDetector(
              onTap: _enabled ? _handleTap : null,
              behavior: HitTestBehavior.opaque,
              child: result,
            ),
          ),
        ),
      ),
    );
  }
}

// Pull-down buttons styling can be differentiated according to:
//
// pullDownButtonState: a button can be either enabled, hovered, or pressed.
// enabled: if a button is disabled (greyed out) or not.
// hasIcon: if it has a string or an icon as its title.
//
// We use this utility function to get the appropriate styling, according to the
// macOS Design Guidelines and the current MacosPulldownButtonTheme.
_ButtonStyles _getButtonStyles(
  PulldownButtonState pullDownButtonState,
  bool enabled,
  bool hasIcon,
  BuildContext context,
) {
  final theme = MacosTheme.of(context);
  final brightness = theme.brightness;
  final pulldownTheme = MacosPulldownButtonTheme.of(context);
  Color textColor = theme.typography.body.color!;
  Color bgColor = pulldownTheme.backgroundColor!;
  Color borderColor = brightness.resolve(
    const Color(0xffc3c4c9),
    const Color(0xff222222),
  );
  Color caretColor = MacosColors.white;
  Color caretBgColor = pulldownTheme.highlightColor!;
  Color iconColor = pulldownTheme.iconColor!;
  if (!enabled) {
    caretBgColor = MacosColors.transparent;
    if (hasIcon) {
      textColor = caretColor = brightness.resolve(
        const Color.fromRGBO(0, 0, 0, 0.3),
        const Color.fromRGBO(255, 255, 255, 0.3),
      );
      bgColor = borderColor = MacosColors.transparent;
    } else {
      textColor = caretColor = brightness.resolve(
        MacosColors.disabledControlTextColor.color,
        MacosColors.disabledControlTextColor.darkColor,
      );
      bgColor = brightness.resolve(
        const Color(0xfff2f3f5),
        const Color(0xff3f4046),
      );
      borderColor = brightness.resolve(
        const Color(0xff979797),
        const Color(0xff222222),
      );
    }
  } else {
    if (hasIcon) {
      borderColor = caretBgColor = MacosColors.transparent;
      switch (pullDownButtonState) {
        case PulldownButtonState.enabled:
          textColor = caretColor = iconColor;
          bgColor = MacosColors.transparent;
          break;
        case PulldownButtonState.hovered:
          textColor = caretColor = iconColor;
          bgColor = brightness.resolve(
            const Color(0xfff4f5f5),
            const Color(0xff323232),
          );
          break;
        case PulldownButtonState.pressed:
          textColor = caretColor = iconColor.withValues(alpha: 0.85);
          bgColor = brightness.resolve(
            const Color.fromRGBO(0, 0, 0, 0.1),
            const Color.fromRGBO(255, 255, 255, 0.1),
          );
          break;
      }
    } else {
      switch (pullDownButtonState) {
        case PulldownButtonState.enabled:
          borderColor = brightness.resolve(
            const Color(0xffc3c4c9),
            const Color(0xff222222),
          );
          caretBgColor = pulldownTheme.highlightColor!;
          break;
        case PulldownButtonState.hovered:
          break;
        case PulldownButtonState.pressed:
          bgColor = pulldownTheme.backgroundColor!.withValues(alpha: 0.4);
          caretBgColor = pulldownTheme.highlightColor!.withValues(alpha: 0.9);
          break;
      }
    }
  }
  return _ButtonStyles(
    textColor: textColor,
    bgColor: bgColor,
    borderColor: borderColor,
    caretColor: caretColor,
    caretBgColor: caretBgColor,
  );
}

class _ButtonStyles {
  _ButtonStyles({
    required this.textColor,
    required this.bgColor,
    required this.borderColor,
    required this.caretColor,
    required this.caretBgColor,
  });

  Color textColor;
  Color bgColor;
  Color borderColor;
  Color caretColor;
  Color caretBgColor;
}

class _DownCaretPainter extends CustomPainter {
  const _DownCaretPainter({
    required this.color,
    required this.backgroundColor,
  });

  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    const radius = 4.0;
    final hPadding = size.height / 3;

    /// Draw background
    canvas.drawRRect(
      BorderRadius.circular(radius).toRRect(Offset.zero & size),
      Paint()..color = backgroundColor,
    );

    /// Draw carets
    final p1 = Offset(hPadding, size.height / 2 - 1.0);
    final p2 = Offset(size.width / 2, size.height / 2 + 2.0);
    final p3 = Offset(size.width / 2 + 1.0, size.height / 2 + 1.0);
    final p4 = Offset(size.width - hPadding, size.height / 2 - 1.0);
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.75;
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p3, p4, paint);
  }

  @override
  bool shouldRepaint(_DownCaretPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_DownCaretPainter oldDelegate) => false;
}
