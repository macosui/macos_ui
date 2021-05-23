import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A macOS style back button.
class BackButton extends StatefulWidget {
  /// Creates a `BackButton` with the appropriate icon/background colors based
  /// on light/dark themes.
  const BackButton({
    Key? key,
    this.onPressed,
    this.fillColor,
    this.semanticLabel,
  }) : super(key: key);

  /// An override callback to perform instead of the default behavior which is
  /// to pop the [Navigator].
  final VoidCallback? onPressed;

  /// The color to fill the space around the icon with.
  final Color? fillColor;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  /// Whether the button is enabled or disabled. Buttons are disabled by default. To
  /// enable a button, set its [onPressed] property to a non-null value.
  bool get enabled => onPressed != null;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('fillColor', fillColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties.add(FlagProperty(
      'enabled',
      value: enabled,
      ifFalse: 'disabled',
    ));
  }

  @override
  _BackButtonState createState() => _BackButtonState();
}

class _BackButtonState extends State<BackButton>
    with SingleTickerProviderStateMixin {
  // Eyeballed values. Feel free to tweak.
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
  void didUpdateWidget(BackButton old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) return;
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0, duration: kFadeOutDuration)
        : _animationController.animateTo(0.0, duration: kFadeInDuration);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;
    final brightness = MacosTheme.of(context).brightness;
    final iconColor = brightness == Brightness.dark
        ? CupertinoColors.white
        : CupertinoColors.black;

    Color? _fillColor;
    if (widget.fillColor != null) {
      _fillColor = widget.fillColor;
    } else {
      _fillColor =
          brightness == Brightness.dark ? Color(0xff323232) : Color(0xffF4F5F5);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
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
            constraints: BoxConstraints(
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
                      color: _buttonHeldDown && brightness == Brightness.dark
                          ? Color(0xff3C383C)
                          : _buttonHeldDown && brightness == Brightness.light
                              ? Color(0xffE5E5E5)
                              : _fillColor,
                      borderRadius: BorderRadius.circular(7),
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
