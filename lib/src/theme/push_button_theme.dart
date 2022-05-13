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
    super.key,
    required this.data,
    required super.child,
  });

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
  const PushButtonThemeData({
    this.color,
    this.disabledColor,
    this.secondaryColor,
  });

  /// The default background color for [PushButton]
  final Color? color;

  /// The default disabled color for [PushButton]
  final Color? disabledColor;

  /// The default secondary color (e.g. Cancel/Go back buttons) for [PushButton]
  final Color? secondaryColor;

  PushButtonThemeData copyWith({
    Color? color,
    Color? disabledColor,
    Color? secondaryColor,
  }) {
    return PushButtonThemeData(
      color: color ?? this.color,
      disabledColor: disabledColor ?? this.disabledColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }

  /// Linearly interpolate between two [PushButtonThemeData].
  ///
  /// All the properties must be non-null.
  static PushButtonThemeData lerp(
    PushButtonThemeData a,
    PushButtonThemeData b,
    double t,
  ) {
    return PushButtonThemeData(
      color: Color.lerp(a.color, b.color, t),
      disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
      secondaryColor: Color.lerp(a.secondaryColor, b.secondaryColor, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PushButtonThemeData &&
          runtimeType == other.runtimeType &&
          color?.value == other.color?.value &&
          disabledColor?.value == other.disabledColor?.value &&
          secondaryColor?.value == other.secondaryColor?.value;

  @override
  int get hashCode => color.hashCode ^ disabledColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('disabledColor', disabledColor));
    properties.add(ColorProperty('secondaryColor', secondaryColor));
  }

  PushButtonThemeData merge(PushButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      color: other.color,
      disabledColor: other.disabledColor,
      secondaryColor: other.secondaryColor,
    );
  }
}
