import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';

/// Overrides the default style of its [HelpButton] descendants.
///
/// See also:
///
///  * [HelpButtonThemeData], which is used to configure this theme.
class HelpButtonTheme extends InheritedTheme {
  /// Create a [HelpButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const HelpButtonTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final HelpButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [HelpButtonTheme] widget, then
  /// [MacosThemeData.helpButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// HelpButtonTheme theme = HelpButtonTheme.of(context);
  /// ```
  static HelpButtonThemeData of(BuildContext context) {
    final HelpButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<HelpButtonTheme>();
    return buttonTheme?.data ?? MacosTheme.of(context).helpButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HelpButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HelpButtonTheme oldWidget) => data != oldWidget.data;
}

/// A style that overrides the default appearance of
/// [HelpButton]s when it's used with [HelpButtonTheme] or with the
/// overall [MacosTheme]'s [MacosThemeData.helpButtonTheme].
///
/// See also:
///
///  * [HelpButtonTheme], the theme which is configured with this class.
///  * [MacosThemeData.helpButtonTheme], which can be used to override the default
///    style for [HelpButton]s below the overall [MacosTheme].
class HelpButtonThemeData with Diagnosticable {
  /// Creates a [HelpButtonThemeData].
  ///
  /// The [style] may be null.
  const HelpButtonThemeData({
    required this.color,
    required this.disabledColor,
  });

  /// The default background color for [HelpButton]
  final Color color;

  /// The default disabled color for [HelpButton]
  final Color disabledColor;

  HelpButtonThemeData copyWith(HelpButtonThemeData? themeData) {
    if (themeData == null) {
      return this;
    }
    return HelpButtonThemeData(
      color: themeData.color,
      disabledColor: themeData.disabledColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('color', color));
    properties.add(DiagnosticsProperty('disabledColor', disabledColor));
  }
}
