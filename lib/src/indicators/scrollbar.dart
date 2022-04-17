import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A Macos Design scrollbar.
///
/// To add a scrollbar to a [ScrollView], wrap the scroll view
/// widget in a [MacosScrollbar] widget.
///
/// {@macro flutter.widgets.Scrollbar}
///
/// The color of the Scrollbar will change when dragged. A hover animation is
/// also triggered when used on web and desktop platforms. A scrollbar track
/// can also been drawn when triggered by a hover event, which is controlled by
/// [showTrackOnHover]. The thickness of the track and scrollbar thumb will
/// become larger when hovering, unless overridden by [hoverThickness].
///
/// See also:
///
///  * [RawScrollbar], a basic scrollbar that fades in and out, extended
///    by this class to add more animations and behaviors.
///  * [ScrollbarTheme], which configures the Scrollbar's appearance.
///  * [m.Scrollbar], a Material style scrollbar.
///  * [CupertinoScrollbar], an iOS style scrollbar.
///  * [ListView], which displays a linear, scrollable list of children.
///  * [GridView], which displays a 2 dimensional, scrollable array of children.
class MacosScrollbar extends StatelessWidget {
  /// Creates a macos design scrollbar that by default will connect to the
  /// closest Scrollable descendent of [child].
  ///
  /// The [child] should be a source of [ScrollNotification] notifications,
  /// typically a [Scrollable] widget.
  ///
  /// If the [controller] is null, the default behavior is to
  /// enable scrollbar dragging using the [PrimaryScrollController].
  ///
  /// When null, [thickness] defaults to 8.0 pixels on desktop and web, and 4.0
  /// pixels when on mobile platforms. A null [radius] will result in a default
  /// of an 8.0 pixel circular radius about the corners of the scrollbar thumb,
  /// except for when executing on [TargetPlatform.android], which will render the
  /// thumb without a radius.
  const MacosScrollbar({
    Key? key,
    required this.child,
    this.controller,
    this.isAlwaysShown,
    this.showTrackOnHover,
    this.hoverThickness,
    this.thickness,
    this.radius,
    this.notificationPredicate,
    this.interactive,
  }) : super(key: key);

  /// {@macro flutter.widgets.Scrollbar.child}
  final Widget child;

  /// {@macro flutter.widgets.Scrollbar.controller}
  final ScrollController? controller;

  /// {@macro flutter.widgets.Scrollbar.isAlwaysShown}
  final bool? isAlwaysShown;

  /// Controls if the track will show on hover and remain, including during drag.
  ///
  /// If this property is null, then [ScrollbarThemeData.showTrackOnHover] of
  /// [MacosThemeData.scrollbarTheme] is used. If that is also null, the default value
  /// is false.
  final bool? showTrackOnHover;

  /// The thickness of the scrollbar when a hover state is active and
  /// [showTrackOnHover] is true.
  ///
  /// If this property is null, then [ScrollbarThemeData.thickness] of
  /// [MacosThemeData.scrollbarTheme] is used to resolve a thickness. If that is also
  /// null, the default value is 12.0 pixels.
  final double? hoverThickness;

  /// The thickness of the scrollbar in the cross axis of the scrollable.
  ///
  /// If null, the default value is platform dependent. On [TargetPlatform.android],
  /// the default thickness is 4.0 pixels. On [TargetPlatform.iOS],
  /// [CupertinoScrollbar.defaultThickness] is used. The remaining platforms have a
  /// default thickness of 8.0 pixels.
  final double? thickness;

  /// The [Radius] of the scrollbar thumb's rounded rectangle corners.
  ///
  /// If null, the default value is platform dependent. On [TargetPlatform.android],
  /// no radius is applied to the scrollbar thumb. On [TargetPlatform.iOS],
  /// [CupertinoScrollbar.defaultRadius] is used. The remaining platforms have a
  /// default [Radius.circular] of 8.0 pixels.
  final Radius? radius;

  /// {@macro flutter.widgets.Scrollbar.interactive}
  final bool? interactive;

  /// {@macro flutter.widgets.Scrollbar.notificationPredicate}
  final ScrollNotificationPredicate? notificationPredicate;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final theme = ScrollbarTheme.of(context);
    return m.ScrollbarTheme(
      data: m.ScrollbarThemeData(
        crossAxisMargin: theme.crossAxisMargin,
        mainAxisMargin: theme.mainAxisMargin,
        interactive: theme.interactive,
        isAlwaysShown: theme.isAlwaysShown,
        showTrackOnHover: theme.showTrackOnHover,
        minThumbLength: theme.minThumbLength,
        radius: theme.radius,
        thickness: m.MaterialStateProperty.resolveWith((states) {
          if (states.contains(m.MaterialState.hovered))
            return theme.hoveringThickness ?? theme.thickness;
          return theme.thickness;
        }),
        thumbColor: m.MaterialStateProperty.resolveWith((states) {
          if (states.contains(m.MaterialState.hovered))
            return theme.hoveringThumbColor ?? theme.thumbColor;
          else if (states.contains(m.MaterialState.dragged))
            return theme.draggingThumbColor ?? theme.thumbColor;
          return theme.thumbColor;
        }),
        trackBorderColor: m.MaterialStateProperty.resolveWith((states) {
          if (states.contains(m.MaterialState.hovered))
            return theme.hoveringTrackBorderColor ?? theme.trackBorderColor;
          return theme.trackBorderColor;
        }),
        trackColor: m.MaterialStateProperty.resolveWith((states) {
          if (states.contains(m.MaterialState.hovered))
            return theme.hoveringTrackColor ?? theme.trackColor;
          return theme.trackColor;
        }),
      ),
      child: m.Scrollbar(
        child: child,
        controller: controller,
        isAlwaysShown: isAlwaysShown,
        showTrackOnHover: showTrackOnHover,
        hoverThickness: hoverThickness,
        thickness: thickness,
        radius: radius,
        interactive: interactive,
        notificationPredicate: notificationPredicate,
      ),
    );
  }
}

/// Defines default property values for descendant [MacosScrollbar] widgets.
///
/// Descendant widgets obtain the current [ScrollbarThemeData] object with
/// `ScrollbarTheme.of(context)`. Instances of [ScrollbarThemeData] can be customized
/// with [ScrollbarThemeData.copyWith].
///
/// Typically the [ScrollbarThemeData] of a [ScrollbarTheme] is specified as part of the overall
/// [MacosTheme] with [MacosThemeData.scrollbarTheme].
///
/// All [ScrollbarThemeData] properties are `null` by default. When null, the [MacosScrollbar]
/// computes its own default values.
///
/// See also:
///
///  * [MacosThemeData], which describes the overall theme information for the
///    application.
class ScrollbarThemeData with Diagnosticable {
  /// Creates a theme that can be used for [MacosThemeData.scrollbarTheme].
  const ScrollbarThemeData({
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
  /// descendant [MacosScrollbar] widgtes when hovering is active.
  final double? hoveringThickness;

  /// Overrides the default value of [MacosScrollbar.showTrackOnHover] in all
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

  /// Overrides the default [Color] of the [MacosScrollbar] thumb in all descendant
  /// [MacosScrollbar] widgets.
  final Color? thumbColor;

  /// Overrides the default [Color] of the [MacosScrollbar] thumb in all descendant
  /// [MacosScrollbar] widgets when hovering is active.
  final Color? hoveringThumbColor;

  /// Overrides the default [Color] of the [MacosScrollbar] thumb in all descendant
  /// [MacosScrollbar] widgets when dragging is active.
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
  ScrollbarThemeData copyWith({
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
    return ScrollbarThemeData(
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
  static ScrollbarThemeData lerp(
    ScrollbarThemeData? a,
    ScrollbarThemeData? b,
    double t,
  ) {
    return ScrollbarThemeData(
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
    return other is ScrollbarThemeData &&
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

  ScrollbarThemeData merge(ScrollbarThemeData? other) {
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

/// Applies a scrollbar theme to descendant [MacosScrollbar] widgets.
///
/// Descendant widgets obtain the current theme's [ScrollbarThemeData] using
/// [ScrollbarTheme.of]. When a widget uses [ScrollbarTheme.of], it is
/// automatically rebuilt if the theme later changes.
///
/// A scrollbar theme can be specified as part of the overall Material theme
/// using [ThemeData.scrollbarTheme].
///
/// See also:
///
///  * [ScrollbarThemeData], which describes the configuration of a
///    scrollbar theme.
class ScrollbarTheme extends InheritedWidget {
  /// Constructs a scrollbar theme that configures all descendant [MacosScrollbar]
  /// widgets.
  const ScrollbarTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The properties used for all descendant [MacosScrollbar] widgets.
  final ScrollbarThemeData data;

  /// Returns the configuration [data] from the closest [ScrollbarTheme]
  /// ancestor. If there is no ancestor, it returns [ThemeData.scrollbarTheme].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ScrollbarThemeData theme = ScrollbarTheme.of(context);
  /// ```
  static ScrollbarThemeData of(BuildContext context) {
    final ScrollbarTheme? scrollbarTheme =
        context.dependOnInheritedWidgetOfExactType<ScrollbarTheme>();
    return scrollbarTheme?.data ?? MacosTheme.of(context).scrollbarTheme;
  }

  @override
  bool updateShouldNotify(ScrollbarTheme oldWidget) => data != oldWidget.data;
}
