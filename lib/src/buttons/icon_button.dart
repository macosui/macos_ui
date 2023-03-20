import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A macOS-style icon button.
class MacosIconButton extends StatefulWidget {
  /// Builds a macOS-style icon button
  const MacosIconButton({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.disabledColor,
    this.hoverColor,
    this.onPressed,
    this.pressedOpacity = 0.4,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.boxConstraints = const BoxConstraints(
      minHeight: 20,
      minWidth: 20,
      maxWidth: 30,
      maxHeight: 30,
    ),
    this.padding,
    this.mouseCursor = SystemMouseCursors.basic,
  }) : assert(pressedOpacity == null ||
            (pressedOpacity >= 0.0 && pressedOpacity <= 1.0));

  /// The widget to use as the icon.
  ///
  /// Typically an [Icon] widget.
  final Widget icon;

  /// The background color of this [MacosIconButton].
  ///
  /// Defaults to [CupertinoColors.activeBlue]. Set to [Colors.transparent] for
  /// a transparent background color.
  final Color? backgroundColor;

  /// The color of the button's background when the button is disabled.
  final Color? disabledColor;

  /// The color of the button's background when the mouse hovers over it.
  ///
  /// Set to Colors.transparent to disable the hover effect.
  final Color? hoverColor;

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

  /// The shape to make the button.
  ///
  /// Defaults to `BoxShape.rectangle`.
  final BoxShape shape;

  /// The border radius for the button.
  ///
  /// This should only be set if setting [shape] to `BoxShape.rectangle`.
  ///
  /// Defaults to `BorderRadius.circular(7.0)`.
  final BorderRadius? borderRadius;

  ///The alignment of the button's icon.
  ///
  /// Typically buttons are sized to be just big enough to contain the child and its
  /// [padding]. If the button's size is constrained to a fixed size, for example by
  /// enclosing it with a [SizedBox], this property defines how the child is aligned
  /// within the available space.
  ///
  /// Always defaults to [Alignment.center].
  final AlignmentGeometry alignment;

  /// The box constraints for the button.
  ///
  /// Defaults to
  /// ```dart
  /// const BoxConstraints(
  ///   minHeight: 20,
  ///   minWidth: 20,
  ///   maxWidth: 30,
  ///   maxHeight: 30,
  /// ),
  ///```
  final BoxConstraints boxConstraints;

  /// The internal padding for the button's [icon].
  ///
  /// Defaults to `EdgeInsets.all(8)`.
  final EdgeInsetsGeometry? padding;

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
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('disabledColor', disabledColor));
    properties.add(ColorProperty('hoverColor', hoverColor));
    properties.add(DoubleProperty('pressedOpacity', pressedOpacity));
    properties.add(DiagnosticsProperty('alignment', alignment));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }

  @override
  MacosIconButtonState createState() => MacosIconButtonState();
}

class MacosIconButtonState extends State<MacosIconButton>
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
        .drive(CurveTween(curve: const Interval(0.0, 0.25)))
        .drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(MacosIconButton oldWidget) {
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
    final theme = MacosIconButtonTheme.of(context);

    final Color backgroundColor =
        widget.backgroundColor ?? theme.backgroundColor!;

    final Color hoverColor = widget.hoverColor ?? theme.hoverColor!;

    final Color? disabledColor;

    if (widget.disabledColor != null) {
      disabledColor = MacosDynamicColor.resolve(
        widget.disabledColor!,
        context,
      );
    } else {
      disabledColor = theme.disabledColor;
    }

    final padding = widget.padding ?? theme.padding ?? const EdgeInsets.all(8);

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
        onTap: widget.onPressed,
        child: Semantics(
          label: widget.semanticLabel,
          button: true,
          child: ConstrainedBox(
            constraints: widget.boxConstraints,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: widget.shape,
                  // ignore: prefer_if_null_operators
                  borderRadius: widget.borderRadius != null
                      ? widget.borderRadius
                      : widget.shape == BoxShape.rectangle
                          ? const BorderRadius.all(Radius.circular(7))
                          : null,
                  color: !enabled
                      ? disabledColor
                      : _isHovered
                          ? hoverColor
                          : backgroundColor,
                ),
                child: Padding(
                  padding: padding,
                  child: Align(
                    alignment: widget.alignment,
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: widget.icon,
                    ),
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
