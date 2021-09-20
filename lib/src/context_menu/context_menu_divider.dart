library context_menu;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'context_menu_entry.dart';

/// A macos stlye context menu divider.
class ContextMenuDivider<Never> extends ContextMenuEntry<Never> {
  const ContextMenuDivider({Key? key}) : super(key: key);
  @override
  _ContextMenuDividerState createState() => _ContextMenuDividerState();
}

class _ContextMenuDividerState
    extends ContextMenuEntryState<ContextMenuDivider, Never> {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: const Color(0xFFCFCCCE),
      indent: 10.0,
      endIndent: 10.0,
      thickness: 1.0,
    );
  }
}
