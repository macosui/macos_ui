import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A macOS style disclosure button.
class MacosDisclosureButton extends StatefulWidget {
  /// Creates a `DisclosureButton` with the appropriate icon/background colors based
  /// on light/dark themes.
  const MacosDisclosureButton({
    super.key,
    this.fillColor,
    this.semanticLabel,
    this.isPressed = false,
    this.mouseCursor = SystemMouseCursors.basic,
    this.onPressed,
  });

  /// The callback that is called when the button is tapped.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback? onPressed;

  /// The color to fill the space around the icon with.
  final Color? fillColor;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  /// The mouse cursor to use when hovering over this widget.
  final MouseCursor? mouseCursor;

  /// Whether the button is in the active state (chevron pointing up)
  /// or inactive state (chevron pointing down).
  final bool isPressed;

  /// Whether the button is enabled or disabled. Buttons are disabled by default.
  ///
  /// To enable a button, set its [onPressed] property to a non-null value.
  bool get enabled => onPressed != null;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('fillColor', fillColor));
    properties.add(ColorProperty('hoverColor', fillColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties.add(FlagProperty(
      'enabled',
      value: enabled,
      ifFalse: 'disabled',
    ));
  }

  @override
  MacosDisclosureButtonState createState() => MacosDisclosureButtonState();
}

class MacosDisclosureButtonState extends State<MacosDisclosureButton>
    with SingleTickerProviderStateMixin {
  static const Duration kFadeOutDuration = Duration(milliseconds: 10);
  static const Duration kFadeInDuration = Duration(milliseconds: 100);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(MacosDisclosureButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = 1.0;
  }

  @visibleForTesting
  bool buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!buttonHeldDown) {
      buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (buttonHeldDown) {
      buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (buttonHeldDown) {
      buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) return;
    final bool wasHeldDown = buttonHeldDown;
    final TickerFuture ticker = buttonHeldDown
        ? _animationController.animateTo(1.0, duration: kFadeOutDuration)
        : _animationController.animateTo(0.0, duration: kFadeInDuration);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != buttonHeldDown) _animate();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;
    final brightness = MacosTheme.of(context).brightness;
    final iconColor = brightness == Brightness.dark
        ? CupertinoColors.white
        : CupertinoColors.black;

    Color? fillColor;
    if (widget.fillColor != null) {
      fillColor = widget.fillColor;
    } else {
      fillColor = brightness == Brightness.dark
          ? const Color(0xff323232)
          : const Color(0xffF4F5F5);
    }

    return MouseRegion(
      cursor: widget.mouseCursor!,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? _handleTapDown : null,
        onTapUp: enabled ? _handleTapUp : null,
        onTapCancel: enabled ? _handleTapCancel : null,
        onTap: () {
          if (enabled) {
            widget.onPressed!();
          }
        },
        child: Semantics(
          button: true,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, widget1) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: buttonHeldDown
                          ? brightness == Brightness.dark
                              ? const MacosColor(0xff3C383C)
                              : const MacosColor(0xffE5E5E5)
                          : fillColor,
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                    ),
                    child: RotatedBox(
                      quarterTurns: widget.isPressed ? 1 : 3,
                      child: Icon(
                        CupertinoIcons.back,
                        size: 14,
                        color: iconColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
