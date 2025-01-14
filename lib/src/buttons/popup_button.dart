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
const Radius _kSideRadius = Radius.circular(5.0);
const BorderRadius _kBorderRadius = BorderRadius.all(_kSideRadius);
const double _kPopupButtonHeight = 20.0;

/// A builder to customize popup buttons.
///
/// Used by [MacosPopupButton.selectedItemBuilder].
typedef MacosPopupButtonBuilder = List<Widget> Function(BuildContext context);

// The widget that is the button wrapping the menu items.
class _MacosPopupMenuItemButton<T> extends StatefulWidget {
  const _MacosPopupMenuItemButton({
    super.key,
    this.padding,
    required this.route,
    required this.buttonRect,
    required this.constraints,
    required this.itemIndex,
  });

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
      setState(() => _isHovered = true);
    } else {
      setState(() => _isHovered = false);
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
            onKeyEvent: (FocusNode node, KeyEvent event) {
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
                    ? MacosPopupButtonTheme.of(context).highlightColor
                    : Colors.transparent,
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
    super.key,
    this.padding,
    required this.route,
    required this.buttonRect,
    required this.constraints,
    this.popupColor,
    required this.hasTopItemsNotShown,
    required this.hasBottomItemsNotShown,
  });

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
      widget.popupColor ?? MacosPopupButtonTheme.of(context).popupColor,
      context,
    );
    final caretColor =
        brightness.resolve(CupertinoColors.black, CupertinoColors.white);

    final itemsList = ListView.builder(
      controller: widget.route.scrollController,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
      padding: const EdgeInsets.all(4.0),
      shrinkWrap: true,
    );

    return FadeTransition(
      opacity: _fadeOpacity,
      child: Semantics(
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: false,
            overscroll: false,
            physics: const ClampingScrollPhysics(),
            platform: TargetPlatform.macOS,
          ),
          child: PrimaryScrollController(
            controller: widget.route.scrollController!,
            child: NotificationListener(
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
              child: MacosOverlayFilter(
                color: popupColor?.withValues(alpha: 0.25),
                borderRadius: _kBorderRadius,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _showTopCaret
                        ? Container(
                            width: widget.buttonRect.width,
                            height: widget.buttonRect.height,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: _kSideRadius,
                                topRight: _kSideRadius,
                              ),
                            ),
                            child: Icon(
                              CupertinoIcons.chevron_up,
                              color: caretColor,
                              size: 12.0,
                            ),
                          )
                        : const SizedBox.shrink(),
                    // Wrap the items list with an Expanded widget for to
                    // avoid height overflow when having a lot of items.
                    _showTopCaret || _showBottomCaret
                        ? Expanded(
                            child: itemsList,
                          )
                        : itemsList,
                    _showBottomCaret
                        ? Container(
                            width: widget.buttonRect.width,
                            height: widget.buttonRect.height,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: _kSideRadius,
                                bottomRight: _kSideRadius,
                              ),
                            ),
                            child: Icon(
                              CupertinoIcons.chevron_down,
                              color: caretColor,
                              size: 12.0,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
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
    if (items.isNotEmpty) {
      preferredMenuHeight +=
          itemHeights.reduce((double total, double height) => total + height);
    }

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
    super.key,
    required this.route,
    required this.constraints,
    this.items,
    required this.padding,
    required this.buttonRect,
    required this.selectedIndex,
    required this.capturedThemes,
    this.style,
    required this.popupColor,
  });

  final _MacosPopupRoute<T> route;
  final BoxConstraints constraints;
  final List<_MenuItem<T>>? items;
  final EdgeInsetsGeometry padding;
  final Rect buttonRect;
  final int selectedIndex;
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
    route.scrollController ??=
        ScrollController(initialScrollOffset: menuLimits.scrollOffset);

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
    super.key,
    required this.onLayout,
    required this.item,
  }) : super(child: item);

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
    super.key,
    this.alignment = AlignmentDirectional.centerStart,
    required this.child,
  });

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
    super.key,
    this.onTap,
    this.value,
    this.enabled = true,
    super.alignment,
    required super.child,
  });

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
  /// The [autofocus] argument must not be null.
  ///
  /// The [popupColor] argument specifies the background color of the
  /// popup when it is open. If it is null, the appropriate macOS canvas color
  /// will be used.
  MacosPopupButton({
    super.key,
    required this.items,
    this.selectedItemBuilder,
    this.value,
    this.hint,
    this.disabledHint,
    required this.onChanged,
    this.onTap,
    this.style,
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
        assert(itemHeight == null || itemHeight >= _kMinInteractiveDimension);

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

  /// The text style to use for text in the popup button and the popup
  /// menu that appears when you tap the button.
  ///
  /// To use a separate text style for selected item when it's displayed within
  /// the popup button, consider using [selectedItemBuilder].
  ///
  /// Defaults to MacosTheme.of(context).typography.body.
  final TextStyle? style;

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
    properties.add(DiagnosticsProperty('alignment', alignment));
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
    final FocusManager focusManager = WidgetsBinding.instance.focusManager;
    _focusHighlightMode = focusManager.highlightMode;
    focusManager.addHighlightModeListener(_handleFocusHighlightModeChange);
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

  // Only used if needed to create _internalNode.
  FocusNode _createFocusNode() {
    return FocusNode(debugLabel: '${widget.runtimeType}');
  }

  void _removeMacosPopupRoute() {
    _popupRoute?._dismiss();
    _popupRoute = null;
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

  void _handleTap() {
    final TextDirection? textDirection = Directionality.maybeOf(context);
    const EdgeInsetsGeometry menuMargin = EdgeInsets.symmetric(horizontal: 4.0);

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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeMacosPopupRoute();
    WidgetsBinding.instance.focusManager
        .removeHighlightModeListener(_handleFocusHighlightModeChange);
    focusNode!.removeListener(_handleFocusChanged);
    _internalNode?.dispose();
    super.dispose();
  }

  TextStyle? get _textStyle =>
      widget.style ?? MacosTheme.of(context).typography.body;

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
      if (widget.selectedItemBuilder == null) {
        displayedHint = _MacosPopupMenuItemContainer(child: displayedHint);
      }

      hintIndex = items.length;
      items.add(
        ExcludeSemantics(
          child: IgnorePointer(
            child: displayedHint,
          ),
        ),
      );
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
    final buttonStyles = _getButtonStyles(
      widget.items != null && widget.items!.isNotEmpty,
      context,
    );

    Widget result = DefaultTextStyle(
      style: _textStyle!.copyWith(
        color: buttonStyles.textColor,
      ),
      child: Container(
        decoration: _showHighlight
            ? const BoxDecoration(
                color: MacosColors.findHighlightColor,
                borderRadius: _kBorderRadius,
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
                color: buttonStyles.bgColor,
                border: Border.all(
                  width: 0.5,
                  color: buttonStyles.borderColor,
                ),
                borderRadius: _kBorderRadius,
              ),
        padding: const EdgeInsets.only(left: 8.0, right: 2.0),
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
                    color: buttonStyles.caretColor,
                    backgroundColor: buttonStyles.caretBgColor,
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

// We use this utility function to get the appropriate styling, according to the
// macOS Design Guidelines and the current MacosPopupButtonTheme.
_ButtonStyles _getButtonStyles(
  bool enabled,
  BuildContext context,
) {
  final theme = MacosTheme.of(context);
  final brightness = theme.brightness;
  final popupTheme = MacosPopupButtonTheme.of(context);
  Color textColor = theme.typography.body.color!;
  Color bgColor = popupTheme.backgroundColor!;
  Color borderColor = brightness.resolve(
    const Color(0xffc3c4c9),
    const Color(0xff222222),
  );
  Color caretColor = MacosColors.white;
  Color caretBgColor = popupTheme.highlightColor!;
  if (!enabled) {
    caretBgColor = MacosColors.transparent;
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
  } else {
    borderColor = brightness.resolve(
      const Color(0xffc3c4c9),
      const Color(0xff222222),
    );
    caretBgColor = popupTheme.highlightColor!;
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

class _UpDownCaretsPainter extends CustomPainter {
  const _UpDownCaretsPainter({
    required this.color,
    required this.backgroundColor,
  });

  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    const radius = 4.0;
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
    final p3 = Offset(size.width / 2 + 1.0, vPadding + 1.0);
    final p4 = Offset(size.width - hPadding, size.height / 2 - 2.0);
    final p5 = Offset(hPadding, size.height / 2 + 2.0);
    final p6 = Offset(size.width / 2, size.height - vPadding);
    final p7 = Offset(size.width / 2 + 1.0, size.height - vPadding - 1.0);
    final p8 = Offset(size.width - hPadding, size.height / 2 + 2.0);
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.6;
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p3, p4, paint);
    canvas.drawLine(p5, p6, paint);
    canvas.drawLine(p7, p8, paint);
  }

  @override
  bool shouldRepaint(_UpDownCaretsPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_UpDownCaretsPainter oldDelegate) => false;
}
