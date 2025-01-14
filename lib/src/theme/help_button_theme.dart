import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

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
    super.key,
    required this.data,
    required super.child,
  });

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
    this.color,
    this.disabledColor,
  });

  /// The default background color for [HelpButton]
  final Color? color;

  /// The default disabled color for [HelpButton]
  final Color? disabledColor;

  /// Copies one [HelpButtonThemeData] to another.
  HelpButtonThemeData copyWith({
    Color? color,
    Color? disabledColor,
  }) {
    return HelpButtonThemeData(
      color: color ?? this.color,
      disabledColor: disabledColor ?? this.disabledColor,
    );
  }

  /// Linearly interpolate between two tooltip themes.
  ///
  /// All the properties must be non-null.
  static HelpButtonThemeData lerp(
    HelpButtonThemeData a,
    HelpButtonThemeData b,
    double t,
  ) {
    return HelpButtonThemeData(
      color: Color.lerp(a.color, b.color, t),
      disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HelpButtonThemeData &&
            runtimeType == other.runtimeType &&
            color == other.color &&
            disabledColor == other.disabledColor;
  }

  @override
  int get hashCode => color.hashCode ^ disabledColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('disabledColor', disabledColor));
  }

  /// Merges this [HelpButtonThemeData] with another.
  HelpButtonThemeData merge(HelpButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      color: other.color,
      disabledColor: other.disabledColor,
    );
  }
}
