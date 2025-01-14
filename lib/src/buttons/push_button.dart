// ignore_for_file: prefer_if_null_operators

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:gradient_borders/gradient_borders.dart';
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
/// A control that initiates an action.
///
/// Push Buttons are the standard button type in macOS.
///
/// Reference:
/// * [Button (SwiftUI)](https://developer.apple.com/documentation/SwiftUI/Button)
/// * [NSButton (AppKit)](https://developer.apple.com/documentation/appkit/nsbutton)
/// * [Buttons (Human Interface Guidelines)](https://developer.apple.com/design/human-interface-guidelines/buttons)
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
  @Deprecated("'PushButton' animations now match their native macOS’ "
      "counterparts. Therefore, its opacity no longer changes when it is "
      "pressed.")
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
  /// Can still be overridden if the [color] attribute is non-null.
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
  @override
  void didUpdateWidget(PushButton oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _handleTapDown(TapDownDetails event) {
    if (!buttonHeldDown) {
      setState(() => buttonHeldDown = true);
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (buttonHeldDown) {
      setState(() => buttonHeldDown = false);
    }
  }

  void _handleTapCancel() {
    if (buttonHeldDown) {
      setState(() => buttonHeldDown = false);
    }
  }

  @visibleForTesting
  bool buttonHeldDown = false;

  AccentColor _getAccentColor(BuildContext context) =>
      MacosTheme.of(context).accentColor ?? AccentColor.blue;

  BoxDecoration _getBoxDecoration() {
    // If the window isn’t currently the main window (that is, it is not in
    // focus), make the button look as if it was a secondary button.
    final isMainWindow = WindowMainStateListener.instance.isMainWindow;

    return _BoxDecorationBuilder.buildBoxDecoration(
      accentColor: _getAccentColor(context),
      isEnabled: widget.enabled,
      isDarkModeEnabled: MacosTheme.of(context).brightness.isDark,
      isSecondary: !isMainWindow || (widget.secondary ?? false),
    );
  }

  Color _getBackgroundColor() {
    final bool enabled = widget.enabled;
    final bool isSecondary = widget.secondary != null && widget.secondary!;
    final MacosThemeData theme = MacosTheme.of(context);

    // If the window isn’t currently the main window (that is, it is not in
    // focus), make the button look as if it was a secondary button.
    final isWindowMain = WindowMainStateListener.instance.isMainWindow;

    return MacosDynamicColor.resolve(
      widget.color ??
          _BoxDecorationBuilder.getGradientColors(
            accentColor: _getAccentColor(context),
            isEnabled: enabled,
            isDarkModeEnabled: theme.brightness.isDark,
            isSecondary: isSecondary || !isWindowMain,
          ).first,
      context,
    );
  }

  Color _getForegroundColor(Color backgroundColor) {
    final MacosThemeData theme = MacosTheme.of(context);

    final blendedBackgroundColor = Color.lerp(
      theme.canvasColor,
      backgroundColor,
      backgroundColor.a,
    )!;

    return widget.enabled
        ? textLuminance(blendedBackgroundColor)
        : textLuminance(blendedBackgroundColor).withValues(alpha: 0.25);
  }

  BoxDecoration _getClickEffectBoxDecoration() {
    final MacosThemeData theme = MacosTheme.of(context);
    final isDark = theme.brightness.isDark;

    final color = isDark
        ? const MacosColor.fromRGBO(255, 255, 255, 0.15)
        : const MacosColor.fromRGBO(0, 0, 0, 0.06);

    return BoxDecoration(
      color: color,
      borderRadius: widget.controlSize.borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final bool enabled = widget.enabled;
    final MacosThemeData theme = MacosTheme.of(context);

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
            child: StreamBuilder(
              stream: AccentColorListener.instance.onChanged,
              builder: (context, _) {
                return StreamBuilder<bool>(
                  stream: WindowMainStateListener.instance.onChanged,
                  builder: (context, _) {
                    final Color backgroundColor = _getBackgroundColor();

                    final Color foregroundColor =
                        _getForegroundColor(backgroundColor);

                    final baseStyle =
                        theme.typography.body.copyWith(color: foregroundColor);

                    return DecoratedBox(
                      decoration: _getBoxDecoration().copyWith(
                        borderRadius: widget.controlSize.borderRadius,
                      ),
                      child: Container(
                        foregroundDecoration: buttonHeldDown
                            ? _getClickEffectBoxDecoration()
                            : const BoxDecoration(),
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
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BoxDecorationBuilder {
  /// Gets the colors to use for the [BoxDecoration]’s gradient based on the
  /// provided [accentColor], [isEnabled], and [isDarkModeEnabled] properties.
  static List<Color> getGradientColors({
    required AccentColor accentColor,
    required bool isEnabled,
    required bool isDarkModeEnabled,
    required bool isSecondary,
  }) {
    final isEnabledFactor = isEnabled ? 1.0 : 0.5;

    if (isSecondary) {
      return isDarkModeEnabled
          ? [
              MacosColor.fromRGBO(255, 255, 255, 0.251 * isEnabledFactor),
              MacosColor.fromRGBO(255, 255, 255, 0.251 * isEnabledFactor),
            ]
          : [
              MacosColor.fromRGBO(255, 255, 255, 1.0 * isEnabledFactor),
              MacosColor.fromRGBO(255, 255, 255, 1.0 * isEnabledFactor),
            ];
    }

    if (isDarkModeEnabled) {
      switch (accentColor) {
        case AccentColor.blue:
          return [
            MacosColor.fromRGBO(0, 114, 238, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(0, 94, 211, 1.0 * isEnabledFactor),
          ];

        case AccentColor.purple:
          return [
            MacosColor.fromRGBO(135, 65, 131, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(120, 57, 116, 1.0 * isEnabledFactor),
          ];

        case AccentColor.pink:
          return [
            MacosColor.fromRGBO(188, 52, 105, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(168, 46, 93, 1.0 * isEnabledFactor),
          ];

        case AccentColor.red:
          return [
            MacosColor.fromRGBO(186, 53, 46, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(166, 48, 41, 1.0 * isEnabledFactor),
          ];

        case AccentColor.orange:
          return [
            MacosColor.fromRGBO(212, 133, 33, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(189, 118, 30, 1.0 * isEnabledFactor),
          ];

        case AccentColor.yellow:
          return [
            MacosColor.fromRGBO(229, 203, 35, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(204, 179, 21, 1.0 * isEnabledFactor),
          ];

        case AccentColor.green:
          return [
            MacosColor.fromRGBO(58, 138, 46, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(52, 123, 39, 1.0 * isEnabledFactor),
          ];

        case AccentColor.graphite:
          return [
            MacosColor.fromRGBO(64, 64, 64, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(57, 57, 57, 1.0 * isEnabledFactor),
          ];

        default:
          throw UnimplementedError();
      }
    } else {
      switch (accentColor) {
        case AccentColor.blue:
          return [
            MacosColor.fromRGBO(39, 125, 255, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(1, 101, 255, 1.0 * isEnabledFactor),
          ];

        case AccentColor.purple:
          return [
            MacosColor.fromRGBO(148, 73, 143, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(128, 39, 121, 1.0 * isEnabledFactor),
          ];

        case AccentColor.pink:
          return [
            MacosColor.fromRGBO(212, 71, 125, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(203, 36, 101, 1.0 * isEnabledFactor),
          ];

        case AccentColor.red:
          return [
            MacosColor.fromRGBO(198, 64, 57, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(188, 29, 21, 1.0 * isEnabledFactor),
          ];

        case AccentColor.orange:
          return [
            MacosColor.fromRGBO(237, 154, 51, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(234, 136, 13, 1.0 * isEnabledFactor),
          ];

        case AccentColor.yellow:
          return [
            MacosColor.fromRGBO(242, 211, 61, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(240, 203, 25, 1.0 * isEnabledFactor),
          ];

        case AccentColor.green:
          return [
            MacosColor.fromRGBO(77, 161, 63, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(45, 143, 28, 1.0 * isEnabledFactor),
          ];

        case AccentColor.graphite:
          return [
            MacosColor.fromRGBO(86, 86, 86, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(55, 55, 55, 1.0 * isEnabledFactor),
          ];

        default:
          throw UnimplementedError();
      }
    }
  }

  /// Gets the shadow to use for the [BoxDecoration] based on the provided
  /// [accentColor], [isEnabled], and [isDarkModeEnabled] properties.
  static List<BoxShadow> _getShadow({
    required AccentColor accentColor,
    required bool isEnabled,
    required bool isDarkModeEnabled,
    required bool isSecondary,
  }) {
    final isEnabledFactor = isEnabled ? 1.0 : 0.5;

    if (isSecondary) {
      return isDarkModeEnabled
          ? [
              BoxShadow(
                color: MacosColor.fromRGBO(0, 0, 0, 0.4 * isEnabledFactor),
                blurRadius: 0.5,
                offset: Offset.zero,
                spreadRadius: 0.0,
                blurStyle: BlurStyle.outer,
              ),
            ]
          : [
              BoxShadow(
                color: MacosColor.fromRGBO(0, 0, 0, 0.4 * isEnabledFactor),
                blurRadius: 0.5,
                offset: isEnabled ? const Offset(0.0, 0.3) : Offset.zero,
                spreadRadius: 0.0,
                blurStyle: isEnabled ? BlurStyle.normal : BlurStyle.outer,
              ),
            ];
    }

    if (isDarkModeEnabled) {
      return [
        BoxShadow(
          color: MacosColor.fromRGBO(0, 0, 0, 0.4 * isEnabledFactor),
          blurRadius: 0.5,
          offset: isEnabled ? const Offset(0.0, 0.3) : Offset.zero,
          spreadRadius: 0.0,
          blurStyle: isEnabled ? BlurStyle.normal : BlurStyle.outer,
        ),
      ];
    } else {
      switch (accentColor) {
        case AccentColor.blue:
          return [
            BoxShadow(
              color: MacosColor.fromRGBO(0, 103, 255, 0.21 * isEnabledFactor),
              blurRadius: 0.5,
              offset: isEnabled ? const Offset(0.0, 0.3) : Offset.zero,
              spreadRadius: 0.0,
              blurStyle: isEnabled ? BlurStyle.normal : BlurStyle.outer,
            ),
          ];

        case AccentColor.purple:
          return [
            BoxShadow(
              color: MacosColor.fromRGBO(139, 29, 125, 0.21 * isEnabledFactor),
              blurRadius: 0.5,
              offset: isEnabled ? const Offset(0.0, 0.3) : Offset.zero,
              spreadRadius: 0.0,
              blurStyle: isEnabled ? BlurStyle.normal : BlurStyle.outer,
            ),
          ];

        case AccentColor.pink:
          return [
            BoxShadow(
              color: MacosColor.fromRGBO(222, 0, 101, 0.21 * isEnabledFactor),
              blurRadius: 0.5,
              offset: isEnabled ? const Offset(0.0, 0.3) : Offset.zero,
              spreadRadius: 0.0,
              blurStyle: isEnabled ? BlurStyle.normal : BlurStyle.outer,
            ),
          ];

        case AccentColor.red:
          return [
            BoxShadow(
              color: MacosColor.fromRGBO(188, 29, 21, 0.35 * isEnabledFactor),
              blurRadius: 0.5,
              offset: isEnabled ? const Offset(0.0, 0.3) : Offset.zero,
              spreadRadius: 0.0,
              blurStyle: isEnabled ? BlurStyle.normal : BlurStyle.outer,
            ),
          ];

        case AccentColor.orange:
          return [
            BoxShadow(
              color: MacosColor.fromRGBO(234, 136, 13, 0.35 * isEnabledFactor),
              blurRadius: 0.5,
              offset: isEnabled ? const Offset(0.0, 0.3) : Offset.zero,
              spreadRadius: 0.0,
              blurStyle: isEnabled ? BlurStyle.normal : BlurStyle.outer,
            ),
          ];

        case AccentColor.yellow:
          return [
            BoxShadow(
              color: MacosColor.fromRGBO(240, 203, 25, 0.35 * isEnabledFactor),
              blurRadius: 0.5,
              offset: isEnabled ? const Offset(0.0, 0.3) : Offset.zero,
              spreadRadius: 0.0,
              blurStyle: isEnabled ? BlurStyle.normal : BlurStyle.outer,
            ),
          ];

        case AccentColor.green:
          return [
            BoxShadow(
              color: MacosColor.fromRGBO(45, 143, 28, 0.35 * isEnabledFactor),
              blurRadius: 0.5,
              offset: isEnabled ? const Offset(0.0, 0.3) : Offset.zero,
              spreadRadius: 0.0,
              blurStyle: isEnabled ? BlurStyle.normal : BlurStyle.outer,
            ),
          ];

        case AccentColor.graphite:
          return [
            BoxShadow(
              color: MacosColor.fromRGBO(55, 55, 55, 0.35 * isEnabledFactor),
              blurRadius: 0.5,
              offset: isEnabled ? const Offset(0.0, 0.3) : Offset.zero,
              spreadRadius: 0.0,
              blurStyle: isEnabled ? BlurStyle.normal : BlurStyle.outer,
            ),
          ];

        default:
          throw UnimplementedError();
      }
    }
  }

  /// Builds a [BoxDecoration] for a [MacosPushButton].
  static BoxDecoration buildBoxDecoration({
    required AccentColor accentColor,
    required bool isEnabled,
    required bool isDarkModeEnabled,
    required bool isSecondary,
  }) {
    final isEnabledFactor = isEnabled ? 1.0 : 0.5;

    return BoxDecoration(
      border: isDarkModeEnabled
          ? GradientBoxBorder(
              gradient: LinearGradient(
                colors: [
                  MacosColor.fromRGBO(255, 255, 255, 0.43 * isEnabledFactor),
                  const MacosColor.fromRGBO(255, 255, 255, 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.2],
              ),
              width: 0.7,
            )
          : null,
      gradient: LinearGradient(
        colors: getGradientColors(
          accentColor: accentColor,
          isEnabled: isEnabled,
          isDarkModeEnabled: isDarkModeEnabled,
          isSecondary: isSecondary,
        ),
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      boxShadow: _getShadow(
        accentColor: accentColor,
        isEnabled: isEnabled,
        isDarkModeEnabled: isDarkModeEnabled,
        isSecondary: isSecondary,
      ),
    );
  }
}
