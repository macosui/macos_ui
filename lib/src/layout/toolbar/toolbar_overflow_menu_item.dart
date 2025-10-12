import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A menu-item that belongs in the toolbar overflowed actions menu.
class ToolbarOverflowMenuItem extends StatefulWidget {
  /// Builds a menu-item that belongs in the toolbar overflowed actions menu.
  const ToolbarOverflowMenuItem({
    super.key,
    this.onPressed,
    required this.label,
    this.subMenuItems,
    this.isSelected,
  });

  /// The callback that is called when the menu item is tapped or otherwise
  /// activated.
  ///
  /// If this is set to null, the menu item will be disabled (greyed out).
  final VoidCallback? onPressed;

  /// The label to show as the menu item's content.
  ///
  /// Must be non-null.
  final String label;

  /// An optional list of menu items to show in a submenu. This submenu will
  /// be opened at the left side, when the mouse hovers over this menu item.
  ///
  /// Used when a toolbar pulldown button is included in the toolbar overflowed actions menu.
  final List<ToolbarOverflowMenuItem>? subMenuItems;

  /// If this menu item is currently selected, i.e. its submenu is open.
  ///
  /// Used when a toolbar pulldown button is included in the toolbar overflowed actions menu.
  final bool? isSelected;

  @override
  State<ToolbarOverflowMenuItem> createState() =>
      _ToolbarOverflowMenuItemState();
}

class _ToolbarOverflowMenuItemState extends State<ToolbarOverflowMenuItem> {
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
    Navigator.pop(context);
    widget.onPressed?.call();
  }

  bool get _isHighlighted => _isHovered || widget.isSelected == true;

  Color get _textColor => _isHighlighted
      ? MacosColors.white
      : MacosTheme.brightnessOf(context).resolve(
          MacosColors.black,
          MacosColors.white,
        );

  @override
  Widget build(BuildContext context) {
    final MacosThemeData theme = MacosTheme.of(context);
    final hasSubMenu =
        widget.subMenuItems != null && widget.subMenuItems!.isNotEmpty;

    Widget child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      height: 20.0,
      child: Text(widget.label),
    );
    if (widget.onPressed != null) {
      child = MouseRegion(
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
                color: _isHighlighted
                    ? theme.pulldownButtonTheme.highlightColor
                    : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 13.0,
                  color: _textColor,
                ),
                child: (hasSubMenu)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          child,
                          MacosIcon(
                            CupertinoIcons.chevron_right,
                            size: 12.0,
                            color: _textColor,
                          ),
                        ],
                      )
                    : child,
              ),
            ),
          ),
        ),
      );
    } else {
      final textColor = MacosTheme.brightnessOf(context).resolve(
        MacosColors.disabledControlTextColor,
        MacosColors.disabledControlTextColor.darkColor,
      );
      child = DefaultTextStyle(
        style: theme.typography.body.copyWith(color: textColor),
        child: child,
      );
    }
    return child;
  }
}
