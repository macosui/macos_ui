library context_menu;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

import 'context_menu_entry.dart';

const _kHoverBackgroundColor = const Color(0xFF6B9FF8);

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
    assert(debugCheckHasMacosTheme(context));
    final brightness = MacosTheme.brightnessOf(context);
    final defaultTextStyle = DefaultTextStyle.of(context).style;

    final hoverTextColor = brightness.resolve(
      Colors.white,
      Colors.white,
    );

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: handleTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
          decoration: BoxDecoration(
            color: _isHovering ? _kHoverBackgroundColor : Colors.transparent,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            widget.label,
            style: _isHovering ? defaultTextStyle.copyWith(color: hoverTextColor) : defaultTextStyle,
          ),
        ),
      ),
    );
  }

  void _onExit(PointerExitEvent? event) {
    setState(() {
      _isHovering = false;
    });
  }

  void _onEnter(PointerEnterEvent? event) {
    setState(() {
      _isHovering = true;
    });
  }
}
