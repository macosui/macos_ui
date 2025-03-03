import 'package:flutter/rendering.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A checkbox is a type of button that lets the user choose between
/// two opposite states, actions, or values. A selected checkbox is
/// considered on when it contains a checkmark and off when it's empty.
/// A checkbox is almost always followed by a title unless it appears in
/// a checklist.
class MacosCheckbox extends StatelessWidget {
  /// Creates a checkbox.
  ///
  /// [size] must be non-negative
  const MacosCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 14.0,
    this.activeColor,
    this.disabledColor = CupertinoColors.quaternaryLabel,
    this.offBorderColor = CupertinoColors.tertiaryLabel,
    this.semanticLabel,
  }) : assert(size >= 0);

  /// Whether the checkbox is checked or not. If null, it'll be considered
  /// mixed.
  final bool? value;

  /// Called whenever the state of the checkbox changes. If null, the checkbox
  /// will be considered disabled
  final ValueChanged<bool>? onChanged;

  /// The size of the checkbox. It must be non-negative.
  final double size;

  /// The background color when the checkbox is on or mixed. If null,
  /// [MacosThemeData.accentColor] is used
  final Color? activeColor;

  /// The background color when the checkbox is disabled. [CupertinoColors.quaternaryLabel]
  /// is used by default
  final Color disabledColor;

  /// The color of the border when the checkbox is off. [CupertinoColors.tertiaryLabel]
  /// is used by default
  final Color offBorderColor;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  /// Whether the checkbox is mixed or not.
  bool get isMixed => value == null;

  /// Whether the checkbox is disabled or not.
  bool get isDisabled => onChanged == null;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty(
      'state',
      isMixed
          ? 'mixed'
          : value!
              ? 'checked'
              : 'unchecked',
    ));
    properties.add(FlagProperty(
      'disabled',
      value: isDisabled,
      ifFalse: 'enabled',
    ));
    properties.add(DoubleProperty('size', size));
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('disabledColor', disabledColor));
    properties.add(ColorProperty('offBorderColor', offBorderColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final MacosThemeData theme = MacosTheme.of(context);
    bool isLight = !theme.brightness.isDark;
    return StreamBuilder(
        stream: AccentColorListener.instance.onChanged,
        builder: (context, _) {
          return StreamBuilder<bool>(
              stream: WindowMainStateListener.instance.onChanged,
              builder: (context, _) {
                final accentColor =
                    MacosTheme.of(context).accentColor ?? AccentColor.blue;
                final isMainWindow =
                    MacosTheme.of(context).isMainWindow ?? true;

                return GestureDetector(
                  onTap: () {
                    if (value == null || value == false) {
                      onChanged?.call(true);
                    } else {
                      onChanged?.call(false);
                    }
                  },
                  child: Semantics(
                    // value == true because [value] can be null
                    checked: value == true,
                    label: semanticLabel,
                    child: Container(
                      height: size,
                      width: size,
                      alignment: Alignment.center,
                      child: SizedBox.expand(
                        child: _DecoratedContainer(
                          accentColor: accentColor,
                          isDisabled: isDisabled,
                          isLight: isLight,
                          isMainWindow: isMainWindow,
                          value: value,
                          isMixed: isMixed,
                          theme: theme,
                          size: size,
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}

/// A widget that builds a decorated checkbox.
class _DecoratedContainer extends StatelessWidget {
  const _DecoratedContainer({
    required this.accentColor,
    required this.isDisabled,
    required this.isLight,
    required this.isMainWindow,
    required this.value,
    required this.isMixed,
    required this.theme,
    required this.size,
  });

  final AccentColor accentColor;
  final bool isDisabled;
  final bool isLight;
  final bool isMainWindow;
  final bool? value;
  final bool isMixed;
  final MacosThemeData theme;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _BoxDecorationBuilder.buildBoxDecoration(
        accentColor: accentColor,
        isEnabled: !isDisabled,
        isDarkModeEnabled: !isLight,
        isMainWindow: isMainWindow,
        value: value,
      ),
      child: _CheckboxStack(
        value: value,
        isDisabled: isDisabled,
        isMixed: isMixed,
        theme: theme,
        isMainWindow: isMainWindow,
        size: size,
      ),
    );
  }
}

/// A stack containing the checkbox’s inner drop shadow and checkmark icon.
class _CheckboxStack extends StatelessWidget {
  const _CheckboxStack({
    required this.value,
    required this.isDisabled,
    required this.isMixed,
    required this.theme,
    required this.isMainWindow,
    required this.size,
  });

  final bool? value;
  final bool isDisabled;
  final bool isMixed;
  final MacosThemeData theme;
  final bool isMainWindow;
  final double size;

  @override
  Widget build(BuildContext context) {
    final icon = value == false
        ? null
        : isMixed
            ? CupertinoIcons.minus
            : CupertinoIcons.checkmark;

    return Stack(
      children: [
        _InnerDropShadow(
          value: value,
          isEnabled: !isDisabled,
        ),
        Center(
          child: Icon(
            icon,
            color: _getCheckmarkColor(),
            size: (size - 3).clamp(0, size),
          ),
        ),
      ],
    );
  }

  _getCheckmarkColor() {
    if (isDisabled) {
      return const MacosColor.fromRGBO(172, 172, 172, 1.0);
    }

    if (theme.brightness.isDark) {
      return theme.accentColor == AccentColor.graphite && isMainWindow
          ? CupertinoColors.black
          : CupertinoColors.white;
    }

    if (theme.isMainWindow == false) {
      return CupertinoColors.black;
    }

    return CupertinoColors.white;
  }
}

/// A widget that paints an inner drop shadow for the checkbox in light mode.
class _InnerDropShadow extends StatelessWidget {
  /// The value of the checkbox.
  final bool? value;

  /// Whether the checkbox is enabled.
  final bool isEnabled;

  /// Creates a widget that paints an inner drop shadow for a checkbox.
  const _InnerDropShadow({
    required this.value,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = MacosTheme.of(context);

    if (theme.brightness.isDark) {
      return const SizedBox();
    }

    if (value == true && theme.isMainWindow == true && isEnabled) {
      return const SizedBox();
    }

    final color = isEnabled
        ? CupertinoColors.white
        : const MacosColor.fromRGBO(255, 255, 255, 0.8);

    return SizedBox.expand(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: MacosColor.fromRGBO(0, 0, 0, 0.15),
          borderRadius: BorderRadius.all(Radius.circular(3.5)),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(3.5)),
            boxShadow: [
              BoxShadow(
                color: color,
                offset: const Offset(0.0, 0.5),
                blurRadius: 1.0,
              ),
            ],
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
    required bool isMainWindow,
    required bool? value,
  }) {
    final isEnabledFactor = isEnabled || !isDarkModeEnabled ? 1.0 : 0.5;

    final showDisabledCheckbox = !isMainWindow || !isEnabled || value == false;

    if (showDisabledCheckbox) {
      return isDarkModeEnabled
          ? [
              MacosColor.fromRGBO(74, 74, 74, 1.0 * isEnabledFactor),
              MacosColor.fromRGBO(101, 101, 101, 1.0 * isEnabledFactor),
            ]
          : const [
              MacosColors.transparent,
              MacosColors.transparent,
            ];
    }

    if (isDarkModeEnabled) {
      switch (accentColor) {
        case AccentColor.blue:
          return [
            MacosColor.fromRGBO(23, 105, 229, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(20, 94, 203, 1.0 * isEnabledFactor),
          ];

        case AccentColor.purple:
          return [
            MacosColor.fromRGBO(203, 46, 202, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(182, 40, 182, 1.0 * isEnabledFactor),
          ];

        case AccentColor.pink:
          return [
            MacosColor.fromRGBO(229, 75, 145, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(205, 61, 129, 1.0 * isEnabledFactor),
          ];

        case AccentColor.red:
          return [
            MacosColor.fromRGBO(237, 64, 68, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(213, 56, 61, 1.0 * isEnabledFactor),
          ];

        case AccentColor.orange:
          return [
            MacosColor.fromRGBO(244, 114, 0, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(219, 102, 0, 1.0 * isEnabledFactor),
          ];

        case AccentColor.yellow:
          return [
            MacosColor.fromRGBO(233, 176, 4, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(209, 157, 3, 1.0 * isEnabledFactor),
          ];

        case AccentColor.green:
          return [
            MacosColor.fromRGBO(75, 177, 45, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(67, 159, 40, 1.0 * isEnabledFactor),
          ];

        case AccentColor.graphite:
          return [
            MacosColor.fromRGBO(148, 148, 148, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(148, 148, 148, 1.0 * isEnabledFactor),
          ];
      }
    } else {
      switch (accentColor) {
        case AccentColor.blue:
          return [
            MacosColor.fromRGBO(39, 145, 255, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(1, 123, 255, 1.0 * isEnabledFactor),
          ];

        case AccentColor.purple:
          return [
            MacosColor.fromRGBO(173, 56, 177, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(159, 19, 163, 1.0 * isEnabledFactor),
          ];

        case AccentColor.pink:
          return [
            MacosColor.fromRGBO(237, 102, 165, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(234, 76, 149, 1.0 * isEnabledFactor),
          ];

        case AccentColor.red:
          return [
            MacosColor.fromRGBO(225, 60, 66, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(220, 26, 31, 1.0 * isEnabledFactor),
          ];

        case AccentColor.orange:
          return [
            MacosColor.fromRGBO(247, 130, 31, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(245, 108, 0, 1.0 * isEnabledFactor),
          ];

        case AccentColor.yellow:
          return [
            MacosColor.fromRGBO(242, 189, 32, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(240, 178, 0, 1.0 * isEnabledFactor),
          ];

        case AccentColor.green:
          return [
            MacosColor.fromRGBO(90, 185, 59, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(60, 172, 25, 1.0 * isEnabledFactor),
          ];

        case AccentColor.graphite:
          return [
            MacosColor.fromRGBO(86, 86, 86, 1.0 * isEnabledFactor),
            MacosColor.fromRGBO(55, 55, 55, 1.0 * isEnabledFactor),
          ];
      }
    }
  }

  /// Builds a [BoxDecoration] for a [MacosPushButton].
  static BoxDecoration buildBoxDecoration({
    required AccentColor accentColor,
    required bool isEnabled,
    required bool isDarkModeEnabled,
    required bool isMainWindow,
    required bool? value,
  }) {
    final isEnabledFactor = isEnabled ? 1.0 : 0.5;

    final List<BoxShadow> shadows = isDarkModeEnabled
        ? const [
            BoxShadow(
              color: MacosColor.fromRGBO(0, 0, 0, 0.8),
              blurRadius: 0.7,
              spreadRadius: -0.5,
              offset: Offset(0.0, 0.5),
              blurStyle: BlurStyle.outer,
            )
          ]
        : const [];

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
          : Border.all(
              color: value == false && isEnabled
                  ? const MacosColor.fromRGBO(0, 0, 0, 0.15)
                  : const MacosColor.fromRGBO(0, 0, 0, 0.12),
              width: 0.5,
            ),
      gradient: LinearGradient(
        colors: getGradientColors(
          accentColor: accentColor,
          isEnabled: isEnabled,
          isDarkModeEnabled: isDarkModeEnabled,
          isMainWindow: isMainWindow,
          value: value,
        ),
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      boxShadow: shadows,
      borderRadius: const BorderRadius.all(Radius.circular(3.5)),
    );
  }
}
