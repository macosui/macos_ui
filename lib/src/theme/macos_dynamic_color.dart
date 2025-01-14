import 'package:flutter/cupertino.dart';

import 'macos_theme.dart';

/// Extension methods on [CupertinoDynamicColor].
extension MacosDynamicColor on CupertinoDynamicColor {
  /// Resolves the given [Color] by calling [resolveFrom].
  ///
  /// If the given color is already a concrete [Color], it will be returned as is.
  /// If the given color is null, returns null.
  /// If the given color is a [CupertinoDynamicColor], but the given [BuildContext]
  /// lacks the dependencies required to the color resolution, the default trait
  /// value will be used ([Brightness.light] platform brightness, normal contrast,
  /// [CupertinoUserInterfaceLevelData.base] elevation level).
  ///
  /// See also:
  ///
  ///  * [resolve], which is similar to this function, but returns a
  ///    non-nullable value, and does not allow a null `resolvable` color.
  static Color? maybeResolve(Color? resolvable, BuildContext context) {
    if (resolvable == null) return null;
    return resolve(resolvable, context);
  }

  /// Resolves the given [Color] by calling [resolveFrom].
  ///
  /// If the given color is already a concrete [Color], it will be returned as is.
  /// If the given color is a [CupertinoDynamicColor], but the given [BuildContext]
  /// lacks the dependencies required to the color resolution, the default trait
  /// value will be used ([Brightness.light] platform brightness, normal contrast,
  /// [CupertinoUserInterfaceLevelData.base] elevation level).
  ///
  /// See also:
  ///
  ///  * [maybeResolve], which is similar to this function, but will allow a
  ///    null `resolvable` color.
  static Color resolve(Color resolvable, BuildContext context) {
    return (resolvable is CupertinoDynamicColor)
        ? resolvable._resolveFrom(context)
        : resolvable;
  }

  bool get isPlatformBrightnessDependent {
    return color != darkColor ||
        elevatedColor != darkElevatedColor ||
        highContrastColor != darkHighContrastColor ||
        highContrastElevatedColor != darkHighContrastElevatedColor;
  }

  bool get isHighContrastDependent {
    return color != highContrastColor ||
        darkColor != darkHighContrastColor ||
        elevatedColor != highContrastElevatedColor ||
        darkElevatedColor != darkHighContrastElevatedColor;
  }

  bool get isInterfaceElevationDependent {
    return color != elevatedColor ||
        darkColor != darkElevatedColor ||
        highContrastColor != highContrastElevatedColor ||
        darkHighContrastColor != darkHighContrastElevatedColor;
  }

  CupertinoDynamicColor _resolveFrom(BuildContext context) {
    Brightness brightness = Brightness.light;
    if (isPlatformBrightnessDependent) {
      brightness = MacosTheme.maybeBrightnessOf(context) ?? Brightness.light;
    }
    bool isHighContrastEnabled = false;
    if (isHighContrastDependent) {
      isHighContrastEnabled =
          MediaQuery.maybeOf(context)?.highContrast ?? false;
    }

    final CupertinoUserInterfaceLevelData level = isInterfaceElevationDependent
        ? CupertinoUserInterfaceLevel.maybeOf(context) ??
            CupertinoUserInterfaceLevelData.base
        : CupertinoUserInterfaceLevelData.base;

    final Color resolved;
    switch (brightness) {
      case Brightness.light:
        switch (level) {
          case CupertinoUserInterfaceLevelData.base:
            resolved = isHighContrastEnabled ? highContrastColor : color;
            break;
          case CupertinoUserInterfaceLevelData.elevated:
            resolved = isHighContrastEnabled
                ? highContrastElevatedColor
                : elevatedColor;
            break;
        }
        break;
      case Brightness.dark:
        switch (level) {
          case CupertinoUserInterfaceLevelData.base:
            resolved =
                isHighContrastEnabled ? darkHighContrastColor : darkColor;
            break;
          case CupertinoUserInterfaceLevelData.elevated:
            resolved = isHighContrastEnabled
                ? darkHighContrastElevatedColor
                : darkElevatedColor;
            break;
        }
    }

    Element? debugContext;
    assert(() {
      debugContext = context as Element;
      return true;
    }());

    return ResolvedMacosDynamicColor(
      resolved,
      color,
      darkColor,
      highContrastColor,
      darkHighContrastColor,
      elevatedColor,
      darkElevatedColor,
      highContrastElevatedColor,
      darkHighContrastElevatedColor,
      debugContext,
    );
  }
}

class ResolvedMacosDynamicColor extends CupertinoDynamicColor {
  const ResolvedMacosDynamicColor(
    this.resolvedColor,
    Color color,
    Color darkColor,
    Color highContrastColor,
    Color darkHighContrastColor,
    Color elevatedColor,
    Color darkElevatedColor,
    Color highContrastElevatedColor,
    Color darkHighContrastElevatedColor,
    Element? debugResolveContext,
  ) : super(
          color: color,
          darkColor: darkColor,
          highContrastColor: highContrastColor,
          darkHighContrastColor: darkHighContrastColor,
          elevatedColor: elevatedColor,
          darkElevatedColor: darkElevatedColor,
          highContrastElevatedColor: highContrastElevatedColor,
          darkHighContrastElevatedColor: darkHighContrastElevatedColor,
        );

  final Color resolvedColor;

  @override
  double get r => resolvedColor.r;

  @override
  double get g => resolvedColor.g;

  @override
  double get b => resolvedColor.b;
}
