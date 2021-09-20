library context_menu;

import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import './context_menu_area.dart';

/// The base class which defines the basic structure of a
/// context menu item.
/// You can use this class to create a custom context menu item.
///
/// See also
/// * [ContextMenuItem], a implementation of a context menu item with a label
/// * [ContextMenuDivider], a macos style divider for context menus
/// * [ContextMenuEntryState], the state that should be used for a [ContextMenuEntry]
abstract class ContextMenuEntry<T> extends StatefulWidget {
  /// Base class that should be used to create custom context menu items
  const ContextMenuEntry({
    this.value,
    this.onTap,
    Key? key,
  }) : super(key: key);

  /// The value that will be returned if the entry is selected
  final T? value;

  /// The callback function that will be called if the entry is selected.
  /// It is invoked in [ContextMenuEntryState.handleTap].
  final Function? onTap;

  @override
  @protected
  @factory
  ContextMenuEntryState createState();
}

/// The [ContextMenuEntryState] is the state taht should be used for a [ContextMenuEntry],
/// providing standard functionality like [ContextMenuEntryState.handleTap] which can be
/// used in a custom implementation of a [ContextMenuEntry] like for example [ContextMenuItem].
///
/// See also:
/// * [ContextMenuEntry], the [StatefulWidget] class that should be used for this state
abstract class ContextMenuEntryState<W extends ContextMenuEntry, T>
    extends State<W> {
  /// This function will handle the onTap of a [ContextMenuEntry].
  /// It calls [ContextMenuEntry.onTap] if available and afterwards
  /// pops the route that is created by [showContextMenu] and returns
  /// the [ContextMenuEntry.value].
  @mustCallSuper
  @protected
  void handleTap() {
    widget.onTap?.call();
    Navigator.pop<T>(context, widget.value);
  }
}
