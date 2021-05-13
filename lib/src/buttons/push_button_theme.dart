import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// Overrides the default style of its [PushButton] descendants.
///
/// See also:
///
///  * [PushButtonThemeData], which is used to configure this theme.
class PushButtonTheme extends InheritedTheme {
  /// Create a [PushButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const PushButtonTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final PushButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [PushButtonTheme] widget, then
  /// [MacosThemeData.pushButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// PushButtonTheme theme = PushButtonTheme.of(context);
  /// ```
  static PushButtonThemeData of(BuildContext context) {
    final PushButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<PushButtonTheme>();
    return buttonTheme?.data ?? MacosTheme.of(context).pushButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return PushButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(PushButtonTheme oldWidget) => data != oldWidget.data;
}

/// A style that overrides the default appearance of
/// [PushButton]s when it's used with [PushButtonTheme] or with the
/// overall [MacosTheme]'s [MacosThemeData.pushButtonTheme].
///
/// See also:
///
///  * [PushButtonTheme], the theme which is configured with this class.
///  * [MacosThemeData.pushButtonTheme], which can be used to override the default
///    style for [PushButton]s below the overall [MacosTheme].
class PushButtonThemeData with Diagnosticable {
  /// Creates a [PushButtonThemeData].
  ///
  /// The [style] may be null.
  const PushButtonThemeData({
    required this.color,
    required this.disabledColor,
  });

  /// The default background color for [PushButton]
  final Color color;

  /// The default disabled color for [PushButton]
  final Color disabledColor;

  PushButtonThemeData copyWith(PushButtonThemeData? themeData) {
    if (themeData == null) {
      return this;
    }
    return PushButtonThemeData(
      color: themeData.color,
      disabledColor: themeData.disabledColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('disabledColor', disabledColor));
  }
}
