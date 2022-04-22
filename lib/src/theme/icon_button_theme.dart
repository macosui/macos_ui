import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// Overrides the default style of its [MacosIconButton] descendants.
///
/// See also:
///
///  * [MacosIconButtonThemeData], which is used to configure this theme.
class MacosIconButtonTheme extends InheritedTheme {
  /// Builds a [MacosIconButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const MacosIconButtonTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final MacosIconButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [MacosIconButtonTheme] widget, then
  /// [MacosThemeData.macosIconButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = MacosIconButtonTheme.of(context);
  /// ```
  static MacosIconButtonThemeData of(BuildContext context) {
    final MacosIconButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<MacosIconButtonTheme>();
    return buttonTheme?.data ?? MacosTheme.of(context).macosIconButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MacosIconButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MacosIconButtonTheme oldWidget) =>
      data != oldWidget.data;
}

/// A style that overrides the default appearance of
/// [MacosIconButton]s when it's used with [MacosIconButtonTheme] or with the
/// overall [MacosTheme]'s [MacosThemeData.macosIconButtonTheme].
///
/// See also:
///
///  * [MacosIconButtonTheme], the theme which is configured with this class.
///  * [MacosThemeData.macosIconButtonTheme], which can be used to override
///  the default style for [MacosIconButton]s below the overall [MacosTheme].
class MacosIconButtonThemeData with Diagnosticable {
  /// Builds a [MacosIconButtonThemeData].
  const MacosIconButtonThemeData({
    this.backgroundColor,
    this.hoverColor,
    this.disabledColor,
    this.shape,
    this.borderRadius,
    this.boxConstraints,
    this.padding,
  });

  /// The default background color for [MacosIconButton].
  final Color? backgroundColor;

  /// The color of the button when the mouse hovers over it.
  final Color? hoverColor;

  /// The default disabled color for [MacosIconButton].
  final Color? disabledColor;

  /// The default shape for [MacosIconButton].
  final BoxShape? shape;

  /// The default border radius for [MacosIconButton].
  final BorderRadius? borderRadius;

  /// The default box constraints for [MacosIconButton].
  final BoxConstraints? boxConstraints;

  /// The default padding for [MacosIconButton].
  final EdgeInsetsGeometry? padding;

  /// Copies this [MacosIconButtonThemeData] into another.
  MacosIconButtonThemeData copyWith({
    Color? backgroundColor,
    Color? disabledColor,
    Color? hoverColor,
    BoxShape? shape,
    BorderRadius? borderRadius,
    BoxConstraints? boxConstraints,
    EdgeInsetsGeometry? padding,
  }) {
    return MacosIconButtonThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      disabledColor: disabledColor ?? this.disabledColor,
      hoverColor: hoverColor ?? this.hoverColor,
      shape: shape ?? this.shape,
      borderRadius: borderRadius ?? this.borderRadius,
      boxConstraints: boxConstraints ?? this.boxConstraints,
      padding: padding ?? this.padding,
    );
  }

  /// Linearly interpolate between two [MacosIconButtonThemeData].
  ///
  /// All the properties must be non-null.
  static MacosIconButtonThemeData lerp(
    MacosIconButtonThemeData a,
    MacosIconButtonThemeData b,
    double t,
  ) {
    return MacosIconButtonThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
      hoverColor: Color.lerp(a.hoverColor, b.hoverColor, t),
      shape: b.shape,
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      boxConstraints:
          BoxConstraints.lerp(a.boxConstraints, b.boxConstraints, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MacosIconButtonThemeData &&
          runtimeType == other.runtimeType &&
          backgroundColor?.value == other.backgroundColor?.value &&
          disabledColor?.value == other.disabledColor?.value &&
          hoverColor?.value == other.hoverColor?.value &&
          shape == other.shape &&
          borderRadius == other.borderRadius &&
          boxConstraints == other.boxConstraints &&
          padding == other.padding;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      disabledColor.hashCode ^
      hoverColor.hashCode ^
      shape.hashCode ^
      borderRadius.hashCode ^
      boxConstraints.hashCode ^
      padding.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('disabledColor', disabledColor));
    properties.add(ColorProperty('hoverColor', hoverColor));
    properties.add(EnumProperty<BoxShape?>('shape', shape));
    properties
        .add(DiagnosticsProperty<BorderRadius?>('borderRadius', borderRadius));
    properties.add(
      DiagnosticsProperty<BoxConstraints?>('boxConstraints', boxConstraints),
    );
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding),
    );
  }

  MacosIconButtonThemeData merge(MacosIconButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      disabledColor: other.disabledColor,
      hoverColor: other.hoverColor,
      shape: other.shape,
      borderRadius: other.borderRadius,
      boxConstraints: other.boxConstraints,
      padding: other.padding,
    );
  }
}
