library context_menu;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'context_menu_entry.dart';

class ContextMenuItem<T> extends ContextMenuEntry<T> {
  const ContextMenuItem({required this.label, this.value, this.onTap, Key? key})
      : super(key: key, value: value, onTap: onTap);
  final String label;
  final T? value;
  final Function? onTap;

  @override
  _ContextMenuItemState<T> createState() => _ContextMenuItemState<T>();
}

class _ContextMenuItemState<T>
    extends ContextMenuEntryState<ContextMenuItem, T> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    // TODO: Change MouseRegion with GestureDetector
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: GestureDetector(
        onTap: handleTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
          decoration: BoxDecoration(
            color: _isHovering ? const Color(0xFF6B9FF8) : Colors.transparent,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            widget.label,
            style: TextStyle(color: _isHovering ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
