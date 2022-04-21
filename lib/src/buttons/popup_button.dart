import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const Duration _kMacosPopupMenuDuration = Duration(milliseconds: 300);
const Offset _kPopupRouteOffset = Offset(-10.0, 5.0);
const double _kMenuItemHeight = 20.0;
const double _kMinInteractiveDimension = 24.0;
const EdgeInsets _kMenuItemPadding = EdgeInsets.symmetric(horizontal: 4.0);
const Radius _kSideRadius = Radius.circular(7.0);
const BorderRadius _kBorderRadius = BorderRadius.all(_kSideRadius);
const double _kPopupButtonHeight = 20.0;
const double _kPopupMenuCaretsOffset = 2.0;

/// A builder to customize popup buttons.
///
/// Used by [MacosPopupButton.selectedItemBuilder].
typedef MacosPopupButtonBuilder = List<Widget> Function(BuildContext context);

class _MacosPopupMenuPainter extends CustomPainter {
  _MacosPopupMenuPainter({
    this.color,
    this.borderColor,
    this.elevation,
    this.selectedIndex,
    this.borderRadius,
  }) : _painter = BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              offset: const Offset(0, 2),
              spreadRadius: 2.0,
              blurRadius: 6.0,
            ),
          ],
          border: Border.all(
            color: borderColor!,
          ),
          borderRadius: borderRadius ?? _kBorderRadius,
        ).createBoxPainter();

  final Color? color;
  final Color? borderColor;
  final int? elevation;
  final int? selectedIndex;
  final BorderRadius? borderRadius;
  final BoxPainter _painter;

  @override
  void paint(Canvas canvas, Size size) {
    // Add 2.0 pixels when painting to take into account when the up/down carets
    // are shown.
    final Rect rect = Rect.fromLTRB(
      0.0,
      -_kPopupMenuCaretsOffset,
      size.width,
      size.height + _kPopupMenuCaretsOffset,
    );

    _painter.paint(canvas, rect.topLeft, ImageConfiguration(size: rect.size));
  }

  @override
  bool shouldRepaint(_MacosPopupMenuPainter oldPainter) {
    return oldPainter.color != color ||
        oldPainter.elevation != elevation ||
        oldPainter.selectedIndex != selectedIndex ||
        oldPainter.borderRadius != borderRadius;
  }
}

// The widget that is the button wrapping the menu items.
class _MacosPopupMenuItemButton<T> extends StatefulWidget {
  const _MacosPopupMenuItemButton({
    Key? key,
    this.padding,
    required this.route,
    required this.buttonRect,
    required this.constraints,
    required this.itemIndex,
  }) : super(key: key);

  final _MacosPopupRoute<T> route;
  final EdgeInsets? padding;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final int itemIndex;

  @override
  _MacosPopupMenuItemButtonState<T> createState() =>
      _MacosPopupMenuItemButtonState<T>();
}

class _MacosPopupMenuItemButtonState<T>
    extends State<_MacosPopupMenuItemButton<T>> {
  bool _isHovered = false;

  void _handleFocusChange(bool focused) {
    if (focused) {
      final _MenuLimits menuLimits = widget.route.getMenuLimits(
        widget.buttonRect,
        widget.constraints.maxHeight,
        widget.itemIndex,
      );
      widget.route.scrollController!.animateTo(
        menuLimits.scrollOffset,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 100),
      );
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
    final MacosPopupMenuItem<T> popupMenuItem =
        widget.route.items[widget.itemIndex].item!;

    popupMenuItem.onTap?.call();

    Navigator.pop(
      context,
      _MacosPopupRouteResult<T>(popupMenuItem.value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);
    final MacosThemeData theme = MacosTheme.of(context);
    final MacosPopupMenuItem<T> popupMenuItem =
        widget.route.items[widget.itemIndex].item!;
    Widget child = Container(
      padding: widget.padding,
      height: widget.route.itemHeight,
      child: widget.route.items[widget.itemIndex],
    );
    if (popupMenuItem.enabled) {
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
            autofocus: widget.itemIndex == widget.route.selectedIndex,
            child: Container(
              decoration: BoxDecoration(
                color: _isHovered
                    ? theme.macosPopupButtonTheme.highlightColor
                    : theme.macosPopupButtonTheme.popupColor,
                borderRadius: _kBorderRadius,
              ),
              child: Row(
                children: [
                  (widget.itemIndex == widget.route.selectedIndex)
                      ? Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: MacosIcon(
                            CupertinoIcons.checkmark_alt,
                            size: 16.0,
                            color: _isHovered
                                ? MacosColors.white
                                : brightness.resolve(
                                    MacosColors.black,
                                    MacosColors.white,
                                  ),
                          ),
                        )
                      : const SizedBox(width: 18.0),
                  DefaultTextStyle(
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
                ],
              ),
            ),
          ),
        ),
      );
    }
    return child;
  }
}

class _MacosPopupMenu<T> extends StatefulWidget {
  const _MacosPopupMenu({
    Key? key,
    this.padding,
    required this.route,
    required this.buttonRect,
    required this.constraints,
    this.popupColor,
    required this.hasTopItemsNotShown,
    required this.hasBottomItemsNotShown,
  }) : super(key: key);

  final _MacosPopupRoute<T> route;
  final EdgeInsets? padding;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final Color? popupColor;
  final bool hasTopItemsNotShown;
  final bool hasBottomItemsNotShown;

  @override
  _MacosPopupMenuState<T> createState() => _MacosPopupMenuState<T>();
}

class _MacosPopupMenuState<T> extends State<_MacosPopupMenu<T>> {
  late CurvedAnimation _fadeOpacity;
  late bool _showBottomCaret;
  late bool _showTopCaret;

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
    _showBottomCaret = widget.hasBottomItemsNotShown;
    _showTopCaret = widget.hasTopItemsNotShown;
  }

  @override
  Widget build(BuildContext context) {
    final _MacosPopupRoute<T> route = widget.route;
    final List<Widget> children = <Widget>[
      for (int itemIndex = 0; itemIndex < route.items.length; ++itemIndex)
        _MacosPopupMenuItemButton<T>(
          route: widget.route,
          padding: widget.padding,
          buttonRect: widget.buttonRect,
          constraints: widget.constraints,
          itemIndex: itemIndex,
        ),
    ];
    final brightness = MacosTheme.brightnessOf(context);
    final popupColor = MacosDynamicColor.maybeResolve(
      widget.popupColor ??
          MacosTheme.of(context).macosPopupButtonTheme.popupColor,
      context,
    );
    final caretColor =
        brightness.resolve(CupertinoColors.white, CupertinoColors.black);

    return FadeTransition(
      opacity: _fadeOpacity,
      child: CustomPaint(
        painter: _MacosPopupMenuPainter(
          color: popupColor,
          borderColor: brightness.resolve(
            CupertinoColors.systemGrey3.color,
            Colors.white.withOpacity(0.15),
          ),
          elevation: route.elevation,
          selectedIndex: route.selectedIndex,
        ),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          child: ScrollConfiguration(
            // MacosPopup menus show an up or down caret arrow when items
            // are not visible within the available height.
            // No scrollbars are shown.
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
              overscroll: false,
              physics: const ClampingScrollPhysics(),
              platform: TargetPlatform.macOS,
            ),
            child: PrimaryScrollController(
              controller: widget.route.scrollController!,
              child: NotificationListener(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ListView.builder(
                      itemCount: children.length,
                      itemBuilder: (context, index) {
                        return children[index];
                      },
                      padding: const EdgeInsets.all(4.0),
                      shrinkWrap: true,
                    ),
                    _showTopCaret
                        ? Positioned(
                            top: 0,
                            child: Container(
                              width: widget.buttonRect.width -
                                  _kPopupMenuCaretsOffset,
                              height: widget.buttonRect.height,
                              decoration: BoxDecoration(
                                color: popupColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: _kSideRadius,
                                  topRight: _kSideRadius,
                                ),
                              ),
                              child: Icon(
                                CupertinoIcons.chevron_up,
                                color: caretColor,
                                size: 14.0,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    _showBottomCaret
                        ? Positioned(
                            bottom: 0,
                            child: Container(
                              width: widget.buttonRect.width -
                                  _kPopupMenuCaretsOffset,
                              height: widget.buttonRect.height,
                              decoration: BoxDecoration(
                                color: popupColor,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: _kSideRadius,
                                  bottomRight: _kSideRadius,
                                ),
                              ),
                              child: Icon(
                                CupertinoIcons.chevron_down,
                                color: caretColor,
                                size: 14.0,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                onNotification: (t) {
                  if (t is ScrollUpdateNotification) {
                    setState(() {
                      _showTopCaret =
                          widget.route.scrollController!.position.extentBefore >
                              widget.buttonRect.height;
                      _showBottomCaret =
                          widget.route.scrollController!.position.extentAfter >
                              widget.buttonRect.height;
                    });
                  }
                  return true;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MacosPopupMenuRouteLayout<T> extends SingleChildLayoutDelegate {
  _MacosPopupMenuRouteLayout({
    required this.buttonRect,
    required this.route,
    required this.textDirection,
  });

  final Rect buttonRect;
  final _MacosPopupRoute<T> route;
  final TextDirection? textDirection;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The maximum height of a simple menu should be one or more rows less than
    // the view height. This ensures a tappable area outside of the simple menu
    // with which to dismiss the menu.
    double maxHeight =
        math.max(0.0, constraints.maxHeight - 2 * _kMenuItemHeight);
    if (route.menuMaxHeight != null && route.menuMaxHeight! <= maxHeight) {
      maxHeight = route.menuMaxHeight!;
    }
    // The width of a menu should be at most the view width. This ensures that
    // the menu does not extend past the left and right edges of the screen.
    final double width = math.min(constraints.maxWidth, buttonRect.width);
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final _MenuLimits menuLimits =
        route.getMenuLimits(buttonRect, size.height, route.selectedIndex);

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
        left = buttonRect.left.clamp(0.0, size.width - childSize.width);
        break;
    }

    return Offset(left, menuLimits.top);
  }

  @override
  bool shouldRelayout(_MacosPopupMenuRouteLayout<T> oldDelegate) {
    return buttonRect != oldDelegate.buttonRect ||
        textDirection != oldDelegate.textDirection;
  }
}

// We box the return value so that the return value can be null. Otherwise,
// canceling the route (which returns null) would get confused with actually
// returning a real null value.
@immutable
class _MacosPopupRouteResult<T> {
  const _MacosPopupRouteResult(this.result);

  final T? result;

  @override
  bool operator ==(Object other) {
    return other is _MacosPopupRouteResult<T> && other.result == result;
  }

  @override
  int get hashCode => result.hashCode;
}

class _MenuLimits {
  const _MenuLimits(
    this.top,
    this.bottom,
    this.height,
    this.scrollOffset,
    this.hasTopItemsNotShown,
    this.hasBottomItemsNotShown,
  );
  final double top;
  final double bottom;
  final double height;
  final double scrollOffset;
  final bool hasTopItemsNotShown;
  final bool hasBottomItemsNotShown;
}

class _MacosPopupRoute<T> extends PopupRoute<_MacosPopupRouteResult<T>> {
  _MacosPopupRoute({
    required this.items,
    required this.padding,
    required this.buttonRect,
    required this.selectedIndex,
    this.elevation = 8,
    required this.capturedThemes,
    required this.style,
    this.barrierLabel,
    this.itemHeight,
    this.popupColor,
    this.menuMaxHeight,
  }) : itemHeights = List<double>.filled(
          items.length,
          itemHeight ?? _kMinInteractiveDimension,
        );

  final List<_MenuItem<T>> items;
  final EdgeInsetsGeometry padding;
  final Rect buttonRect;
  final int selectedIndex;
  final int elevation;
  final CapturedThemes capturedThemes;
  final TextStyle style;
  final double? itemHeight;
  final Color? popupColor;
  final double? menuMaxHeight;

  final List<double> itemHeights;
  ScrollController? scrollController;

  @override
  Duration get transitionDuration => _kMacosPopupMenuDuration;

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
        return _MacosPopupRoutePage<T>(
          route: this,
          constraints: constraints,
          items: items,
          padding: padding,
          buttonRect: buttonRect,
          selectedIndex: selectedIndex,
          elevation: elevation,
          capturedThemes: capturedThemes,
          style: style,
          popupColor: popupColor,
        );
      },
    );
  }

  void _dismiss() {
    if (isActive) {
      navigator?.removeRoute(this);
    }
  }

  double getItemOffset(int index) {
    double offset = 8.0;
    if (items.isNotEmpty && index > 0) {
      assert(items.length == itemHeights.length);
      offset += itemHeights
          .sublist(0, index)
          .reduce((double total, double height) => total + height);
    }
    return offset;
  }

  // Returns the vertical extent of the menu and the initial scrollOffset
  // for the ListView that contains the menu items. The vertical center of the
  // selected item is aligned with the button's vertical center, as far as
  // that's possible given availableHeight.
  _MenuLimits getMenuLimits(
    Rect buttonRect,
    double availableHeight,
    int index,
  ) {
    double computedMaxHeight = availableHeight - 2.0 * _kMenuItemHeight;
    if (menuMaxHeight != null) {
      computedMaxHeight = math.min(computedMaxHeight, menuMaxHeight!);
    }
    final double buttonTop = buttonRect.top;
    final double buttonBottom = math.min(buttonRect.bottom, availableHeight);
    final double selectedItemOffset = getItemOffset(index);

    // If the button is placed on the bottom or top of the screen, its top or
    // bottom may be less than [_kMenuItemHeight] from the edge of the screen.
    // In this case, we want to change the menu limits to align with the top
    // or bottom edge of the button.
    final double topLimit = math.min(_kMenuItemHeight, buttonTop);
    final double bottomLimit =
        math.max(availableHeight - _kMenuItemHeight, buttonBottom);

    double menuTop = (buttonTop - selectedItemOffset) -
        (itemHeights[selectedIndex] - buttonRect.height) / 2.0;
    double preferredMenuHeight = 8.0;
    if (items.isNotEmpty)
      preferredMenuHeight +=
          itemHeights.reduce((double total, double height) => total + height);

    // If there are too many elements in the menu, we need to shrink it down
    // so it is at most the computedMaxHeight.
    final double menuHeight = math.min(computedMaxHeight, preferredMenuHeight);
    double menuBottom = menuTop + menuHeight;

    // If the computed top or bottom of the menu are outside of the range
    // specified, we need to bring them into range. If the item height is larger
    // than the button height and the button is at the very bottom or top of the
    // screen, the menu will be aligned with the bottom or top of the button
    // respectively.
    if (menuTop < topLimit) {
      menuTop = math.min(buttonTop, topLimit);
      menuBottom = menuTop + menuHeight;
    }

    if (menuBottom > bottomLimit) {
      menuBottom = math.max(buttonBottom, bottomLimit);
      menuTop = menuBottom - menuHeight;
    }

    if (menuBottom - itemHeights[selectedIndex] / 2.0 <
        buttonBottom - buttonRect.height / 2.0) {
      menuBottom = buttonBottom -
          buttonRect.height / 2.0 +
          itemHeights[selectedIndex] / 2.0;
      menuTop = menuBottom - menuHeight;
    }

    double scrollOffset = 0;
    // If all of the menu items will not fit within availableHeight then
    // compute the scroll offset that will line the selected menu item up
    // with the select item. This is only done when the menu is first
    // shown - subsequently we leave the scroll offset where the user left
    // it. This scroll offset is only accurate for fixed height menu items
    // (the default).
    if (preferredMenuHeight > computedMaxHeight) {
      // The offset should be zero if the selected item is in view at the beginning
      // of the menu. Otherwise, the scroll offset should center the item if possible.
      scrollOffset = math.max(0.0, selectedItemOffset - (buttonTop - menuTop));
      // If the selected item's scroll offset is greater than the maximum scroll offset,
      // set it instead to the maximum allowed scroll offset.
      scrollOffset = math.min(scrollOffset, preferredMenuHeight - menuHeight);
    }
    bool hasTopItemsNotShown = preferredMenuHeight > computedMaxHeight &&
        scrollOffset > buttonRect.height / 2.0;
    bool hasBottomItemsNotShown = preferredMenuHeight > computedMaxHeight &&
        scrollOffset < buttonRect.height / 2.0;

    assert((menuBottom - menuTop - menuHeight).abs() < precisionErrorTolerance);
    return _MenuLimits(
      menuTop,
      menuBottom,
      menuHeight,
      scrollOffset,
      hasTopItemsNotShown,
      hasBottomItemsNotShown,
    );
  }
}

class _MacosPopupRoutePage<T> extends StatelessWidget {
  const _MacosPopupRoutePage({
    Key? key,
    required this.route,
    required this.constraints,
    this.items,
    required this.padding,
    required this.buttonRect,
    required this.selectedIndex,
    this.elevation = 8,
    required this.capturedThemes,
    this.style,
    required this.popupColor,
  }) : super(key: key);

  final _MacosPopupRoute<T> route;
  final BoxConstraints constraints;
  final List<_MenuItem<T>>? items;
  final EdgeInsetsGeometry padding;
  final Rect buttonRect;
  final int selectedIndex;
  final int elevation;
  final CapturedThemes capturedThemes;
  final TextStyle? style;
  final Color? popupColor;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    // Computing the initialScrollOffset now, before the items have been laid
    // out. This only works if the item heights are effectively fixed, i.e. either
    // MacosPopupButton.itemHeight is specified or MacosPopupButton.itemHeight is null
    // and all of the items' intrinsic heights are less than _kMinInteractiveDimension.
    // Otherwise the initialScrollOffset is just a rough approximation based on
    // treating the items as if their heights were all equal to _kMinInteractiveDimension.
    final _MenuLimits menuLimits =
        route.getMenuLimits(buttonRect, constraints.maxHeight, selectedIndex);
    if (route.scrollController == null) {
      route.scrollController =
          ScrollController(initialScrollOffset: menuLimits.scrollOffset);
    }

    final TextDirection? textDirection = Directionality.maybeOf(context);
    final Widget menu = _MacosPopupMenu<T>(
      route: route,
      padding: padding.resolve(textDirection),
      buttonRect: buttonRect,
      constraints: constraints,
      popupColor: popupColor,
      hasBottomItemsNotShown: menuLimits.hasBottomItemsNotShown,
      hasTopItemsNotShown: menuLimits.hasTopItemsNotShown,
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
            delegate: _MacosPopupMenuRouteLayout<T>(
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

// This widget enables _MacosPopupRoute to look up the sizes of
// each menu item. These sizes are used to compute the offset of the selected
// item so that _MacosPopupRoutePage can align the vertical center of the
// selected item lines up with the vertical center of the popup button,
// as closely as possible.
class _MenuItem<T> extends SingleChildRenderObjectWidget {
  const _MenuItem({
    Key? key,
    required this.onLayout,
    required this.item,
  }) : super(key: key, child: item);

  final ValueChanged<Size> onLayout;
  final MacosPopupMenuItem<T>? item;

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

// The container widget for a menu item created by a [MacosPopupButton]. It
// provides the default configuration for [MacosPopupMenuItem]s, as well as a
// [MacosPopupButton]'s hint and disabledHint widgets.
class _MacosPopupMenuItemContainer extends StatelessWidget {
  /// Creates an item for a popup menu.
  ///
  /// The [child] argument is required.
  const _MacosPopupMenuItemContainer({
    Key? key,
    this.alignment = AlignmentDirectional.centerStart,
    required this.child,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

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
      child: child,
    );
  }
}

/// An item in a menu created by a [MacosPopupButton].
///
/// The type `T` is the type of the value the entry represents. All the entries
/// in a given menu must represent values with consistent types.
class MacosPopupMenuItem<T> extends _MacosPopupMenuItemContainer {
  /// Creates an item for a macOS-style popup menu.
  ///
  /// The [child] argument is required.
  const MacosPopupMenuItem({
    Key? key,
    this.onTap,
    this.value,
    this.enabled = true,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    required Widget child,
  }) : super(key: key, alignment: alignment, child: child);

  /// Called when the popup menu item is tapped.
  final VoidCallback? onTap;

  /// The value to return if the user selects this menu item.
  ///
  /// Eventually returned in a call to [MacosPopupButton.onChanged].
  final T? value;

  /// Whether or not a user can select this menu item.
  ///
  /// Defaults to `true`.
  final bool enabled;
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
/// The type `T` is the type of the [value] that each popup item represents.
/// All the entries in a given menu must represent values with consistent types.
/// Typically, an enum is used. Each [MacosPopupMenuItem] in [items] must be
/// specialized with that same type argument.
///
/// The [onChanged] callback should update a state variable that defines the
/// popup's value. It should also call [State.setState] to rebuild the
/// popup with the new value.
///
/// If the [onChanged] callback is null or the list of [items] is null
/// then the popup button will be disabled, i.e. its arrow will be
/// displayed in grey and it will not respond to input. A disabled button
/// will display the [disabledHint] widget if it is non-null. However, if
/// [disabledHint] is null and [hint] is non-null, the [hint] widget will
/// instead be displayed.
///
/// See also:
///
///  * [MacosPopupMenuItem], the class used to represent the [items].
class MacosPopupButton<T> extends StatefulWidget {
  /// Creates a macOS-style popup button.
  ///
  /// The [items] must have distinct values. If [value] isn't null then it
  /// must be equal to one of the [MacosPopupMenuItem] values. If [items] or
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
  /// The [popupColor] argument specifies the background color of the
  /// popup when it is open. If it is null, the appropriate macOS canvas color
  /// will be used.
  MacosPopupButton({
    Key? key,
    required this.items,
    this.selectedItemBuilder,
    this.value,
    this.hint,
    this.disabledHint,
    required this.onChanged,
    this.onTap,
    this.elevation = 8,
    this.style,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.itemHeight = _kMinInteractiveDimension,
    this.focusNode,
    this.autofocus = false,
    this.popupColor,
    this.menuMaxHeight,
    this.alignment = AlignmentDirectional.centerStart,
  })  : assert(
          items == null ||
              items.isEmpty ||
              value == null ||
              items.where((MacosPopupMenuItem<T> item) {
                    return item.value == value;
                  }).length ==
                  1,
          "There should be exactly one item with [MacosPopupButton]'s value: "
          '$value. \n'
          'Either zero or 2 or more [MacosPopupMenuItem]s were detected '
          'with the same value',
        ),
        assert(itemHeight == null || itemHeight >= _kMinInteractiveDimension),
        super(key: key);

  /// The list of items the user can select.
  ///
  /// If the [onChanged] callback is null or the list of items is null
  /// then the popup button will be disabled, i.e. its arrow will be
  /// displayed in grey and it will not respond to input.
  final List<MacosPopupMenuItem<T>>? items;

  /// The value of the currently selected [MacosPopupMenuItem].
  ///
  /// If [value] is null and the button is enabled, [hint] will be displayed
  /// if it is non-null.
  ///
  /// If [value] is null and the button is disabled, [disabledHint] will be displayed
  /// if it is non-null. If [disabledHint] is null, then [hint] will be displayed
  /// if it is non-null.
  final T? value;

  /// A placeholder widget that is displayed by the popup button.
  ///
  /// If [value] is null and the popup is enabled ([items] and [onChanged] are non-null),
  /// this widget is displayed as a placeholder for the popup button's value.
  ///
  /// If [value] is null and the popup is disabled and [disabledHint] is null,
  /// this widget is used as the placeholder.
  final Widget? hint;

  /// A preferred placeholder widget that is displayed when the popup is disabled.
  ///
  /// If [value] is null, the popup is disabled ([items] or [onChanged] is null),
  /// this widget is displayed as a placeholder for the popup button's value.
  final Widget? disabledHint;

  /// Called when the user selects an item.
  ///
  /// If the [onChanged] callback is null or the list of [MacosPopupButton.items]
  /// is null then the popup button will be disabled, i.e. its up/down caret will
  /// be displayed in grey and it will not respond to input. A disabled button
  /// will display the [MacosPopupButton.disabledHint] widget if it is non-null.
  /// If [MacosPopupButton.disabledHint] is also null but [MacosPopupButton.hint] is
  /// non-null, [MacosPopupButton.hint] will instead be displayed.
  final ValueChanged<T?>? onChanged;

  /// Called when the popup button is tapped.
  ///
  /// This is distinct from [onChanged], which is called when the user
  /// selects an item from the popup.
  ///
  /// The callback will not be invoked if the popup button is disabled.
  final VoidCallback? onTap;

  /// A builder to customize the popup buttons corresponding to the
  /// [MacosPopupMenuItem]s in [items].
  ///
  /// When a [MacosPopupMenuItem] is selected, the widget that will be displayed
  /// from the list corresponds to the [MacosPopupMenuItem] of the same index
  /// in [items].
  ///
  /// If this callback is null, the [MacosPopupMenuItem] from [items]
  /// that matches [value] will be displayed.
  final MacosPopupButtonBuilder? selectedItemBuilder;

  /// The z-coordinate at which to place the menu when open.
  ///
  /// The following elevations have defined shadows: 1, 2, 3, 4, 6, 8, 9, 12,
  /// 16, and 24. See [kElevationToShadow].
  ///
  /// Defaults to 8, the appropriate elevation for popup buttons.
  final int elevation;

  /// The text style to use for text in the popup button and the popup
  /// menu that appears when you tap the button.
  ///
  /// To use a separate text style for selected item when it's displayed within
  /// the popup button, consider using [selectedItemBuilder].
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
  /// the popup button. That's because, in this case, the initial scroll
  /// offset is computed as if all of the menu item heights were
  /// [_kMinInteractiveDimension].
  final double? itemHeight;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// The background color of the popup.
  ///
  /// If it is not provided, the the appropriate macOS canvas color
  /// will be used.
  final Color? popupColor;

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
    properties.add(ColorProperty('popupColor', popupColor));
    properties.add(DoubleProperty('menuMaxHeight', menuMaxHeight));
  }

  @override
  State<MacosPopupButton<T>> createState() => _MacosPopupButtonState<T>();
}

class _MacosPopupButtonState<T> extends State<MacosPopupButton<T>>
    with WidgetsBindingObserver {
  int? _selectedIndex;
  _MacosPopupRoute<T>? _popupRoute;
  FocusNode? _internalNode;
  FocusNode? get focusNode => widget.focusNode ?? _internalNode;
  bool _hasPrimaryFocus = false;
  late Map<Type, Action<Intent>> _actionMap;
  late FocusHighlightMode _focusHighlightMode;

  // Only used if needed to create _internalNode.
  FocusNode _createFocusNode() {
    return FocusNode(debugLabel: '${widget.runtimeType}');
  }

  @override
  void initState() {
    super.initState();
    _updateSelectedIndex();
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
    _removeMacosPopupRoute();
    WidgetsBinding.instance!.focusManager
        .removeHighlightModeListener(_handleFocusHighlightModeChange);
    focusNode!.removeListener(_handleFocusChanged);
    _internalNode?.dispose();
    super.dispose();
  }

  void _removeMacosPopupRoute() {
    _popupRoute?._dismiss();
    _popupRoute = null;
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
  void didUpdateWidget(MacosPopupButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      if (widget.focusNode == null) {
        _internalNode ??= _createFocusNode();
      }
      _hasPrimaryFocus = focusNode!.hasPrimaryFocus;
      focusNode!.addListener(_handleFocusChanged);
    }
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    if (widget.items == null ||
        widget.items!.isEmpty ||
        (widget.value == null &&
            widget.items!
                .where((MacosPopupMenuItem<T> item) =>
                    item.enabled && item.value == widget.value)
                .isEmpty)) {
      _selectedIndex = null;
      return;
    }

    assert(widget.items!
            .where((MacosPopupMenuItem<T> item) => item.value == widget.value)
            .length ==
        1);
    for (int itemIndex = 0; itemIndex < widget.items!.length; itemIndex++) {
      if (widget.items![itemIndex].value == widget.value) {
        _selectedIndex = itemIndex;
        return;
      }
    }
  }

  TextStyle? get _textStyle =>
      widget.style ?? MacosTheme.of(context).typography.body;

  void _handleTap() {
    final TextDirection? textDirection = Directionality.maybeOf(context);
    final EdgeInsetsGeometry menuMargin =
        const EdgeInsetsDirectional.only(start: 4.0, end: 4.0);

    final List<_MenuItem<T>> menuItems = <_MenuItem<T>>[
      for (int index = 0; index < widget.items!.length; index += 1)
        _MenuItem<T>(
          item: widget.items![index],
          onLayout: (Size size) {
            // If [_popupRoute] is null and onLayout is called, this means
            // that performLayout was called on a _MacosPopupRoute that has not
            // left the widget tree but is already on its way out.
            //
            // Since onLayout is used primarily to collect the desired heights
            // of each menu item before laying them out, not having the _MacosPopupRoute
            // collect each item's height to lay out is fine since the route is
            // already on its way out.
            if (_popupRoute == null) return;

            _popupRoute!.itemHeights[index] = size.height;
          },
        ),
    ];

    final NavigatorState navigator = Navigator.of(context);
    assert(_popupRoute == null);
    final RenderBox itemBox = context.findRenderObject()! as RenderBox;
    final Rect itemRect = itemBox.localToGlobal(
          _kPopupRouteOffset,
          ancestor: navigator.context.findRenderObject(),
        ) &
        itemBox.size;
    _popupRoute = _MacosPopupRoute<T>(
      items: menuItems,
      buttonRect: menuMargin.resolve(textDirection).inflateRect(itemRect),
      padding: _kMenuItemPadding.resolve(textDirection),
      selectedIndex: _selectedIndex ?? 0,
      elevation: widget.elevation,
      capturedThemes:
          InheritedTheme.capture(from: context, to: navigator.context),
      style: _textStyle!,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      itemHeight: widget.itemHeight,
      popupColor: widget.popupColor,
      menuMaxHeight: widget.menuMaxHeight,
    );

    navigator
        .push(_popupRoute!)
        .then<void>((_MacosPopupRouteResult<T>? newValue) {
      _removeMacosPopupRoute();
      if (!mounted || newValue == null) return;
      widget.onChanged?.call(newValue.result);
    });

    widget.onTap?.call();
  }

  Color? get _iconColor {
    if (_enabled) {
      return MacosDynamicColor.maybeResolve(
        widget.iconEnabledColor ??
            MacosTheme.of(context).macosPopupButtonTheme.highlightColor,
        context,
      );
    } else {
      if (widget.iconDisabledColor != null) return widget.iconDisabledColor!;
      return CupertinoColors.quaternaryLabel;
    }
  }

  bool get _enabled =>
      widget.items != null &&
      widget.items!.isNotEmpty &&
      widget.onChanged != null;

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
    // The width of the button and the menu are defined by the widest
    // item and the width of the hint.
    // We should explicitly type the items list to be a list of <Widget>,
    // otherwise, no explicit type adding items maybe trigger a crash/failure
    // when hint and selectedItemBuilder are provided.
    final List<Widget> items = widget.selectedItemBuilder == null
        ? (widget.items != null ? List<Widget>.from(widget.items!) : <Widget>[])
        : List<Widget>.from(widget.selectedItemBuilder!(context));

    int? hintIndex;
    if (widget.hint != null || (!_enabled && widget.disabledHint != null)) {
      Widget displayedHint =
          _enabled ? widget.hint! : widget.disabledHint ?? widget.hint!;
      if (widget.selectedItemBuilder == null)
        displayedHint = _MacosPopupMenuItemContainer(child: displayedHint);

      hintIndex = items.length;
      items.add(IgnorePointer(
        ignoringSemantics: false,
        child: displayedHint,
      ));
    }

    // If value is null (then _selectedIndex is null) then we
    // display the hint or nothing at all.
    final Widget innerItemsWidget;
    if (items.isEmpty) {
      innerItemsWidget = Container();
    } else {
      innerItemsWidget = IndexedStack(
        index: _selectedIndex ?? hintIndex,
        alignment: widget.alignment,
        children: items.map((Widget item) {
          return widget.itemHeight != null
              ? SizedBox(height: widget.itemHeight, child: item)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[item],
                );
        }).toList(),
      );
    }
    final brightness = MacosTheme.brightnessOf(context);
    final borderColor = brightness.resolve(
      Colors.black.withOpacity(0.12),
      Colors.black.withOpacity(0.10),
    );

    Widget result = DefaultTextStyle(
      style: _enabled
          ? _textStyle!
          : _textStyle!.copyWith(color: MacosColors.disabledControlTextColor),
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
                    offset: const Offset(0, 1),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                ],
                color: MacosTheme.of(context)
                    .macosPopupButtonTheme
                    .backgroundColor,
                border: Border.all(
                  width: 1,
                  color: borderColor,
                ),
                borderRadius: _kBorderRadius,
              ),
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 2.0, 0.0),
        height: _kPopupButtonHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            innerItemsWidget,
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                height: _kPopupButtonHeight - 4.0,
                width: _kPopupButtonHeight - 4.0,
                child: CustomPaint(
                  painter: _UpDownCaretsPainter(
                    color: MacosColors.white,
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

class _UpDownCaretsPainter extends CustomPainter {
  const _UpDownCaretsPainter({
    required this.color,
    required this.backgroundColor,
  });

  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = 4.0;
    final vPadding = size.height / 8 + 1.25;
    final hPadding = 2 * size.height / 8 + 1.25;

    /// Draw background
    canvas.drawRRect(
      BorderRadius.circular(radius).toRRect(Offset.zero & size),
      Paint()..color = backgroundColor,
    );

    /// Draw carets
    final p1 = Offset(hPadding, size.height / 2 - 2.0);
    final p2 = Offset(size.width / 2, vPadding);
    final p3 = Offset(size.width - hPadding, size.height / 2 - 2.0);
    final p4 = Offset(hPadding, size.height / 2 + 2.0);
    final p5 = Offset(size.width / 2, size.height - vPadding);
    final p6 = Offset(size.width - hPadding, size.height / 2 + 2.0);
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.6;
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p2, p3, paint);
    canvas.drawLine(p4, p5, paint);
    canvas.drawLine(p5, p6, paint);
  }

  @override
  bool shouldRepaint(_UpDownCaretsPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_UpDownCaretsPainter oldDelegate) => false;
}

/// Overrides the default style of its [MacosPopupButton] descendants.
///
/// See also:
///
///  * [MacosPopupButtonThemeData], which is used to configure this theme.
class MacosPopupButtonTheme extends InheritedTheme {
  /// Creates a [MacosPopupButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const MacosPopupButtonTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final MacosPopupButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [MacosPopupButtonTheme] widget, then
  /// [MacosThemeData.MacosPopupButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// MacosPopupButtonTheme theme = MacosPopupButtonTheme.of(context);
  /// ```
  static MacosPopupButtonThemeData of(BuildContext context) {
    final MacosPopupButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<MacosPopupButtonTheme>();
    return buttonTheme?.data ?? MacosTheme.of(context).macosPopupButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MacosPopupButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MacosPopupButtonTheme oldWidget) =>
      data != oldWidget.data;
}

/// A style that overrides the default appearance of
/// [MacosPopupButton]s when it is used with [MacosPopupButtonTheme] or with the
/// overall [MacosTheme]'s [MacosThemeData.MacosPopupButtonTheme].
///
/// See also:
///
///  * [MacosPopupButtonTheme], the theme which is configured with this class.
///  * [MacosThemeData.MacosPopupButtonTheme], which can be used to override the default
///    style for [MacosPopupButton]s below the overall [MacosTheme].
class MacosPopupButtonThemeData with Diagnosticable {
  /// Creates a [MacosPopupButtonThemeData].
  const MacosPopupButtonThemeData({
    this.highlightColor,
    this.backgroundColor,
    this.popupColor,
  });

  /// The default highlight color for [MacosPopupButton].
  ///
  /// Sets the color of the caret icons and the color of a [MacosPopupMenuItem]'s background when the mouse hovers over it.
  final Color? highlightColor;

  /// The default background color for [MacosPopupButton]
  final Color? backgroundColor;

  /// The default popup menu color for [MacosPopupButton]
  final Color? popupColor;

  MacosPopupButtonThemeData copyWith({
    Color? highlightColor,
    Color? backgroundColor,
    Color? popupColor,
  }) {
    return MacosPopupButtonThemeData(
      highlightColor: highlightColor ?? this.highlightColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      popupColor: popupColor ?? this.popupColor,
    );
  }

  /// Linearly interpolates between two [MacosPopupButtonThemeData].
  ///
  /// All the properties must be non-null.
  static MacosPopupButtonThemeData lerp(
    MacosPopupButtonThemeData a,
    MacosPopupButtonThemeData b,
    double t,
  ) {
    return MacosPopupButtonThemeData(
      highlightColor: Color.lerp(a.highlightColor, b.highlightColor, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      popupColor: Color.lerp(a.popupColor, b.popupColor, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MacosPopupButtonThemeData &&
          runtimeType == other.runtimeType &&
          highlightColor?.value == other.highlightColor?.value &&
          backgroundColor?.value == other.backgroundColor?.value &&
          popupColor?.value == other.popupColor?.value;

  @override
  int get hashCode => highlightColor.hashCode ^ backgroundColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('highlightColor', highlightColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('popupColor', popupColor));
  }

  MacosPopupButtonThemeData merge(MacosPopupButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      highlightColor: other.highlightColor,
      backgroundColor: other.backgroundColor,
      popupColor: other.popupColor,
    );
  }
}
