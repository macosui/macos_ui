// ignore_for_file: prefer_if_null_operators

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const _kMiniButtonSize = Size(26.0, 11.0);
const _kSmallButtonSize = Size(39.0, 14.0);
const _kRegularButtonSize = Size(60.0, 18.0);
const _kLargeButtonSize = Size(48.0, 26.0);

const _kMiniButtonPadding = EdgeInsets.only(left: 6.0, right: 6.0, bottom: 1.0);
const _kSmallButtonPadding = EdgeInsets.symmetric(
  vertical: 1.0,
  horizontal: 7.0,
);
const _kRegularButtonPadding = EdgeInsets.only(
  left: 8.0,
  right: 8.0,
  top: 1.0,
  bottom: 4.0,
);
const _kLargeButtonPadding = EdgeInsets.only(
  right: 8.0,
  left: 8.0,
  bottom: 1.0,
);

const _kMiniButtonRadius = BorderRadius.all(Radius.circular(2.0));
const _kSmallButtonRadius = BorderRadius.all(Radius.circular(2.0));
const _kRegularButtonRadius = BorderRadius.all(Radius.circular(5.0));
const _kLargeButtonRadius = BorderRadius.all(Radius.circular(7.0));

/// Shortcuts for various [PushButton] properties based on the [ControlSize].
extension PushButtonControlSizeX on ControlSize {
  /// Determines the padding of the button's text.
  EdgeInsetsGeometry get padding {
    switch (this) {
      case ControlSize.mini:
        return _kMiniButtonPadding;
      case ControlSize.small:
        return _kSmallButtonPadding;
      case ControlSize.regular:
        return _kRegularButtonPadding;
      case ControlSize.large:
        return _kLargeButtonPadding;
    }
  }

  /// Determines the button's border radius.
  BorderRadiusGeometry get borderRadius {
    switch (this) {
      case ControlSize.mini:
        return _kMiniButtonRadius;
      case ControlSize.small:
        return _kSmallButtonRadius;
      case ControlSize.regular:
        return _kRegularButtonRadius;
      case ControlSize.large:
        return _kLargeButtonRadius;
    }
  }

  /// Determines the styling of the button's text.
  TextStyle textStyle(TextStyle baseStyle) {
    switch (this) {
      case ControlSize.mini:
        return baseStyle.copyWith(fontSize: 9.0);
      case ControlSize.small:
        return baseStyle.copyWith(fontSize: 11.0);
      case ControlSize.regular:
        return baseStyle.copyWith(fontSize: 13.0);
      case ControlSize.large:
        return baseStyle;
    }
  }

  /// Determines the button's minimum size.
  BoxConstraints get constraints {
    switch (this) {
      case ControlSize.mini:
        return BoxConstraints(
          minHeight: _kMiniButtonSize.height,
          minWidth: _kMiniButtonSize.width,
        );
      case ControlSize.small:
        return BoxConstraints(
          minHeight: _kSmallButtonSize.height,
          minWidth: _kSmallButtonSize.width,
        );
      case ControlSize.regular:
        return BoxConstraints(
          minHeight: _kRegularButtonSize.height,
          minWidth: _kRegularButtonSize.width,
        );
      case ControlSize.large:
        return BoxConstraints(
          minHeight: _kLargeButtonSize.height,
          minWidth: _kLargeButtonSize.width,
        );
    }
  }
}

/// {@template pushButton}
/// A macOS-style button.
/// {@endtemplate}
class PushButton extends StatefulWidget {
  /// {@macro pushButton}
  const PushButton({
    super.key,
    required this.child,
    required this.controlSize,
    this.padding,
    this.color,
    this.disabledColor,
    this.onPressed,
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.basic,
    this.secondary,
  }) : assert(pressedOpacity == null ||
            (pressedOpacity >= 0.0 && pressedOpacity <= 1.0));

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  /// The size of the button.
  ///
  ///
  final ControlSize controlSize;

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
  /// are gray colors). Can still be overridden if the [color] attribute is non-null.
  final bool? secondary;

  /// Whether the button is enabled or disabled. Buttons are disabled by default. To
  /// enable a button, set its [onPressed] property to a non-null value.
  bool get enabled => onPressed != null;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<ControlSize>('controlSize', controlSize));
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
    properties.add(DiagnosticsProperty('secondary', secondary));
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

  @visibleForTesting
  bool buttonHeldDown = false;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final bool enabled = widget.enabled;
    final bool isSecondary = widget.secondary != null && widget.secondary!;
    final MacosThemeData theme = MacosTheme.of(context);
    final Color backgroundColor = MacosDynamicColor.resolve(
      widget.color ??
          (isSecondary
              ? theme.pushButtonTheme.secondaryColor!
              : theme.pushButtonTheme.color!),
      context,
    );

    final disabledColor = !isSecondary
        ? backgroundColor.withOpacity(0.5)
        : backgroundColor.withOpacity(0.25);

    final Color foregroundColor = widget.enabled
        ? textLuminance(backgroundColor)
        : theme.brightness.isDark
            ? const Color.fromRGBO(255, 255, 255, 0.25)
            : const Color.fromRGBO(0, 0, 0, 0.25);

    final baseStyle =
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
            constraints: widget.controlSize.constraints,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: widget.controlSize.borderRadius,
                  ),
                  // color: !enabled ? disabledColor : backgroundColor,
                  color: enabled ? backgroundColor : disabledColor,
                ),
                child: Padding(
                  padding: widget.controlSize.padding,
                  child: Align(
                    alignment: widget.alignment,
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: DefaultTextStyle(
                      style: widget.controlSize.textStyle(baseStyle),
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
