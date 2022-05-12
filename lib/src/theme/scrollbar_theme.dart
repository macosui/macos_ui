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
  bool updateShouldNotify(MacosScrollbarTheme oldWidget) => data != oldWidget.data;
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
    this.hoveringThickness,
    this.showTrackOnHover,
    this.isAlwaysShown,
    this.radius,
    this.thumbColor,
    this.hoveringThumbColor,
    this.draggingThumbColor,
    this.trackColor,
    this.hoveringTrackColor,
    this.trackBorderColor,
    this.hoveringTrackBorderColor,
    this.crossAxisMargin,
    this.mainAxisMargin,
    this.minThumbLength,
    this.interactive,
  });

  /// Overrides the default value of [MacosScrollbar.thickness] in all
  /// descendant [MacosScrollbar] widgets.
  final double? thickness;

  /// Overrides the default value of [MacosScrollbar.hoverThickness] in all
  /// descendant [MacosScrollbar] widgets when hovering is active.
  final double? hoveringThickness;

  /// Overrides the default value of [MacosScrollbar.trackVisibility] in all
  /// descendant [MacosScrollbar] widgets.
  final bool? showTrackOnHover;

  /// Overrides the default value of [MacosScrollbar.isAlwaysShown] in all
  /// descendant [MacosScrollbar] widgets.
  final bool? isAlwaysShown;

  /// Overrides the default value of [MacosScrollbar.interactive] in all
  /// descendant [MacosScrollbar] widgets.
  final bool? interactive;

  /// Overrides the default value of [MacosScrollbar.radius] in all
  /// descendant widgets.
  final Radius? radius;

  /// Overrides the default [Color] of the [MacosScrollbar] thumb in all
  /// descendant [MacosScrollbar] widgets.
  final Color? thumbColor;

  /// Overrides the default [Color] of the [MacosScrollbar] thumb in all
  /// descendant [MacosScrollbar] widgets when hovering is active.
  final Color? hoveringThumbColor;

  /// Overrides the default [Color] of the [MacosScrollbar] thumb in all
  /// descendant [MacosScrollbar] widgets when dragging is active.
  final Color? draggingThumbColor;

  /// Overrides the default [Color] of the [MacosScrollbar] track when
  /// [showTrackOnHover] is true in all descendant [MacosScrollbar] widgets.
  final Color? trackColor;

  /// Overrides the default [Color] of the [MacosScrollbar] track when
  /// [showTrackOnHover] is true in all descendant [MacosScrollbar] widgets
  /// when hovering is active.
  final Color? hoveringTrackColor;

  /// Overrides the default [Color] of the [MacosScrollbar] track border when
  /// [showTrackOnHover] is true in all descendant [MacosScrollbar] widgets.
  final Color? trackBorderColor;

  /// Overrides the default [Color] of the [MacosScrollbar] track border when
  /// [showTrackOnHover] is true in all descendant [MacosScrollbar] widgets
  /// when hovering is active.
  final Color? hoveringTrackBorderColor;

  /// Overrides the default value of the [ScrollbarPainter.crossAxisMargin]
  /// property in all descendant [MacosScrollbar] widgets.
  ///
  /// See also:
  ///
  ///  * [ScrollbarPainter.crossAxisMargin], which sets the distance from the
  ///    scrollbar's side to the nearest edge in logical pixels.
  final double? crossAxisMargin;

  /// Overrides the default value of the [ScrollbarPainter.mainAxisMargin]
  /// property in all descendant [MacosScrollbar] widgets.
  ///
  /// See also:
  ///
  ///  * [ScrollbarPainter.mainAxisMargin], which sets the distance from the
  ///    scrollbar's start and end to the edge of the viewport in logical pixels.
  final double? mainAxisMargin;

  /// Overrides the default value of the [ScrollbarPainter.minLength]
  /// property in all descendant [MacosScrollbar] widgets.
  ///
  /// See also:
  ///
  ///  * [ScrollbarPainter.minLength], which sets the preferred smallest size
  ///    the scrollbar can shrink to when the total scrollable extent is large,
  ///    the current visible viewport is small, and the viewport is not
  ///    overscrolled.
  final double? minThumbLength;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  MacosScrollbarThemeData copyWith({
    double? thickness,
    double? hoveringThickness,
    bool? showTrackOnHover,
    bool? isAlwaysShown,
    bool? interactive,
    Radius? radius,
    Color? thumbColor,
    Color? hoveringThumbColor,
    Color? draggingThumbColor,
    Color? trackColor,
    Color? hoveringTrackColor,
    Color? trackBorderColor,
    Color? hoveringTrackBorderColor,
    double? crossAxisMargin,
    double? mainAxisMargin,
    double? minThumbLength,
  }) {
    return MacosScrollbarThemeData(
      thickness: thickness ?? this.thickness,
      hoveringThickness: hoveringThickness ?? this.hoveringThickness,
      showTrackOnHover: showTrackOnHover ?? this.showTrackOnHover,
      isAlwaysShown: isAlwaysShown ?? this.isAlwaysShown,
      interactive: interactive ?? this.interactive,
      radius: radius ?? this.radius,
      thumbColor: thumbColor ?? this.thumbColor,
      hoveringThumbColor: hoveringThumbColor ?? this.hoveringThumbColor,
      draggingThumbColor: draggingThumbColor ?? this.draggingThumbColor,
      trackColor: trackColor ?? this.trackColor,
      hoveringTrackColor: hoveringTrackColor ?? this.hoveringTrackColor,
      trackBorderColor: trackBorderColor ?? this.trackBorderColor,
      hoveringTrackBorderColor:
          hoveringTrackBorderColor ?? this.hoveringTrackBorderColor,
      crossAxisMargin: crossAxisMargin ?? this.crossAxisMargin,
      mainAxisMargin: mainAxisMargin ?? this.mainAxisMargin,
      minThumbLength: minThumbLength ?? this.minThumbLength,
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
      hoveringThickness:
          lerpDouble(a?.hoveringThickness, b?.hoveringThickness, t),
      showTrackOnHover: t < 0.5 ? a?.showTrackOnHover : b?.showTrackOnHover,
      isAlwaysShown: t < 0.5 ? a?.isAlwaysShown : b?.isAlwaysShown,
      interactive: t < 0.5 ? a?.interactive : b?.interactive,
      radius: Radius.lerp(a?.radius, b?.radius, t),
      thumbColor: Color.lerp(a?.thumbColor, b?.thumbColor, t),
      hoveringThumbColor:
          Color.lerp(a?.hoveringThumbColor, b?.hoveringThumbColor, t),
      draggingThumbColor:
          Color.lerp(a?.draggingThumbColor, b?.draggingThumbColor, t),
      trackColor: Color.lerp(a?.trackColor, b?.trackColor, t),
      hoveringTrackColor:
          Color.lerp(a?.hoveringThumbColor, b?.hoveringThumbColor, t),
      trackBorderColor: Color.lerp(a?.trackBorderColor, b?.trackBorderColor, t),
      hoveringTrackBorderColor: Color.lerp(
        a?.hoveringTrackBorderColor,
        b?.hoveringTrackBorderColor,
        t,
      ),
      crossAxisMargin: lerpDouble(a?.crossAxisMargin, b?.crossAxisMargin, t),
      mainAxisMargin: lerpDouble(a?.mainAxisMargin, b?.mainAxisMargin, t),
      minThumbLength: lerpDouble(a?.minThumbLength, b?.minThumbLength, t),
    );
  }

  @override
  int get hashCode {
    return hashValues(
      thickness,
      hoveringThickness,
      showTrackOnHover,
      isAlwaysShown,
      interactive,
      radius,
      thumbColor,
      hoveringThumbColor,
      draggingThumbColor,
      trackColor,
      hoveringTrackColor,
      trackBorderColor,
      hoveringTrackBorderColor,
      crossAxisMargin,
      mainAxisMargin,
      minThumbLength,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is MacosScrollbarThemeData &&
        other.thickness == thickness &&
        other.hoveringThickness == hoveringThickness &&
        other.showTrackOnHover == showTrackOnHover &&
        other.isAlwaysShown == isAlwaysShown &&
        other.interactive == interactive &&
        other.radius == radius &&
        other.thumbColor == thumbColor &&
        other.hoveringThumbColor == hoveringThumbColor &&
        other.draggingThumbColor == draggingThumbColor &&
        other.trackColor == trackColor &&
        other.hoveringTrackColor == hoveringTrackColor &&
        other.trackBorderColor == trackBorderColor &&
        other.hoveringTrackBorderColor == hoveringTrackBorderColor &&
        other.crossAxisMargin == crossAxisMargin &&
        other.mainAxisMargin == mainAxisMargin &&
        other.minThumbLength == minThumbLength;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<double?>('thickness', thickness, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<double?>(
      'hoveringThickness',
      hoveringThickness,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty<bool>(
      'showTrackOnHover',
      showTrackOnHover,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty<bool>(
      'isAlwaysShown',
      isAlwaysShown,
      defaultValue: null,
    ));
    properties.add(
      DiagnosticsProperty<bool>('interactive', interactive, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty<Radius>('radius', radius, defaultValue: null),
    );
    properties.add(ColorProperty('thumbColor', thumbColor, defaultValue: null));
    properties.add(ColorProperty(
      'hoveringThumbColor',
      hoveringThumbColor,
      defaultValue: null,
    ));
    properties.add(ColorProperty(
      'draggingThumbColor',
      draggingThumbColor,
      defaultValue: null,
    ));
    properties.add(ColorProperty('trackColor', trackColor, defaultValue: null));
    properties.add(
      ColorProperty(
        'hoveringTrackColor',
        hoveringTrackColor,
        defaultValue: null,
      ),
    );
    properties.add(
      ColorProperty('trackBorderColor', trackBorderColor, defaultValue: null),
    );
    properties.add(ColorProperty(
      'hoveringTrackBorderColor',
      hoveringTrackBorderColor,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty<double>(
      'crossAxisMargin',
      crossAxisMargin,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty<double>(
      'mainAxisMargin',
      mainAxisMargin,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty<double>(
      'minThumbLength',
      minThumbLength,
      defaultValue: null,
    ));
  }

  MacosScrollbarThemeData merge(MacosScrollbarThemeData? other) {
    if (other == null) return this;
    return copyWith(
      thickness: other.thickness,
      hoveringThickness: other.hoveringThickness,
      showTrackOnHover: other.showTrackOnHover,
      isAlwaysShown: other.isAlwaysShown,
      interactive: other.interactive,
      radius: other.radius,
      thumbColor: other.thumbColor,
      hoveringThumbColor: other.hoveringThumbColor,
      draggingThumbColor: other.draggingThumbColor,
      trackColor: other.trackColor,
      hoveringTrackColor: other.hoveringTrackColor,
      trackBorderColor: other.trackBorderColor,
      hoveringTrackBorderColor: other.hoveringTrackBorderColor,
      crossAxisMargin: other.crossAxisMargin,
      mainAxisMargin: other.mainAxisMargin,
      minThumbLength: other.minThumbLength,
    );
  }
}
