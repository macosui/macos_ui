import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// Applies a macOS-style theme to descendant macOS widgets.
///
/// Affects the color and text styles of macOS widgets whose styling
/// are not overridden when constructing the respective widgets instances.
///
/// Descendant widgets can retrieve the current [MacosThemeData] by calling
/// [MacosThemeData.of]. An [InheritedWidget] dependency is created when
/// an ancestor [MacosThemeData] is retrieved via [MacosThemeData.of].
///
/// See also:
///
///  * [MacosThemeData], specifies the theme's visual styling
///  * [MacosApp], which will automatically add a [MacosTheme] based on the
///    value of [MacosApp.theme].
class MacosTheme extends StatelessWidget {
  /// Creates a [MacosTheme] to change descendant macOS widgets' styling.
  ///
  /// The [data] and [child] parameters must not be null.
  const MacosTheme({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  /// The [MacosThemeData] styling for this theme.
  final MacosThemeData data;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// Retrieves the [MacosThemeData] from the closest ancestor [MacosTheme]
  /// widget, or a default [MacosThemeData] if no [MacosTheme] ancestor
  /// exists.
  ///
  /// Resolves all the colors defined in that [MacosThemeData] against the
  /// given [BuildContext] on a best-effort basis.
  static MacosThemeData of(BuildContext context) {
    final _InheritedMacosTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedMacosTheme>();
    return (inheritedTheme?.theme.data ?? MacosThemeData.fallback());
  }

  /// Retrieves the [MacosThemeData] from the closest ancestor [MacosTheme]
  /// widget, or a default [MacosThemeData] if no [MacosTheme] ancestor
  /// exists. The result may be null
  ///
  /// Resolves all the colors defined in that [MacosThemeData] against the
  /// given [BuildContext] on a best-effort basis.
  static MacosThemeData? maybeOf(BuildContext context) {
    final _InheritedMacosTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedMacosTheme>();
    return inheritedTheme?.theme.data;
  }

  /// Retrieves the [Brightness] to use for descendant macOS widgets, based
  /// on the value of [MacosThemeData.brightness] in the given [context].
  ///
  /// If no [MacosTheme] can be found in the given [context], or its `brightness`
  /// is null, it will fall back to [MediaQueryData.platformBrightness].
  ///
  /// Throws an exception if no valid [MacosTheme] or [MediaQuery] widgets
  /// exist in the ancestry tree.
  ///
  /// See also:
  ///
  /// * [maybeBrightnessOf], which returns null if no valid [MacosTheme] or
  ///   [MediaQuery] exists, instead of throwing.
  /// * [MacosThemeData.brightness], the property takes precedence over
  ///   [MediaQueryData.platformBrightness] for descendant Cupertino widgets.
  static Brightness brightnessOf(BuildContext context) {
    final _InheritedMacosTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedMacosTheme>();
    return inheritedTheme?.theme.data.brightness ??
        MediaQuery.of(context).platformBrightness;
  }

  /// Retrieves the [Brightness] to use for descendant macOS widgets, based
  /// on the value of [MacosThemeData.brightness] in the given [context].
  ///
  /// If no [MacosTheme] can be found in the given [context], it will fall
  /// back to [MediaQueryData.platformBrightness].
  ///
  /// Returns null if no valid [MacosTheme] or [MediaQuery] widgets exist in
  /// the ancestry tree.
  ///
  /// See also:
  ///
  /// * [MacosThemeData.brightness], the property takes precedence over
  ///   [MediaQueryData.platformBrightness] for descendant macOS widgets.
  /// * [brightnessOf], which throws if no valid [MacosTheme] or
  ///   [MediaQuery] exists, instead of returning null.
  static Brightness? maybeBrightnessOf(BuildContext context) {
    final _InheritedMacosTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedMacosTheme>();
    return inheritedTheme?.theme.data.brightness ??
        MediaQuery.maybeOf(context)?.platformBrightness;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedMacosTheme(
      theme: this,
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<MacosThemeData>('data', data, showName: false),
    );
  }
}

class _InheritedMacosTheme extends InheritedWidget {
  const _InheritedMacosTheme({
    Key? key,
    required this.theme,
    required Widget child,
  }) : super(key: key, child: child);

  final MacosTheme theme;

  @override
  bool updateShouldNotify(_InheritedMacosTheme old) =>
      theme.data != old.theme.data;
}

/// Defines the configuration of the overall visual [MacosTheme] for a
/// [MacosApp] or a widget subtree within the app.
///
/// The [MacosApp] theme property can be used to configure the appearance
/// of the entire app. A widget's subtree within an app can override the app's
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
///     primaryColor: CupertinoColors.activeBlue,
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
class MacosThemeData with Diagnosticable {
  /// Creates a [MacosThemeData] that's used to configure [MacosTheme].
  ///
  /// The [typography] [TextStyle] colors are black if the [brightness]
  /// is [Brightness.light], and white for [Brightness.dark].
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
    Color? canvasColor,
    MacosTypography? typography,
    PushButtonThemeData? pushButtonTheme,
    Color? dividerColor,
    HelpButtonThemeData? helpButtonTheme,
    TooltipThemeData? tooltipTheme,
    VisualDensity? visualDensity,
    ScrollbarThemeData? scrollbarTheme,
  }) {
    final Brightness _brightness = brightness ?? Brightness.light;
    final bool isDark = _brightness == Brightness.dark;
    primaryColor ??= isDark
        ? CupertinoColors.activeBlue.darkColor
        : CupertinoColors.activeBlue.color;
    canvasColor ??= isDark
        ? CupertinoColors.systemBackground.darkElevatedColor
        : CupertinoColors.systemBackground;
    typography ??= MacosTypography(
      color: brightness == Brightness.light
          ? CupertinoColors.black
          : CupertinoColors.white,
    );
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
    scrollbarTheme ??= const ScrollbarThemeData();

    visualDensity ??= VisualDensity.adaptivePlatformDensity;

    return MacosThemeData.raw(
      brightness: _brightness,
      primaryColor: primaryColor,
      canvasColor: canvasColor,
      typography: typography,
      pushButtonTheme: pushButtonTheme,
      dividerColor: dividerColor,
      helpButtonTheme: helpButtonTheme,
      tooltipTheme: tooltipTheme,
      visualDensity: visualDensity,
      scrollbarTheme: scrollbarTheme,
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
    required this.canvasColor,
    required this.typography,
    required this.pushButtonTheme,
    required this.dividerColor,
    required this.helpButtonTheme,
    required this.tooltipTheme,
    required this.visualDensity,
    required this.scrollbarTheme,
  });

  /// A default light theme.
  factory MacosThemeData.light() =>
      MacosThemeData(brightness: Brightness.light);

  /// A default dark theme.
  factory MacosThemeData.dark() => MacosThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

  /// The default color theme. Same as [ThemeData.light].
  ///
  /// This is used by [MacosTheme.of] when no theme has been specified.
  factory MacosThemeData.fallback() => MacosThemeData.light().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

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

  /// The default color of Scaffold backgrounds.
  final Color canvasColor;

  /// The default text styling for this theme.
  final MacosTypography typography;

  /// The default style for [PushButton]s below the overall [MacosTheme].
  final PushButtonThemeData pushButtonTheme;

  /// The color to use when painting the line used for the [TitleBar] bottom,
  /// [Sidebar] and [ResizableBar] sides
  final Color dividerColor;

  /// The default style for [HelpButton]s below the overall [MacosTheme].
  final HelpButtonThemeData helpButtonTheme;

  /// The default style for [MacosTooltip]s below the overall [MacosTheme]
  final TooltipThemeData tooltipTheme;

  /// The density value for specifying the compactness of various UI components.
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  final VisualDensity visualDensity;

  /// The default style for [MacosScrollbar]s below the overall [MacosTheme]
  final ScrollbarThemeData scrollbarTheme;

  /// Linearly interpolate between two themes.
  static MacosThemeData lerp(MacosThemeData a, MacosThemeData b, double t) {
    return MacosThemeData.raw(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      dividerColor: Color.lerp(a.dividerColor, b.dividerColor, t)!,
      primaryColor: Color.lerp(a.primaryColor, b.primaryColor, t)!,
      canvasColor: Color.lerp(a.primaryColor, b.primaryColor, t)!,
      typography: MacosTypography.lerp(a.typography, b.typography, t),
      helpButtonTheme:
          HelpButtonThemeData.lerp(a.helpButtonTheme, b.helpButtonTheme, t),
      pushButtonTheme:
          PushButtonThemeData.lerp(a.pushButtonTheme, b.pushButtonTheme, t),
      tooltipTheme: TooltipThemeData.lerp(a.tooltipTheme, b.tooltipTheme, t),
      visualDensity: VisualDensity.lerp(a.visualDensity, b.visualDensity, t),
      scrollbarTheme:
          ScrollbarThemeData.lerp(a.scrollbarTheme, b.scrollbarTheme, t),
    );
  }

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  MacosThemeData copyWith({
    Brightness? brightness,
    Color? primaryColor,
    Color? canvasColor,
    MacosTypography? typography,
    PushButtonThemeData? pushButtonTheme,
    Color? dividerColor,
    HelpButtonThemeData? helpButtonTheme,
    TooltipThemeData? tooltipTheme,
    VisualDensity? visualDensity,
    ScrollbarThemeData? scrollbarTheme,
  }) {
    return MacosThemeData.raw(
      brightness: brightness ?? this.brightness,
      primaryColor: primaryColor ?? this.primaryColor,
      canvasColor: canvasColor ?? this.canvasColor,
      dividerColor: dividerColor ?? this.dividerColor,
      typography: typography ?? this.typography,
      pushButtonTheme: this.pushButtonTheme.copyWith(pushButtonTheme),
      helpButtonTheme: this.helpButtonTheme.copyWith(helpButtonTheme),
      tooltipTheme: this.tooltipTheme.copyWith(tooltipTheme),
      visualDensity: visualDensity ?? this.visualDensity,
      scrollbarTheme: scrollbarTheme ?? this.scrollbarTheme,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('brightness', brightness));
    properties.add(ColorProperty('primaryColor', primaryColor));
    properties.add(ColorProperty('canvasColor', canvasColor));
    properties.add(ColorProperty('dividerColor', dividerColor));
    properties
        .add(DiagnosticsProperty<MacosTypography>('typography', typography));
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

  T resolve<T>(T light, T dark) {
    if (isDark) return dark;
    return light;
  }
}
