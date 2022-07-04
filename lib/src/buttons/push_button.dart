// ignore_for_file: prefer_if_null_operators

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// The sizes a [PushButton] can be.
enum ButtonSize {
  /// A large [PushButton].
  large,

  /// A small [PushButton].
  small,
}

const EdgeInsetsGeometry _kSmallButtonPadding = EdgeInsets.symmetric(
  vertical: 3.0,
  horizontal: 8.0,
);
const EdgeInsetsGeometry _kLargeButtonPadding = EdgeInsets.symmetric(
  vertical: 6.0,
  horizontal: 8.0,
);

const BorderRadius _kSmallButtonRadius = BorderRadius.all(Radius.circular(5.0));
const BorderRadius _kLargeButtonRadius = BorderRadius.all(Radius.circular(7.0));

/// {@template pushButton}
/// A macOS-style button.
/// {@endtemplate}
class PushButton extends StatefulWidget {
  /// {@macro pushButton}
  const PushButton({
    super.key,
    required this.child,
    required this.buttonSize,
    this.padding,
    this.color,
    this.disabledColor,
    this.onPressed,
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.basic,
    this.isSecondary,
  }) : assert(pressedOpacity == null ||
            (pressedOpacity >= 0.0 && pressedOpacity <= 1.0));

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  /// The size of the button.
  ///
  /// Must be either [ButtonSize.small] or [ButtonSize.large].
  ///
  /// Small buttons have a `padding` of [_kSmallButtonPadding] and a
  /// `borderRadius` of [_kSmallButtonRadius]. Large buttons have a `padding`
  /// of [_kLargeButtonPadding] and a `borderRadius` of [_kLargeButtonRadius].
  final ButtonSize buttonSize;

  /// The amount of space to surround the child inside the bounds of the button.
  ///
  /// Leave blank to use the default padding provided by [_kSmallButtonPadding]
  /// or [_kLargeButtonPadding].
  final EdgeInsetsGeometry? padding;

  /// The color of the button's background.
  final Color? color;

  /// The color of the button's background when the button is disabled.
  ///
  /// Ignored if the [PushButton] doesn't also have a [color].
  ///
  /// Defaults to [CupertinoColors.quaternarySystemFill] when [color] is
  /// specified. Must not be null.
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

  /// The radius of the button's corners when it has a background color.
  ///
  /// Leave blank to use the default radius provided by [_kSmallButtonRadius]
  /// or [_kLargeButtonRadius].
  final BorderRadiusGeometry? borderRadius;

  /// The alignment of the button's [child].
  ///
  /// Typically buttons are sized to be just big enough to contain the child and its
  /// [padding]. If the button's size is constrained to a fixed size, for example by
  /// enclosing it with a [SizedBox], this property defines how the child is aligned
  /// within the available space.
  ///
  /// Always defaults to [Alignment.center].
  final AlignmentGeometry alignment;

  /// The mouse cursor to use when hovering over this widget.
  final MouseCursor? mouseCursor;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  /// Whether the button is used as a secondary action button (e.g. Cancel buttons in dialogs)
  ///
  /// Sets its background color to [PushButtonThemeData]'s [secondaryColor] attributes (defaults
  /// are gray colors). Can still be overriden if the [color] attribute is non-null.
  final bool? isSecondary;

  /// Whether the button is enabled or disabled. Buttons are disabled by default. To
  /// enable a button, set its [onPressed] property to a non-null value.
  bool get enabled => onPressed != null;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<ButtonSize>('buttonSize', buttonSize));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('disabledColor', disabledColor));
    properties.add(DoubleProperty('pressedOpacity', pressedOpacity));
    properties.add(DiagnosticsProperty('alignment', alignment));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties.add(DiagnosticsProperty('borderRadius', borderRadius));
    properties.add(FlagProperty(
      'enabled',
      value: enabled,
      ifFalse: 'disabled',
    ));
    properties.add(DiagnosticsProperty('isSecondary', isSecondary));
  }

  @override
  PushButtonState createState() => PushButtonState();
}

class PushButtonState extends State<PushButton>
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
  void didUpdateWidget(PushButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity ?? 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final bool enabled = widget.enabled;
    final bool isSecondary = widget.isSecondary != null && widget.isSecondary!;
    final MacosThemeData theme = MacosTheme.of(context);
    final Color backgroundColor = MacosDynamicColor.resolve(
      widget.color ??
          (isSecondary
              ? theme.pushButtonTheme.secondaryColor!
              : theme.pushButtonTheme.color!),
      context,
    );

    final Color disabledColor = MacosDynamicColor.resolve(
      widget.disabledColor ?? theme.pushButtonTheme.disabledColor!,
      context,
    );

    final EdgeInsetsGeometry? buttonPadding = widget.padding == null
        ? widget.buttonSize == ButtonSize.small
            ? _kSmallButtonPadding
            : _kLargeButtonPadding
        : widget.padding;

    final BorderRadiusGeometry? borderRadius = widget.borderRadius == null
        ? widget.buttonSize == ButtonSize.small
            ? _kSmallButtonRadius
            : _kLargeButtonRadius
        : widget.borderRadius;

    final Color foregroundColor = widget.enabled
        ? textLuminance(backgroundColor)
        : theme.brightness.isDark
            ? const Color.fromRGBO(255, 255, 255, 0.25)
            : const Color.fromRGBO(0, 0, 0, 0.25);

    final TextStyle textStyle =
        theme.typography.headline.copyWith(color: foregroundColor);

    return MouseRegion(
      cursor: widget.mouseCursor!,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? _handleTapDown : null,
        onTapUp: enabled ? _handleTapUp : null,
        onTapCancel: enabled ? _handleTapCancel : null,
        onTap: widget.onPressed,
        child: Semantics(
          button: true,
          label: widget.semanticLabel,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 49,
              minHeight: 20,
            ),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: !enabled ? disabledColor : backgroundColor,
                ),
                child: Padding(
                  padding: buttonPadding!,
                  child: Align(
                    alignment: widget.alignment,
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: DefaultTextStyle(
                      style: textStyle,
                      child: widget.child,
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
