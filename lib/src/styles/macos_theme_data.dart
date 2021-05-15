import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// Defines the configuration of the overall visual [MacosTheme] for a
/// [MacosApp] or a widget subtree within the app.
///
/// The [MacosApp] theme property can be used to configure the appearance
/// of the entire app. Widget subtree's within an app can override the app's
/// theme by including a [MacosTheme] widget at the top of the subtree.
///
/// Widgets whose appearance should align with the overall theme can obtain the
/// current theme's configuration with [MacosTheme.of].
///
/// {@tool snippet}
/// In this example, the [Container] widget uses [MacosTheme.of] to retrieve the
/// primary color from the theme's [primaryColor] to draw a blue square.
/// The [Builder] widget separates the parent theme's [BuildContext] from the
/// child's [BuildContext].
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/material/theme_data.png)
///
/// ```dart
/// MacosTheme(
///   data: MacosThemeData(
///     primaryColor: Colors.yellow,
///   ),
///   child: Builder(
///     builder: (BuildContext context) {
///       return Container(
///         width: 100,
///         height: 100,
///         color: MacosTheme.of(context).primaryColor,
///       );
///     },
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [MacosTheme], in which this [MacosThemeData] is inserted.
@immutable
class MacosThemeData with Diagnosticable {
  /// Creates a [MacosThemeData] that's used to configure [MacosTheme].
  ///
  /// The [typography] [TextStyle] colors are black if the color scheme's
  /// brightness is [Brightness.light], and white for [Brightness.dark].
  ///
  /// Unspecified parameters default to a reasonable macOS default style.
  ///
  /// See also:
  ///
  ///   * [MacosThemeData.light], which creates a light blue theme.
  ///   * [MacosThemeData.dark], which creates a dark blue theme.
  factory MacosThemeData({
    Brightness? brightness,
    Color? primaryColor,
    Curve? animationCurve,
    Duration? mediumAnimationDuration,
    Typography? typography,
    PushButtonThemeData? pushButtonTheme,
    Color? dividerColor,
    HelpButtonThemeData? helpButtonTheme,
    TooltipThemeData? tooltipTheme,
  }) {
    m.ThemeData();
    final Brightness _brightness = brightness ?? Brightness.light;
    final bool isDark = _brightness == Brightness.dark;
    primaryColor ??= isDark
        ? CupertinoColors.activeBlue.darkColor
        : CupertinoColors.activeBlue.color;
    animationCurve = Curves.easeInOut;
    mediumAnimationDuration = Duration(milliseconds: 300);
    typography ??= Typography(brightness: _brightness);
    pushButtonTheme ??= PushButtonThemeData(
      color: primaryColor,
      disabledColor: isDark
          ? Color.fromRGBO(255, 255, 255, 0.1)
          : Color.fromRGBO(244, 245, 245, 1.0),
    );
    dividerColor ??= isDark ? const Color(0x1FFFFFFF) : const Color(0x1F000000);
    helpButtonTheme ??= HelpButtonThemeData(
      color: isDark
          ? Color.fromRGBO(255, 255, 255, 0.1)
          : Color.fromRGBO(244, 245, 245, 1.0),
      disabledColor: isDark
          ? Color.fromRGBO(255, 255, 255, 0.1)
          : Color.fromRGBO(244, 245, 245, 1.0),
    );
    tooltipTheme ??= TooltipThemeData.standard(
      brightness: _brightness,
      textStyle: typography.callout,
    );

    return MacosThemeData.raw(
      brightness: _brightness,
      primaryColor: primaryColor,
      animationCurve: animationCurve,
      mediumAnimationDuration: mediumAnimationDuration,
      typography: typography,
      pushButtonTheme: pushButtonTheme,
      dividerColor: dividerColor,
      helpButtonTheme: helpButtonTheme,
      tooltipTheme: tooltipTheme,
    );
  }

  /// Create a [MacosThemeData] given a set of exact values. All the values must
  /// be specified. They all must also be non-null.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [MacosThemeData] constructor.
  const MacosThemeData.raw({
    required this.brightness,
    required this.primaryColor,
    required this.animationCurve,
    required this.mediumAnimationDuration,
    required this.typography,
    required this.pushButtonTheme,
    required this.dividerColor,
    required this.helpButtonTheme,
    required this.tooltipTheme,
  });

  /// A default light blue theme.
  factory MacosThemeData.light() =>
      MacosThemeData(brightness: Brightness.light);

  /// A default dark blue theme.
  factory MacosThemeData.dark() => MacosThemeData(brightness: Brightness.dark);

  /// The default color theme. Same as [ThemeData.light].
  ///
  /// This is used by [MacosTheme.of] when no theme has been specified.
  factory MacosThemeData.fallback() => MacosThemeData.light();

  /// The overall theme brightness.
  ///
  /// The default [TextStyle] color for the [textTheme] is black if the
  /// theme is constructed with [Brightness.light] and white if the
  /// theme is constructed with [Brightness.dark].
  final Brightness brightness;

  /// A color used on primary interactive elements of the theme.
  ///
  /// Defaults to [CupertinoColors.activeBlue].
  final Color primaryColor;

  /// Defaults to [Curves.easeInOut].
  /// See also:
  ///   * [Curves], a collection of common animation curves
  final Curve? animationCurve;

  /// Defaults to `Duration(milliseconds: 300)`
  final Duration mediumAnimationDuration;

  /// The default text styling for this theme.
  final Typography typography;

  /// The default style for [PushButton]s below the overall [MacosTheme].
  final PushButtonThemeData pushButtonTheme;

  /// The color to use when painting the line used for the [TitleBar] bottom,
  /// [Sidebar] and [ResizableBar] sides
  final Color dividerColor;

  /// The default style for [HelpButton]s below the overall [MacosTheme].
  final HelpButtonThemeData helpButtonTheme;

  /// The default style for [Tooltip]s below the overall [MacosTheme]
  final TooltipThemeData tooltipTheme;

  /// Linearly interpolate between two themes.
  static MacosThemeData lerp(MacosThemeData a, MacosThemeData b, double t) {
    return MacosThemeData.raw(
      animationCurve: t >= 0.5 ? b.animationCurve : a.animationCurve,
      brightness: t >= 0.5 ? b.brightness : a.brightness,
      dividerColor: Color.lerp(a.dividerColor, b.dividerColor, t)!,
      mediumAnimationDuration:
          t >= 0.5 ? b.mediumAnimationDuration : a.mediumAnimationDuration,
      primaryColor: Color.lerp(a.primaryColor, b.primaryColor, t)!,
      typography: Typography.lerp(a.typography, b.typography, t),
      helpButtonTheme:
          HelpButtonThemeData.lerp(a.helpButtonTheme, b.helpButtonTheme, t),
      pushButtonTheme:
          PushButtonThemeData.lerp(a.pushButtonTheme, b.pushButtonTheme, t),
      tooltipTheme: TooltipThemeData.lerp(a.tooltipTheme, b.tooltipTheme, t),
    );
  }

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  MacosThemeData copyWith({
    Brightness? brightness,
    Color? primaryColor,
    Curve? animationCurve,
    Duration? mediumAnimationDuration,
    Typography? typography,
    PushButtonThemeData? pushButtonTheme,
    Color? dividerColor,
    HelpButtonThemeData? helpButtonTheme,
    TooltipThemeData? tooltipTheme,
  }) {
    return MacosThemeData.raw(
      brightness: brightness ?? this.brightness,
      primaryColor: primaryColor ?? this.primaryColor,
      animationCurve: animationCurve ?? this.animationCurve,
      mediumAnimationDuration:
          mediumAnimationDuration ?? this.mediumAnimationDuration,
      dividerColor: dividerColor ?? this.dividerColor,
      typography: typography ?? this.typography,
      pushButtonTheme: this.pushButtonTheme.copyWith(pushButtonTheme),
      helpButtonTheme: this.helpButtonTheme.copyWith(helpButtonTheme),
      tooltipTheme: this.tooltipTheme.copyWith(tooltipTheme),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('brightness', brightness));
    properties.add(
      DiagnosticsProperty<Curve>('animationCurve', animationCurve),
    );
    properties.add(DiagnosticsProperty<Duration>(
      'mediumAnimationDuration',
      mediumAnimationDuration,
    ));
    properties.add(ColorProperty('primaryColor', primaryColor));
    properties.add(ColorProperty('dividerColor', dividerColor));
    properties.add(DiagnosticsProperty<Typography>('typography', typography));
    properties.add(DiagnosticsProperty<PushButtonThemeData>(
      'pushButtonTheme',
      pushButtonTheme,
    ));
    properties.add(DiagnosticsProperty<HelpButtonThemeData>(
      'helpButtonTheme',
      helpButtonTheme,
    ));
    properties.add(
      DiagnosticsProperty<TooltipThemeData>('tooltipTheme', tooltipTheme),
    );
  }
}

extension BrightnessX on Brightness {
  /// Check if the brightness is dark or not.
  bool get isDark => this == Brightness.dark;
}
