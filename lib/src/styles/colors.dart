import 'package:flutter/cupertino.dart';

import 'macos_theme.dart';

extension DynamicColorX on CupertinoDynamicColor {
  static Color? maybeMacosResolve(Color? resolvable, BuildContext context) {
    if (resolvable == null) return null;
    return macosResolve(resolvable, context);
  }

  static Color macosResolve(Color resolvable, BuildContext context) {
    return (resolvable is CupertinoDynamicColor)
        ? resolvable.macosResolveFrom(context)
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

  CupertinoDynamicColor macosResolveFrom(BuildContext context) {
    Brightness brightness = Brightness.light;
    if (this.isPlatformBrightnessDependent) {
      brightness = MacosTheme.maybeBrightnessOf(context) ?? Brightness.light;
    }
    bool isHighContrastEnabled = false;
    if (this.isHighContrastDependent) {
      isHighContrastEnabled =
          MediaQuery.maybeOf(context)?.highContrast ?? false;
    }

    final CupertinoUserInterfaceLevelData level =
        this.isInterfaceElevationDependent
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

    Element? _debugContext;
    assert(() {
      _debugContext = context as Element;
      return true;
    }());

    return ResolvedCupertinoDynamicColor(
      resolved,
      color,
      darkColor,
      highContrastColor,
      darkHighContrastColor,
      elevatedColor,
      darkElevatedColor,
      highContrastElevatedColor,
      darkHighContrastElevatedColor,
      _debugContext,
    );
  }
}

class ResolvedCupertinoDynamicColor extends CupertinoDynamicColor {
  final Color resolvedColor;

  const ResolvedCupertinoDynamicColor(
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

  @override
  int get value => resolvedColor.value;
}
