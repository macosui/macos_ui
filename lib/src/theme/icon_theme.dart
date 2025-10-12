import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// Controls the default color, opacity, and size of icons in a widget subtree.
///
/// The icon theme is honored by [MacosIcon] widgets.
class MacosIconTheme extends InheritedTheme {
  /// Creates an icon theme that controls the color, opacity, and size of
  /// descendant widgets.
  ///
  /// Both [data] and [child] arguments must not be null.
  const MacosIconTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Creates an icon theme that controls the color, opacity, and size of
  /// descendant widgets, and merges in the current icon theme, if any.
  ///
  /// The [data] and [child] arguments must not be null.
  static Widget merge({
    Key? key,
    required MacosIconThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return MacosIconTheme(
          key: key,
          data: _getInheritedIconThemeData(context).merge(data),
          child: child,
        );
      },
    );
  }

  /// The color, opacity, and size to use for icons in this subtree.
  final MacosIconThemeData data;

  /// The data from the closest instance of this class that encloses the given
  /// context, if any.
  ///
  /// If there is no ambient icon theme, defaults to [MacosIconThemeData.fallback].
  /// The returned [MacosIconThemeData] is concrete (all values are non-null; see
  /// [MacosIconThemeData.isConcrete]). Any properties on the ambient icon theme that
  /// are null get defaulted to the values specified on
  /// [MacosIconThemeData.fallback].
  ///
  /// The [MacosTheme] widget from the `macos_ui` library introduces a [MacosIconTheme]
  /// widget set to the [MacosThemeData.iconTheme], so in a macos_ui-style
  /// application, this will typically default to the icon theme from the
  /// ambient [MacosTheme].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// MacosIconThemeData theme = MacosIconTheme.of(context);
  /// ```
  static MacosIconThemeData of(BuildContext context) {
    final MacosIconThemeData iconThemeData =
        _getInheritedIconThemeData(context).resolve(context);
    return iconThemeData.isConcrete
        ? iconThemeData
        : iconThemeData.copyWith(
            size:
                iconThemeData.size ?? const MacosIconThemeData.fallback().size,
            color: iconThemeData.color ??
                const MacosIconThemeData.fallback().color,
            opacity: iconThemeData.opacity ??
                const MacosIconThemeData.fallback().opacity,
          );
  }

  static MacosIconThemeData _getInheritedIconThemeData(BuildContext context) {
    final MacosIconTheme? iconTheme =
        context.dependOnInheritedWidgetOfExactType<MacosIconTheme>();
    return iconTheme?.data ?? MacosTheme.of(context).iconTheme;
  }

  @override
  bool updateShouldNotify(MacosIconTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MacosIconTheme(data: data, child: child);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}

/// Defines the color, opacity, and size of icons.
///
/// Used by [MacosIconTheme] to control the color, opacity, and size of icons in a
/// widget subtree.
///
/// To obtain the current icon theme, use [MacosIconTheme.of]. To convert an icon
/// theme to a version with all the fields filled in, use
/// [MacosIconThemeData.fallback].
class MacosIconThemeData with Diagnosticable {
  /// Creates an icon theme data.
  ///
  /// The opacity applies to both explicit and default icon colors. The value
  /// is clamped between 0.0 and 1.0.
  const MacosIconThemeData({
    this.color,
    double? opacity,
    this.size,
  }) : _opacity = opacity;

  /// Creates an icon theme with some reasonable default values.
  ///
  /// The [color] is blue, the [opacity] is 1.0, and the [size] is 24.0.
  const MacosIconThemeData.fallback()
      : color = const Color.fromARGB(255, 0, 122, 255),
        _opacity = 1.0,
        size = 24.0;

  /// Creates a copy of this icon theme but with the given fields replaced with
  /// the new values.
  MacosIconThemeData copyWith({
    Color? color,
    double? opacity,
    double? size,
  }) {
    return MacosIconThemeData(
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      size: size ?? this.size,
    );
  }

  /// Returns a new icon theme that matches this icon theme but with some values
  /// replaced by the non-null parameters of the given icon theme. If the given
  /// icon theme is null, simply returns this icon theme.
  MacosIconThemeData merge(MacosIconThemeData? other) {
    if (other == null) return this;
    return copyWith(
      color: other.color,
      opacity: other.opacity,
      size: other.size,
    );
  }

  /// Called by [MacosIconTheme.of] to convert this instance to an [MacosIconThemeData]
  /// that fits the given [BuildContext].
  ///
  /// This method gives the ambient [MacosIconThemeData] a chance to update itself,
  /// after it's been retrieved by [MacosIconTheme.of], and before being returned as
  /// the final result. For instance, [CupertinoIconThemeData] overrides this method
  /// to resolve [color], in case [color] is a [CupertinoDynamicColor] and needs
  /// to be resolved against the given [BuildContext] before it can be used as a
  /// regular [Color].
  ///
  /// The default implementation returns this [MacosIconThemeData] as-is.
  ///
  /// See also:
  ///
  ///  * [CupertinoIconThemeData.resolve] an implementation that resolves
  ///    the color of [CupertinoIconThemeData] before returning.
  MacosIconThemeData resolve(BuildContext context) => this;

  /// Whether all the properties of this object are non-null.
  bool get isConcrete => color != null && opacity != null && size != null;

  /// The default color for icons.
  final Color? color;

  /// An opacity to apply to both explicit and default icon colors.
  double? get opacity => _opacity?.clamp(0.0, 1.0);
  final double? _opacity;

  /// The default size for icons.
  final double? size;

  /// Linearly interpolate between two icon theme data objects.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static MacosIconThemeData lerp(
    MacosIconThemeData? a,
    MacosIconThemeData? b,
    double t,
  ) {
    return MacosIconThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      opacity: ui.lerpDouble(a?.opacity, b?.opacity, t),
      size: ui.lerpDouble(a?.size, b?.size, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is MacosIconThemeData &&
        other.color == color &&
        other.opacity == opacity &&
        other.size == size;
  }

  @override
  int get hashCode => Object.hash(color, opacity, size);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('MacosColor', color, defaultValue: null));
    properties.add(DoubleProperty('opacity', opacity, defaultValue: null));
    properties.add(DoubleProperty('size', size, defaultValue: null));
  }
}
