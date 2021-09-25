library context_menu;

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

import 'context_menu_divider.dart';
import 'context_menu_entry.dart';
import 'context_menu_item.dart';

/// Signature of the function which is used to construct the items
/// of the context menu.
///
/// Used in [ContextMenuArea.itemBuilder] and [showContextMenu]
typedef ContextMenuItemBuilder<T> = List<ContextMenuEntry<T>> Function(
    BuildContext context);

/// Signature for the callback function that is invoked if
/// a context menu item is selected.
///
/// Used in [ContextMenuArea.itemSelected]
typedef ContextMenuItemSelected<T> = void Function(T);

/// Defines the padding of the overlay in which the context menu
/// can appear.
const double _kMenuScreenPadding = 8.0;

/// The witdth of one context menu container.
const double kContextMenuWidth = 180.0;

const _kDialogBorderRadius = BorderRadius.all(Radius.circular(5.0));

/// The ContextMenuArea defines an area in which a
/// context menu can be invoked.
/// The items of the context menu are defined in the [ContextMenuArea.itemBuilder]
/// and consists of [ContextMenuEntry] items.
///
/// When an item is selected the [ContextMenuArea.itemSelected] callback is invoked
/// and emits the given value of the selected [ContextMenuEntry].
///
/// {@tool snippet}
///
/// This example shows a context menu area in red with four selectable items.
/// The return value of the selected item will be [String].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return ContextMenuArea<String>(
///     itemSelected: (value) => doSomethingWithValue(value),
///     itemBuilder: (itemBuilderContext) {
///       return [
///         ContextMenuItem<String>(
///           label: 'item one',
///           value: 'one',
///         ),
///         ContextMenuItem<String>(
///           label: 'item two',
///           value: 'two',
///         ),
///         ContextMenuItem<String>(
///           label: 'item three',
///           value: 'three',
///         ),
///         ContextMenuItem<String>(
///           label: 'item four',
///           value: 'four',
///         ),
///       ];
///     }
///     child: Container(
///       width: 100.0
///       height: 100.0,
///       color: Colors.red
///     ),
///   );
/// }
/// ```
///
/// {@end-tool}
///
/// See also:
/// * [ContextMenuItem], a context menu item with a label
/// * [ContextMenuDivider], a macos style context menu divider
/// * [ContextMenuEntry], the base class to create custom context menu items
/// * [showContextMenu], a method to manually show a context menu
class ContextMenuArea<T> extends StatelessWidget {
  /// Defines an area in which a context menu can be invoked
  const ContextMenuArea(
      {required this.itemBuilder,
      required this.child,
      this.itemSelected,
      Key? key})
      : super(key: key);

  /// The widget in which the context menu is available
  final Widget child;

  /// This is the builder function used to define
  /// the context menu items.
  ///
  /// The elements should be of the type [ContextMenuEntry].
  final ContextMenuItemBuilder<T> itemBuilder;

  /// The callback function which is invoked after an item
  /// is selected or if the context menu is dismissed.
  final ContextMenuItemSelected<T?>? itemSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) async {
        var res = await showContextMenu<T>(
          context: context,
          position: details.globalPosition,
          builder: itemBuilder,
        );
        itemSelected?.call(res);
      },
      child: child,
    );
  }
}

/// This function is used to create a context menu at a given position.
/// It uses [Navigator] to create a new route which is dismissable. Therefore
/// the given context should contain a [NavigatorState].
///
/// If the context menu is dismissed a value of null is returned.
/// If a context menu item is selected the created route is popped and the context
/// menu item will return the value it contains.
Future<T?> showContextMenu<T>({
  required BuildContext context,
  required Offset position,
  required ContextMenuItemBuilder<T> builder,
}) {
  final MediaQueryData mediaQuery = MediaQuery.of(context);

  var items = builder(context);

  return showDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'ContextMenu',
    barrierColor: null,
    builder: (context) {
      return CustomSingleChildLayout(
        delegate: _ContextMenuDelegate(
          position: position,
          padding: mediaQuery.padding,
        ),
        child: _Menu<T>(items: items),
      );
    },
  );
}

/// This delegate is used to position a [_Menu].
class _ContextMenuDelegate extends SingleChildLayoutDelegate {
  _ContextMenuDelegate({required this.position, required this.padding});

  final EdgeInsets padding;
  final Offset position;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(_kMenuScreenPadding) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    var dx = position.dx;
    var dy = position.dy;
    if ((position.dx + childSize.width) >= size.width) {
      dx = position.dx - childSize.width;
    }
    if ((position.dy + childSize.height) >= size.height) {
      dy = position.dy - childSize.height;
    }

    return Offset(dx, dy);
  }

  @override
  bool shouldRelayout(covariant _ContextMenuDelegate oldDelegate) {
    return padding != oldDelegate.padding || position != oldDelegate.position;
  }
}

/// The Wrapper Element which contains all context menu items.
class _Menu<T> extends StatelessWidget {
  /// Creates the wrapper for a context menu.
  const _Menu({required this.items, Key? key}) : super(key: key);

  /// The items which will be displayed in the context menu
  final List<ContextMenuEntry<T>> items;

  Widget _optionalBlur({required Widget child, required Brightness brightness}) {
    return brightness.resolve<Widget>(
      child, 
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final brightness = MacosTheme.brightnessOf(context);

    final outerBorderColor = brightness.resolve(
      Colors.black.withOpacity(0.23),
      Colors.black.withOpacity(0.76),
    );

    final innerBorderColor = brightness.resolve(
      Colors.white.withOpacity(0.45),
      Colors.white.withOpacity(0.15),
    );

    final backgroundColor = brightness.resolve(
      CupertinoColors.systemGrey6.color,
      MacosColors.controlBackgroundColor.darkColor.withOpacity(0.85),
    );
    
    return ClipRect(
      child: _optionalBlur(
        brightness: brightness,
        child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset.zero,
                blurRadius: 3.0),
          ],
        border: Border.all(
          width: 2,
          color: innerBorderColor,
        ),
        borderRadius: _kDialogBorderRadius,
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: outerBorderColor,
        ),
        borderRadius: _kDialogBorderRadius,
      ),
        width: kContextMenuWidth,
        child: DefaultTextStyle(
          textAlign: TextAlign.start,
          style: MacosTheme.of(context).typography.body,
          child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items,
          ),
        ),
        ),
      )
      ),
    );
  }
}
