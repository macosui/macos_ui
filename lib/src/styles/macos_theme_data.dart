import 'package:flutter/foundation.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/macos_ui.dart';

/// Styling specifications for a [MacosTheme].
///
/// All constructor parameters can be null, in which case a
/// [CupertinoColors.activeBlue] based default macOS theme styling is used.
///
/// See also:
///
///  * [MacosTheme], in which this [MacosThemeData] is inserted.
class MacosThemeData with Diagnosticable {
  /// Creates a [MacosTheme] styling specification.
  ///
  /// Unspecified parameters default to a reasonable macOS default style.
  factory MacosThemeData({
    Brightness? brightness,
    Color? primaryColor,
    Color? accentColor,
    Curve? animationCurve,
    Duration? mediumAnimationDuration,
    Typography? typography,
    PushButtonThemeData? pushButtonTheme,
    HelpButtonThemeData? helpButtonTheme,
  }) {
    final Brightness _brightness = brightness ?? Brightness.light;
    final bool isDark = _brightness == Brightness.dark;
    primaryColor ??= isDark
        ? CupertinoColors.activeBlue.darkColor
        : CupertinoColors.activeBlue.color;
    accentColor ??= isDark
        ? CupertinoColors.activeBlue.darkColor
        : CupertinoColors.activeBlue.color;
    animationCurve = Curves.easeInOut;
    mediumAnimationDuration = Duration(milliseconds: 300);
    typography = Typography.defaultTypography(brightness: _brightness)
        .copyWith(typography);
    pushButtonTheme ??= PushButtonThemeData(
      color: primaryColor,
      disabledColor: isDark
          ? Color.fromRGBO(255, 255, 255, 0.1)
          : Color.fromRGBO(244, 245, 245, 1.0),
    );
    helpButtonTheme ??= HelpButtonThemeData(
      color: isDark
          ? Color.fromRGBO(255, 255, 255, 0.1)
          : Color.fromRGBO(244, 245, 245, 1.0),
      disabledColor: isDark
          ? Color.fromRGBO(255, 255, 255, 0.1)
          : Color.fromRGBO(244, 245, 245, 1.0),
    );

    return MacosThemeData._raw(
      brightness: _brightness,
      primaryColor: primaryColor,
      accentColor: accentColor,
      animationCurve: animationCurve,
      mediumAnimationDuration: mediumAnimationDuration,
      typography: typography,
      pushButtonTheme: pushButtonTheme,
      helpButtonTheme: helpButtonTheme,
    );
  }

  const MacosThemeData._raw({
    required this.brightness,
    required this.primaryColor,
    required this.accentColor,
    required this.animationCurve,
    required this.mediumAnimationDuration,
    required this.typography,
    required this.pushButtonTheme,
    required this.helpButtonTheme,
  });

  // TODO: documentation
  factory MacosThemeData.light() =>
      MacosThemeData(brightness: Brightness.light);

  // TODO: documentation
  factory MacosThemeData.dark() => MacosThemeData(brightness: Brightness.dark);

  // TODO: documentation
  factory MacosThemeData.fallback() => MacosThemeData.light();

  /// The brightness override for macOS descendants.
  final Brightness? brightness;

  /// A color used on primary interactive elements of the theme.
  ///
  /// Defaults to [CupertinoColors.activeBlue].
  final Color? primaryColor;

  /// A color used on accent interactive elements of the theme.
  ///
  /// Defaults to [CupertinoColors.activeBlue].
  final Color? accentColor;

  // TODO: documentation
  final Curve? animationCurve;

  // TODO: documentation
  final Duration? mediumAnimationDuration;

  /// The default text styling for this theme.
  final Typography? typography;

  /// The default style for [PushButton]s below the overall [MacosTheme].
  final PushButtonThemeData pushButtonTheme;

  /// The default style for [HelpButton]s below the overall [MacosTheme].
  final HelpButtonThemeData helpButtonTheme;

  MacosThemeData resolveFrom(BuildContext context) {
    /*Color? convertColor(Color? color) =>
        CupertinoDynamicColor.maybeResolve(color, context);*/

    return MacosThemeData._raw(
      brightness: brightness,
      primaryColor: primaryColor,
      accentColor: accentColor,
      animationCurve: animationCurve,
      mediumAnimationDuration: mediumAnimationDuration,
      typography: typography,
      pushButtonTheme: pushButtonTheme,
      helpButtonTheme: helpButtonTheme,
    );
  }
}

extension BrightnessX on Brightness {
  bool get isDark => this == Brightness.dark;
}
