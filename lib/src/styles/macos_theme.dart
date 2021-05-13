import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

import 'macos_theme_data.dart';

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
    return (inheritedTheme?.theme.data ?? MacosThemeData())
        .resolveFrom(context);
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
    return inheritedTheme?.theme.data.resolveFrom(context);
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

extension themeContext on BuildContext {
  MacosThemeData get macosTheme => MacosTheme.of(this);
}
