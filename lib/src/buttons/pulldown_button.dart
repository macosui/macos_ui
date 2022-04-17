import 'dart:math' as math;
import 'dart:ui';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

//TODO: Separators?
//TODO: Image as hint
//TODO: MacosPopupButton remove Orientation-related code in build functions
//TODO: MacosPopupButton kBorderRadius: 5.0
//TODO: MacosPopupButton refactor menupainter borders and shadow
//TODO: MacosPopupButton change button shadow colors and border width
//TODO: MacosPopupButton refactor constants
//TODO: MacosPopupButton refactor disabled colors
//TODO: placement behavior and screen over draw (https://github.com/flutter/flutter/issues/30701)

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuItemHeight = 20.0;
const double _kMenuDividerHeight = 10.0;
const double _kMinInteractiveDimension = 24.0;
const EdgeInsets _kMenuItemPadding = EdgeInsets.symmetric(horizontal: 5.0);
const BorderRadius _kBorderRadius = BorderRadius.all(Radius.circular(5.0));
const double _kPulldownButtonHeight = 20.0;
const double _kMenuLeftOffset = 8.0;

// The widget that is the button wrapping the menu items.
class _MacosPulldownMenuItemButton<T> extends StatefulWidget {
  const _MacosPulldownMenuItemButton({
    Key? key,
    this.padding,
    required this.route,
    required this.buttonRect,
    required this.constraints,
    required this.itemIndex,
  }) : super(key: key);

  final _MacosPulldownRoute<T> route;
  final EdgeInsets? padding;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final int itemIndex;

  @override
  _MacosPulldownMenuItemButtonState<T> createState() =>
      _MacosPulldownMenuItemButtonState<T>();
}

class _MacosPulldownMenuItemButtonState<T>
    extends State<_MacosPulldownMenuItemButton<T>> {
  bool _isHovered = false;

  void _handleFocusChange(bool focused) {
    if (focused) {
      setState(() {
        _isHovered = true;
      });
    } else {
      setState(() {
        _isHovered = false;
      });
    }
  }

  void _handleOnTap() {
    final MacosPulldownMenuEntry menuEntity =
        widget.route.items[widget.itemIndex].item!;
    if (menuEntity is MacosPulldownMenuItem) {
      menuEntity.onTap?.call();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);
    final MacosThemeData theme = MacosTheme.of(context);
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
              onKey: (FocusNode node, RawKeyEvent event) {
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
                      ? theme.macosPulldownButtonTheme.highlightColor
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
        final textColor = MacosTheme.of(context).brightness.resolve(
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

class _MacosPulldownMenu<T> extends StatefulWidget {
  const _MacosPulldownMenu({
    Key? key,
    this.padding,
    required this.route,
    required this.buttonRect,
    required this.constraints,
    this.pulldownColor,
  }) : super(key: key);

  final _MacosPulldownRoute<T> route;
  final EdgeInsets? padding;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final Color? pulldownColor;

  @override
  _MacosPulldownMenuState<T> createState() => _MacosPulldownMenuState<T>();
}

class _MacosPulldownMenuState<T> extends State<_MacosPulldownMenu<T>> {
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
    final _MacosPulldownRoute<T> route = widget.route;
    final List<Widget> children = <Widget>[
      for (int itemIndex = 0; itemIndex < route.items.length; ++itemIndex)
        _MacosPulldownMenuItemButton<T>(
          route: widget.route,
          padding: widget.padding,
          buttonRect: widget.buttonRect,
          constraints: widget.constraints,
          itemIndex: itemIndex,
        ),
    ];
    final brightness = MacosTheme.brightnessOf(context);
    final pulldownColor = MacosDynamicColor.maybeResolve(
      widget.pulldownColor ??
          MacosTheme.of(context).macosPulldownButtonTheme.pulldownColor,
      context,
    );

    return FadeTransition(
      opacity: _fadeOpacity,
      child: Container(
        decoration: BoxDecoration(
          color: pulldownColor,
          boxShadow: [
            BoxShadow(
              color: brightness
                  .resolve(
                    CupertinoColors.systemGrey.color,
                    CupertinoColors.black,
                  )
                  .withOpacity(0.25),
              offset: const Offset(0, 4),
              spreadRadius: 4.0,
              blurRadius: 8.0,
            ),
          ],
          border: Border.all(
            color: brightness.resolve(
              CupertinoColors.systemGrey3.color,
              CupertinoColors.systemGrey3.darkColor,
            ),
          ),
          borderRadius: _kBorderRadius,
        ),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          child: IntrinsicWidth(
            child: ClipRRect(
              borderRadius: _kBorderRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MacosPulldownMenuRouteLayout<T> extends SingleChildLayoutDelegate {
  _MacosPulldownMenuRouteLayout({
    required this.buttonRect,
    required this.route,
    required this.textDirection,
  });

  final Rect buttonRect;
  final _MacosPulldownRoute<T> route;
  final TextDirection? textDirection;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The maximum height of a simple menu should be one or more rows less than
    // the view height. This ensures a tappable area outside of the simple menu
    // with which to dismiss the menu.
    double maxHeight = constraints.maxHeight;
    if (route.menuMaxHeight != null && route.menuMaxHeight! <= maxHeight) {
      maxHeight = route.menuMaxHeight!;
    }

    return BoxConstraints(
      minWidth: kMinInteractiveDimension,
      maxWidth: constraints.maxWidth,
      maxHeight: maxHeight,
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
    final double left;
    switch (textDirection!) {
      case TextDirection.rtl:
        left = buttonRect.right.clamp(0.0, size.width) - childSize.width;
        break;
      case TextDirection.ltr:
        left = buttonRect.left;
        break;
    }

    return Offset(left + _kMenuLeftOffset, menuLimits.top);
  }

  @override
  bool shouldRelayout(_MacosPulldownMenuRouteLayout<T> oldDelegate) {
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

class _MacosPulldownRoute<T> extends PopupRoute {
  _MacosPulldownRoute({
    required this.items,
    required this.padding,
    required this.buttonRect,
    this.elevation = 8,
    required this.capturedThemes,
    required this.style,
    this.barrierLabel,
    this.itemHeight,
    this.pulldownColor,
    this.menuMaxHeight,
  }) : itemHeights = List<double>.filled(
          items.length,
          itemHeight ?? _kMinInteractiveDimension,
        );

  final List<_MenuItem> items;
  final EdgeInsetsGeometry padding;
  final Rect buttonRect;
  final int elevation;
  final CapturedThemes capturedThemes;
  final TextStyle style;
  final double? itemHeight;
  final Color? pulldownColor;
  final double? menuMaxHeight;

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
        return _MacosPulldownRoutePage<T>(
          route: this,
          constraints: constraints,
          items: items,
          padding: padding,
          buttonRect: buttonRect,
          elevation: elevation,
          capturedThemes: capturedThemes,
          style: style,
          pulldownColor: pulldownColor,
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
    if (menuMaxHeight != null) {
      computedMaxHeight = math.min(computedMaxHeight, menuMaxHeight!);
    }

    final double buttonTop = buttonRect.top;
    final double buttonBottom = math.min(buttonRect.bottom, availableHeight);

    // If the button is placed on the bottom or top of the screen, its top or
    // bottom may be less than [_kMenuItemHeight] from the edge of the screen.
    // In this case, we want to change the menu limits to align with the top
    // or bottom edge of the button.
    final double bottomLimit =
        math.max(availableHeight - _kMenuItemHeight, buttonBottom);

    double menuTop = buttonTop + _kMenuItemHeight;
    double preferredMenuHeight = 8.0;
    if (items.isNotEmpty)
      preferredMenuHeight +=
          itemHeights.reduce((double total, double height) => total + height);

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

class _MacosPulldownRoutePage<T> extends StatelessWidget {
  const _MacosPulldownRoutePage({
    Key? key,
    required this.route,
    required this.constraints,
    this.items,
    required this.padding,
    required this.buttonRect,
    this.elevation = 8,
    required this.capturedThemes,
    this.style,
    required this.pulldownColor,
  }) : super(key: key);

  final _MacosPulldownRoute<T> route;
  final BoxConstraints constraints;
  final List<_MenuItem>? items;
  final EdgeInsetsGeometry padding;
  final Rect buttonRect;
  final int elevation;
  final CapturedThemes capturedThemes;
  final TextStyle? style;
  final Color? pulldownColor;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    final TextDirection? textDirection = Directionality.maybeOf(context);
    final Widget menu = _MacosPulldownMenu<T>(
      route: route,
      padding: padding.resolve(textDirection),
      buttonRect: buttonRect,
      constraints: constraints,
      pulldownColor: pulldownColor,
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
            delegate: _MacosPulldownMenuRouteLayout<T>(
              buttonRect: buttonRect,
              route: route,
              textDirection: textDirection,
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }
}

// This widget enables _MacosPulldownRoute to look up the sizes of
// each menu item. These sizes are used to compute the offset of the selected
// item so that _MacosPulldownRoutePage can align the vertical center of the
// selected item lines up with the vertical center of the pulldown button,
// as closely as possible.
class _MenuItem extends SingleChildRenderObjectWidget {
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

abstract class MacosPulldownMenuEntry extends Widget {
  const MacosPulldownMenuEntry({Key? key}) : super(key: key);

  double get itemHeight;
}

class MacosPulldownMenuDivider extends StatelessWidget
    implements MacosPulldownMenuEntry {
  const MacosPulldownMenuDivider({Key? key}) : super(key: key);

  @override
  double get itemHeight => _kMenuDividerHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kMenuDividerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
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

/// An item in a menu created by a [MacosPulldownButton].
///
/// The type `T` is the type of the value the entry represents. All the entries
/// in a given menu must represent values with consistent types.
class MacosPulldownMenuItem extends StatelessWidget
    implements MacosPulldownMenuEntry {
  /// Creates an item for a macOS-style pulldown menu.
  const MacosPulldownMenuItem({
    Key? key,
    required this.title,
    this.onTap,
    this.enabled = true,
    this.alignment = AlignmentDirectional.centerStart,
  }) : super(key: key);

  @override
  double get itemHeight => _kMenuItemHeight;

  /// The widget below this widget in the tree.
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
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: _kMenuItemHeight),
      alignment: alignment,
      child: title,
    );
  }
}

/// A macOS-style pop-up button.
///
/// A pop-up button (often referred to as a pop-up menu) is a type of button
/// that, when clicked, displays a menu containing a list of mutually exclusive
/// choices.
/// A pop-up button includes a double-arrow indicator that alludes to the
/// direction in which the menu will appear (only vertical is currently
/// supported).
///
/// The type `T` is the type of the [value] that each pulldown item represents.
/// All the entries in a given menu must represent values with consistent types.
/// Typically, an enum is used. Each [MacosPulldownMenuItem] in [items] must be
/// specialized with that same type argument.
///
/// The [onChanged] callback should update a state variable that defines the
/// pulldown's value. It should also call [State.setState] to rebuild the
/// pulldown with the new value.
///
/// If the [onChanged] callback is null or the list of [items] is null
/// then the pulldown button will be disabled, i.e. its arrow will be
/// displayed in grey and it will not respond to input. A disabled button
/// will display the [disabledHint] widget if it is non-null. However, if
/// [disabledHint] is null and [hint] is non-null, the [hint] widget will
/// instead be displayed.
///
/// See also:
///
///  * [MacosPulldownMenuItem], the class used to represent the [items].
class MacosPulldownButton<T> extends StatefulWidget {
  /// Creates a macOS-style pulldown button.
  ///
  /// The [items] must have distinct values. If [value] isn't null then it
  /// must be equal to one of the [MacosPulldownMenuItem] values. If [items] or
  /// [onChanged] is null, the button will be disabled, the up-down caret
  /// icon will be greyed out.
  ///
  /// If [value] is null and the button is enabled, [hint] will be displayed
  /// if it is non-null.
  ///
  /// If [value] is null and the button is disabled, [disabledHint] will be displayed
  /// if it is non-null. If [disabledHint] is null, then [hint] will be displayed
  /// if it is non-null.
  ///
  /// The [elevation] and [iconSize] arguments must not be null (they both have
  /// defaults, so do not need to be specified). The boolean [isDense] and
  /// [isExpanded] arguments must not be null.
  ///
  /// The [autofocus] argument must not be null.
  ///
  /// The [pulldownColor] argument specifies the background color of the
  /// pulldown when it is open. If it is null, the appropriate macOS canvas color
  /// will be used.
  MacosPulldownButton({
    Key? key,
    required this.items,
    required this.hint,
    this.disabledHint,
    this.onTap,
    this.elevation = 8,
    this.style,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.itemHeight = _kMinInteractiveDimension,
    this.focusNode,
    this.autofocus = false,
    this.pulldownColor,
    this.menuMaxHeight,
    this.alignment = AlignmentDirectional.centerStart,
  })  : assert(itemHeight == null || itemHeight >= _kMinInteractiveDimension),
        super(key: key);

  /// The list of items the user can select.
  ///
  /// If the [onChanged] callback is null or the list of items is null
  /// then the pulldown button will be disabled, i.e. its arrow will be
  /// displayed in grey and it will not respond to input.
  final List<MacosPulldownMenuEntry>? items;

  /// A placeholder widget that is displayed by the pulldown button.
  ///
  /// If [value] is null and the pulldown is enabled ([items] and [onChanged] are non-null),
  /// this widget is displayed as a placeholder for the pulldown button's value.
  ///
  /// If [value] is null and the pulldown is disabled and [disabledHint] is null,
  /// this widget is used as the placeholder.
  final Widget hint;

  /// A preferred placeholder widget that is displayed when the pulldown is disabled.
  ///
  /// If [value] is null, the pulldown is disabled ([items] or [onChanged] is null),
  /// this widget is displayed as a placeholder for the pulldown button's value.
  final Widget? disabledHint;

  /// Called when the pulldown button is tapped.
  ///
  /// This is distinct from [onChanged], which is called when the user
  /// selects an item from the pulldown.
  ///
  /// The callback will not be invoked if the pulldown button is disabled.
  final VoidCallback? onTap;

  /// The z-coordinate at which to place the menu when open.
  ///
  /// The following elevations have defined shadows: 1, 2, 3, 4, 6, 8, 9, 12,
  /// 16, and 24. See [kElevationToShadow].
  ///
  /// Defaults to 8, the appropriate elevation for pulldown buttons.
  final int elevation;

  /// The text style to use for text in the pulldown button and the pulldown
  /// menu that appears when you tap the button.
  ///
  /// To use a separate text style for selected item when it's displayed within
  /// the pulldown button, consider using [selectedItemBuilder].
  ///
  /// Defaults to MacosTheme.of(context).typography.body.
  final TextStyle? style;

  /// The color of any [Icon] descendant of [icon] if this button is disabled,
  /// i.e. if [onChanged] is null.
  ///
  /// Defaults to [CupertinoColors.quaternaryLabel].
  final Color? iconDisabledColor;

  /// The color of any [Icon] descendant of [icon] if this button is enabled,
  /// i.e. if [onChanged] is defined.
  ///
  /// Defaults to [MacosTheme.of(context).primaryColor]
  final Color? iconEnabledColor;

  /// If null, then the menu item heights will vary according to each menu item's
  /// intrinsic height.
  ///
  /// The default value is [_kMinInteractiveDimension], which is also the minimum
  /// height for menu items.
  ///
  /// If this value is null and there isn't enough vertical room for the menu,
  /// then the menu's initial scroll offset may not align the selected item with
  /// the pulldown button. That's because, in this case, the initial scroll
  /// offset is computed as if all of the menu item heights were
  /// [_kMinInteractiveDimension].
  final double? itemHeight;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// The background color of the pulldown.
  ///
  /// If it is not provided, the the appropriate macOS canvas color
  /// will be used.
  final Color? pulldownColor;

  /// The maximum height of the menu.
  ///
  /// The maximum height of the menu must be at least one row shorter than
  /// the height of the app's view. This ensures that a tappable area
  /// outside of the simple menu is present so the user can dismiss the menu.
  ///
  /// If this property is set above the maximum allowable height threshold
  /// mentioned above, then the menu defaults to being padded at the top
  /// and bottom of the menu by at one menu item's height.
  final double? menuMaxHeight;

  /// Defines how the hint or the selected item is positioned within the button.
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('elevation', elevation));
    properties.add(ColorProperty('iconDisabledColor', iconDisabledColor));
    properties.add(ColorProperty('iconEnabledColor', iconEnabledColor));
    properties.add(DoubleProperty(
      'itemHeight',
      itemHeight,
      defaultValue: kMinInteractiveDimension,
    ));
    properties.add(
      FlagProperty('hasAutofocus', value: autofocus, ifFalse: 'noAutofocus'),
    );
    properties.add(ColorProperty('pulldownColor', pulldownColor));
    properties.add(DoubleProperty('menuMaxHeight', menuMaxHeight));
  }

  @override
  State<MacosPulldownButton<T>> createState() => _MacosPulldownButtonState<T>();
}

class _MacosPulldownButtonState<T> extends State<MacosPulldownButton<T>>
    with WidgetsBindingObserver {
  _MacosPulldownRoute<T>? _pulldownRoute;
  FocusNode? _internalNode;
  FocusNode? get focusNode => widget.focusNode ?? _internalNode;
  bool _hasPrimaryFocus = false;
  late Map<Type, Action<Intent>> _actionMap;
  late FocusHighlightMode _focusHighlightMode;
  bool _isMenuOpen = false;

  // Only used if needed to create _internalNode.
  FocusNode _createFocusNode() {
    return FocusNode(debugLabel: '${widget.runtimeType}');
  }

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
    final FocusManager focusManager = WidgetsBinding.instance!.focusManager;
    _focusHighlightMode = focusManager.highlightMode;
    focusManager.addHighlightModeListener(_handleFocusHighlightModeChange);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _removeMacosPulldownRoute();
    WidgetsBinding.instance!.focusManager
        .removeHighlightModeListener(_handleFocusHighlightModeChange);
    focusNode!.removeListener(_handleFocusChanged);
    _internalNode?.dispose();
    super.dispose();
  }

  void _removeMacosPulldownRoute() {
    setState(() {
      _isMenuOpen = false;
    });
    _pulldownRoute?._dismiss();
    _pulldownRoute = null;
  }

  void _handleFocusChanged() {
    if (_hasPrimaryFocus != focusNode!.hasPrimaryFocus) {
      setState(() {
        _hasPrimaryFocus = focusNode!.hasPrimaryFocus;
      });
    }
  }

  void _handleFocusHighlightModeChange(FocusHighlightMode mode) {
    if (!mounted) {
      return;
    }
    setState(() {
      _focusHighlightMode = mode;
    });
  }

  @override
  void didUpdateWidget(MacosPulldownButton<T> oldWidget) {
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

  TextStyle? get _textStyle =>
      widget.style ?? MacosTheme.of(context).typography.body;

  void _handleTap() {
    final TextDirection? textDirection = Directionality.maybeOf(context);
    final EdgeInsetsGeometry menuMargin =
        const EdgeInsetsDirectional.only(start: 4.0, end: 4.0);

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

    setState(() {
      _isMenuOpen = true;
    });

    final NavigatorState navigator = Navigator.of(context);
    assert(_pulldownRoute == null);
    final RenderBox itemBox = context.findRenderObject()! as RenderBox;
    final Rect itemRect = itemBox.localToGlobal(
          Offset.zero,
          ancestor: navigator.context.findRenderObject(),
        ) &
        itemBox.size;
    _pulldownRoute = _MacosPulldownRoute<T>(
      items: menuItems,
      buttonRect: menuMargin.resolve(textDirection).inflateRect(itemRect),
      padding: _kMenuItemPadding.resolve(textDirection),
      elevation: widget.elevation,
      capturedThemes:
          InheritedTheme.capture(from: context, to: navigator.context),
      style: _textStyle!,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      itemHeight: widget.itemHeight,
      pulldownColor: widget.pulldownColor,
      menuMaxHeight: widget.menuMaxHeight,
    );

    navigator.push(_pulldownRoute!).then<void>((_) {
      _removeMacosPulldownRoute();
      if (!mounted) return;
    });

    widget.onTap?.call();
  }

  Color? get _iconColor {
    if (_enabled) {
      return MacosDynamicColor.maybeResolve(
        widget.iconEnabledColor ??
            MacosTheme.of(context).macosPulldownButtonTheme.highlightColor,
        context,
      );
    } else {
      if (widget.iconDisabledColor != null) return widget.iconDisabledColor!;
      return MacosColors.transparent;
    }
  }

  bool get _enabled => widget.items != null && widget.items!.isNotEmpty;

  bool get _showHighlight {
    switch (_focusHighlightMode) {
      case FocusHighlightMode.touch:
        return false;
      case FocusHighlightMode.traditional:
        return _hasPrimaryFocus;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);
    final borderColor = brightness.resolve(
      const Color(0xffc3c4c9),
      const Color(0xff222222),
    );
    final textColor = _enabled
        ? MacosColors.white
        : brightness.resolve(
            MacosColors.disabledControlTextColor,
            MacosColors.disabledControlTextColor.darkColor,
          );
    final backgroundColor = _isMenuOpen
        ? MacosTheme.of(context)
            .macosPulldownButtonTheme
            .backgroundColor!
            .withOpacity(0.4)
        : _enabled
            ? MacosTheme.of(context).macosPulldownButtonTheme.backgroundColor
            : brightness.resolve(
                const Color(0xfff1f2f3),
                const Color(0xff3f4046),
              );

    Widget result = DefaultTextStyle(
      style: _enabled ? _textStyle! : _textStyle!.copyWith(color: textColor),
      child: Container(
        decoration: _showHighlight
            ? const BoxDecoration(
                color: MacosColors.findHighlightColor,
                borderRadius: _kBorderRadius,
              )
            : BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: borderColor,
                    offset: const Offset(0, .5),
                    blurRadius: 0.2,
                    spreadRadius: 0,
                  ),
                ],
                border: Border.all(width: 0.5, color: borderColor),
                color: backgroundColor,
                borderRadius: _kBorderRadius,
              ),
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 2.0, 0.0),
        height: _kPulldownButtonHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _enabled ? widget.hint : widget.disabledHint ?? widget.hint,
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                height: _kPulldownButtonHeight - 4.0,
                width: _kPulldownButtonHeight - 4.0,
                child: CustomPaint(
                  painter: _DownCaretPainter(
                    color: textColor,
                    backgroundColor: _iconColor ?? MacosColors.appleBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
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

class _DownCaretPainter extends CustomPainter {
  const _DownCaretPainter({
    required this.color,
    required this.backgroundColor,
  });

  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = 4.0;
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

/// Overrides the default style of its [MacosPulldownButton] descendants.
///
/// See also:
///
///  * [MacosPulldownButtonThemeData], which is used to configure this theme.
class MacosPulldownButtonTheme extends InheritedTheme {
  /// Creates a [MacosPulldownButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const MacosPulldownButtonTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final MacosPulldownButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [MacosPulldownButtonTheme] widget, then
  /// [MacosThemeData.MacosPulldownButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// MacosPulldownButtonTheme theme = MacosPulldownButtonTheme.of(context);
  /// ```
  static MacosPulldownButtonThemeData of(BuildContext context) {
    final MacosPulldownButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<MacosPulldownButtonTheme>();
    return buttonTheme?.data ?? MacosTheme.of(context).macosPulldownButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MacosPulldownButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MacosPulldownButtonTheme oldWidget) =>
      data != oldWidget.data;
}

/// A style that overrides the default appearance of
/// [MacosPulldownButton]s when it is used with [MacosPulldownButtonTheme] or with the
/// overall [MacosTheme]'s [MacosThemeData.MacosPulldownButtonTheme].
///
/// See also:
///
///  * [MacosPulldownButtonTheme], the theme which is configured with this class.
///  * [MacosThemeData.MacosPulldownButtonTheme], which can be used to override the default
///    style for [MacosPulldownButton]s below the overall [MacosTheme].
class MacosPulldownButtonThemeData with Diagnosticable {
  /// Creates a [MacosPulldownButtonThemeData].
  const MacosPulldownButtonThemeData({
    this.highlightColor,
    this.backgroundColor,
    this.pulldownColor,
  });

  /// The default highlight color for [MacosPulldownButton].
  ///
  /// Sets the color of the caret icons and the color of a [MacosPulldownMenuItem]'s background when the mouse hovers over it.
  final Color? highlightColor;

  /// The default disabled color for [MacosPulldownButton]
  final Color? backgroundColor;

  /// The default pulldown menu color for [MacosPulldownButton]
  final Color? pulldownColor;

  MacosPulldownButtonThemeData copyWith({
    Color? highlightColor,
    Color? backgroundColor,
    Color? pulldownColor,
  }) {
    return MacosPulldownButtonThemeData(
      highlightColor: highlightColor ?? this.highlightColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      pulldownColor: pulldownColor ?? this.pulldownColor,
    );
  }

  /// Linearly interpolates between two [MacosPulldownButtonThemeData].
  ///
  /// All the properties must be non-null.
  static MacosPulldownButtonThemeData lerp(
    MacosPulldownButtonThemeData a,
    MacosPulldownButtonThemeData b,
    double t,
  ) {
    return MacosPulldownButtonThemeData(
      highlightColor: Color.lerp(a.highlightColor, b.highlightColor, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      pulldownColor: Color.lerp(a.pulldownColor, b.pulldownColor, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MacosPulldownButtonThemeData &&
          runtimeType == other.runtimeType &&
          highlightColor?.value == other.highlightColor?.value &&
          backgroundColor?.value == other.backgroundColor?.value &&
          pulldownColor?.value == other.pulldownColor?.value;

  @override
  int get hashCode => highlightColor.hashCode ^ backgroundColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('highlightColor', highlightColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('pulldownColor', pulldownColor));
  }

  MacosPulldownButtonThemeData merge(MacosPulldownButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      highlightColor: other.highlightColor,
      backgroundColor: other.backgroundColor,
      pulldownColor: other.pulldownColor,
    );
  }
}
