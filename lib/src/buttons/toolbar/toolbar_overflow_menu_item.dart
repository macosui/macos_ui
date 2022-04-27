import 'package:flutter/services.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/macos_colors.dart';
import 'package:macos_ui/src/theme/macos_theme.dart';

class ToolbarOverflowMenuItem extends StatefulWidget {
  const ToolbarOverflowMenuItem({
    Key? key,
    this.onPressed,
    required this.label,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String label;

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
    widget.onPressed?.call();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final MacosThemeData theme = MacosTheme.of(context);
    final brightness = MacosTheme.brightnessOf(context);
    Widget child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      height: 20.0,
      child: Text(widget.label),
    );
    if (widget.onPressed != null) {
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
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
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
  }
}
