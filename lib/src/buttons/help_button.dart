import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A help button appears within a view and opens app-specific help documentation when clicked.
/// For help documentation creation guidance, see Help. All help buttons are circular,
/// consistently sized buttons that contain a question mark icon. Whenever possible,
/// open a help topic related to the current context. For example,
/// the Rules pane of Mail preferences includes a help button.
/// When clicked, it opens directly to a Rules preferences help topic.
class HelpButton extends StatefulWidget {
  ///pressedOpacity, if non-null, must be in the range if 0.0 to 1.0
  const HelpButton({
    super.key,
    this.color,
    this.disabledColor,
    this.onPressed,
    this.pressedOpacity = 0.4,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.basic,
  }) : assert(pressedOpacity == null ||
            (pressedOpacity >= 0.0 && pressedOpacity <= 1.0));

  /// The color of the button's background.
  final Color? color;

  /// The color of the button's background when the button is disabled.
  ///
  /// Ignored if the [HelpButton] doesn't also have a [color].
  ///
  /// Defaults to [CupertinoColors.quaternarySystemFill] when [color] is
  /// specified.
  final Color? disabledColor;

  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback? onPressed;

  /// The opacity that the button will fade to when it is pressed.
  /// The button will have an opacity of 1.0 when it is not pressed.
  ///
  /// This defaults to 0.4. If null, opacity will not change on pressed if using
  /// your own custom effects is desired.
  final double? pressedOpacity;

  /// The alignment of the button's [child].
  ///
  /// Typically buttons are sized to be just big enough to contain the child and its
  /// [padding]. If the button's size is constrained to a fixed size, for example by
  /// enclosing it with a [SizedBox], this property defines how the child is aligned
  /// within the available space.
  ///
  /// Always defaults to [Alignment.center].
  final AlignmentGeometry alignment;

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
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('disabledColor', disabledColor));
    properties.add(DoubleProperty('pressedOpacity', pressedOpacity));
    properties.add(DiagnosticsProperty('alignment', alignment));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }

  @override
  HelpButtonState createState() => HelpButtonState();
}

class HelpButtonState extends State<HelpButton>
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
  void didUpdateWidget(HelpButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity ?? 1.0;
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
    final MacosThemeData theme = MacosTheme.of(context);
    final Color backgroundColor = MacosDynamicColor.resolve(
      widget.color ?? theme.helpButtonTheme.color!,
      context,
    );

    final Color disabledColor = MacosDynamicColor.resolve(
      widget.disabledColor ?? theme.helpButtonTheme.disabledColor!,
      context,
    );

    final Color foregroundColor = widget.enabled
        ? helpIconLuminance(backgroundColor, theme.brightness.isDark)
        : theme.brightness.isDark
            ? const Color.fromRGBO(255, 255, 255, 0.25)
            : const Color.fromRGBO(0, 0, 0, 0.25);

    return MouseRegion(
      cursor: widget.mouseCursor!,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? _handleTapDown : null,
        onTapUp: enabled ? _handleTapUp : null,
        onTapCancel: enabled ? _handleTapCancel : null,
        onTap: widget.onPressed,
        child: Semantics(
          label: widget.semanticLabel,
          button: true,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 20,
              minHeight: 20,
              maxWidth: 20,
              maxHeight: 20,
            ),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: !enabled ? disabledColor : backgroundColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      offset: Offset(-0.1, -0.1),
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      offset: Offset(0.1, 0.1),
                    ),
                    BoxShadow(
                      color: CupertinoColors.tertiarySystemFill,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Align(
                  alignment: widget.alignment,
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Icon(
                    CupertinoIcons.question,
                    color: foregroundColor,
                    size: 13,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
