import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// Applies a scrollbar theme to descendant [MacosScrollbar] widgets.
///
/// Descendant widgets obtain the current theme's [MacosScrollbarThemeData]
/// using [MacosScrollbarTheme.of]. When a widget uses
/// [MacosScrollbarTheme.of], it is automatically rebuilt if the theme later
/// changes.
///
/// A scrollbar theme can be specified as part of the overall Material theme
/// using [ThemeData.scrollbarTheme].
///
/// See also:
///
///  * [MacosScrollbarThemeData], which describes the configuration of a
///    scrollbar theme.
class MacosScrollbarTheme extends InheritedWidget {
  /// Constructs a scrollbar theme that configures all descendant
  /// [MacosScrollbar] widgets.
  const MacosScrollbarTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [MacosScrollbar] widgets.
  final MacosScrollbarThemeData data;

  /// Returns the configuration [data] from the closest [MacosScrollbarTheme]
  /// ancestor. If there is no ancestor, it returns [ThemeData.scrollbarTheme].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ScrollbarThemeData theme = ScrollbarTheme.of(context);
  /// ```
  static MacosScrollbarThemeData of(BuildContext context) {
    final MacosScrollbarTheme? scrollbarTheme =
        context.dependOnInheritedWidgetOfExactType<MacosScrollbarTheme>();
    return scrollbarTheme?.data ?? MacosTheme.of(context).scrollbarTheme;
  }

  @override
  bool updateShouldNotify(MacosScrollbarTheme oldWidget) =>
      data != oldWidget.data;
}

/// Defines default property values for descendant [MacosScrollbar] widgets.
///
/// Descendant widgets obtain the current [MacosScrollbarThemeData] object with
/// `ScrollbarTheme.of(context)`. Instances of [MacosScrollbarThemeData] can
/// be customized with [MacosScrollbarThemeData.copyWith].
///
/// Typically the [MacosScrollbarThemeData] of a [MacosScrollbarTheme] is
/// specified as part of the overall [MacosTheme] with
/// [MacosThemeData.scrollbarTheme].
///
/// All [MacosScrollbarThemeData] properties are `null` by default. When null,
/// the [MacosScrollbar] computes its own default values.
///
/// See also:
///
///  * [MacosThemeData], which describes the overall theme information for the
///    application.
class MacosScrollbarThemeData with Diagnosticable {
  /// Creates a theme that can be used for [MacosThemeData.scrollbarTheme].
  const MacosScrollbarThemeData({
    this.thickness,
    this.thicknessWhileHovering,
    this.thumbVisibility,
    this.radius,
    this.thumbColor,
  });

  /// Overrides the default value of [MacosScrollbar.thickness] in all
  /// descendant [MacosScrollbar] widgets.
  final double? thickness;

  /// Overrides the default value of [MacosScrollbar.hoverThickness] in all
  /// descendant [MacosScrollbar] widgets when hovering is active.
  final double? thicknessWhileHovering;

  /// Overrides the default value of [MacosScrollbar.thumbVisibility] in all
  /// descendant [MacosScrollbar] widgets.
  final bool? thumbVisibility;

  /// Overrides the default value of [MacosScrollbar.radius] in all
  /// descendant widgets.
  final Radius? radius;

  /// Overrides the default [Color] of the [MacosScrollbar] thumb in all
  /// descendant [MacosScrollbar] widgets.
  final Color? thumbColor;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  MacosScrollbarThemeData copyWith({
    double? thickness,
    double? thicknessWhileHovering,
    bool? showTrackOnHover,
    bool? thumbVisibility,
    Radius? radius,
    Color? thumbColor,
  }) {
    return MacosScrollbarThemeData(
      thickness: thickness ?? this.thickness,
      thicknessWhileHovering:
          thicknessWhileHovering ?? this.thicknessWhileHovering,
      thumbVisibility: thumbVisibility ?? this.thumbVisibility,
      radius: radius ?? this.radius,
      thumbColor: thumbColor ?? this.thumbColor,
    );
  }

  /// Linearly interpolate between two Scrollbar themes.
  ///
  /// The argument `t` must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  // ignore: code-metrics
  static MacosScrollbarThemeData lerp(
    MacosScrollbarThemeData? a,
    MacosScrollbarThemeData? b,
    double t,
  ) {
    return MacosScrollbarThemeData(
      thickness: lerpDouble(a?.thickness, b?.thickness, t),
      thicknessWhileHovering: lerpDouble(
        a?.thicknessWhileHovering,
        b?.thicknessWhileHovering,
        t,
      ),
      thumbVisibility: t < 0.5 ? a?.thumbVisibility : b?.thumbVisibility,
      radius: Radius.lerp(a?.radius, b?.radius, t),
      thumbColor: Color.lerp(a?.thumbColor, b?.thumbColor, t),
    );
  }

  /// Merges this [MacosScrollbarThemeData] with another.
  MacosScrollbarThemeData merge(MacosScrollbarThemeData? other) {
    if (other == null) return this;
    return copyWith(
      thickness: other.thickness,
      thumbVisibility: other.thumbVisibility,
      radius: other.radius,
      thumbColor: other.thumbColor,
    );
  }

  @override
  int get hashCode {
    return Object.hash(
      thickness,
      thicknessWhileHovering,
      thumbVisibility,
      radius,
      thumbColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is MacosScrollbarThemeData &&
        other.thickness == thickness &&
        other.thicknessWhileHovering == thicknessWhileHovering &&
        other.thumbVisibility == thumbVisibility &&
        other.radius == radius &&
        other.thumbColor == thumbColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<double?>('thickness', thickness, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<double?>(
      'thicknessWhileHovering',
      thicknessWhileHovering,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty<bool>(
      'thumbVisibility',
      thumbVisibility,
      defaultValue: null,
    ));
    properties.add(
      DiagnosticsProperty<Radius>('radius', radius, defaultValue: null),
    );
    properties.add(ColorProperty('thumbColor', thumbColor, defaultValue: null));
  }
}
