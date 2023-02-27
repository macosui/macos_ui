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
    this.backgroundColor,
    this.iconColor,
    this.disabledColor,
  });

  /// The default background color for [HelpButton]
  final MacosColor? backgroundColor;

  /// The default icon color for [HelpButton]
  final MacosColor? iconColor;

  /// The default disabled color for [HelpButton]
  final MacosColor? disabledColor;

  /// Copies one [HelpButtonThemeData] to another.
  HelpButtonThemeData copyWith({
    MacosColor? backgroundColor,
    MacosColor? iconColor,
    MacosColor? disabledColor,
  }) {
    return HelpButtonThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconColor: iconColor ?? this.iconColor,
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
      backgroundColor: MacosColor.lerp(a.backgroundColor, b.backgroundColor, t),
      iconColor: MacosColor.lerp(a.iconColor, b.iconColor, t),
      disabledColor: MacosColor.lerp(a.disabledColor, b.disabledColor, t),
    );
  }

  /// Merges this [HelpButtonThemeData] with another.
  HelpButtonThemeData merge(HelpButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      iconColor: other.iconColor,
      disabledColor: other.disabledColor,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HelpButtonThemeData &&
            runtimeType == other.runtimeType &&
            backgroundColor?.value == other.backgroundColor?.value &&
            iconColor?.value == other.iconColor?.value &&
            disabledColor?.value == other.disabledColor?.value;
  }

  @override
  int get hashCode => backgroundColor.hashCode ^ iconColor.hashCode ^ disabledColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('iconColor', iconColor));
    properties.add(ColorProperty('disabledColor', disabledColor));
  }
}
