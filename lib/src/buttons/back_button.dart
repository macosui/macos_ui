import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A macOS style back button.
class MacosBackButton extends StatefulWidget {
  /// Creates a `BackButton` with the appropriate icon/background colors based
  /// on light/dark themes.
  const MacosBackButton({
    super.key,
    this.onPressed,
    this.fillColor,
    this.hoverColor,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.basic,
  });

  /// An override callback to perform instead of the default behavior which is
  /// to pop the [Navigator].
  final VoidCallback? onPressed;

  /// The color to fill the space around the icon with.
  final Color? fillColor;

  /// The color of the button's background when the mouse hovers over the button.
  final Color? hoverColor;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  /// The mouse cursor to use when hovering over this widget.
  final MouseCursor? mouseCursor;

  /// Whether the button is enabled or disabled. Buttons are disabled by default. To
  /// enable a button, set its [onPressed] property to a non-null value.
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
  MacosBackButtonState createState() => MacosBackButtonState();
}

class MacosBackButtonState extends State<MacosBackButton>
    with SingleTickerProviderStateMixin {
  // Eyeballed values. Feel free to tweak.
  static const Duration kFadeOutDuration = Duration(milliseconds: 10);
  static const Duration kFadeInDuration = Duration(milliseconds: 100);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  bool _isHovered = false;

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
  void didUpdateWidget(MacosBackButton oldWidget) {
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

    Color? hoverColor;
    if (widget.hoverColor != null) {
      hoverColor = widget.hoverColor;
    } else {
      hoverColor = brightness == Brightness.dark
          ? const Color(0xff333336)
          : const Color(0xffF3F2F2);
    }

    return MouseRegion(
      cursor: widget.mouseCursor!,
      onEnter: (e) {
        setState(() => _isHovered = true);
      },
      onExit: (e) {
        setState(() => _isHovered = false);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? _handleTapDown : null,
        onTapUp: enabled ? _handleTapUp : null,
        onTapCancel: enabled ? _handleTapCancel : null,
        onTap: () {
          if (enabled) {
            widget.onPressed!();
          } else {
            Navigator.of(context).maybePop();
          }
        },
        child: Semantics(
          button: true,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 20, // eyeballed
              minHeight: 20, // eyeballed
            ),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, widget) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: buttonHeldDown
                          ? brightness == Brightness.dark
                              ? const Color(0xff3C383C)
                              : const Color(0xffE5E5E5)
                          : _isHovered
                              ? hoverColor
                              : fillColor,
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                    ),
                    child: Icon(
                      CupertinoIcons.back,
                      size: 18, // eyeballed
                      color: iconColor,
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
