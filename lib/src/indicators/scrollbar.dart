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
/// [trackVisibility]. The thickness of the track and scrollbar thumb will
/// become larger when hovering, unless overridden by [hoverThickness].
///
/// See also:
///
///  * [RawScrollbar], a basic scrollbar that fades in and out, extended
///    by this class to add more animations and behaviors.
///  * [MacosScrollbarTheme], which configures the Scrollbar's appearance.
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
    super.key,
    required this.child,
    this.controller,
    this.isAlwaysShown,
    this.trackVisibility,
    this.thickness,
    this.radius,
    this.notificationPredicate,
    this.interactive,
  });

  /// {@macro flutter.widgets.Scrollbar.child}
  final Widget child;

  /// {@macro flutter.widgets.Scrollbar.controller}
  final ScrollController? controller;

  /// {@macro flutter.widgets.Scrollbar.isAlwaysShown}
  final bool? isAlwaysShown;

  /// Controls if the track will always be visible or not.
  ///
  /// If this property is null, then [MacosScrollbarThemeData.showTrackOnHover] of
  /// [MacosThemeData.scrollbarTheme] is used. If that is also null, the default value
  /// is false.
  final bool? trackVisibility;

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
    final theme = MacosScrollbarTheme.of(context);
    return m.ScrollbarTheme(
      data: m.ScrollbarThemeData(
        crossAxisMargin: theme.crossAxisMargin,
        mainAxisMargin: theme.mainAxisMargin,
        interactive: theme.interactive,
        thumbVisibility: m.MaterialStateProperty.resolveWith((states) {
          return isAlwaysShown;
        }),
        trackVisibility: m.MaterialStateProperty.resolveWith((states) {
          return trackVisibility;
        }),
        minThumbLength: theme.minThumbLength,
        radius: theme.radius,
        thickness: m.MaterialStateProperty.resolveWith((states) {
          if (states.contains(m.MaterialState.hovered)) {
            return theme.hoveringThickness ?? theme.thickness;
          }
          return theme.thickness;
        }),
        thumbColor: m.MaterialStateProperty.resolveWith((states) {
          if (states.contains(m.MaterialState.hovered)) {
            return theme.hoveringThumbColor ?? theme.thumbColor;
          } else if (states.contains(m.MaterialState.dragged)) {
            return theme.draggingThumbColor ?? theme.thumbColor;
          }
          return theme.thumbColor;
        }),
        trackBorderColor: m.MaterialStateProperty.resolveWith((states) {
          if (states.contains(m.MaterialState.hovered)) {
            return theme.hoveringTrackBorderColor ?? theme.trackBorderColor;
          }
          return theme.trackBorderColor;
        }),
        trackColor: m.MaterialStateProperty.resolveWith((states) {
          if (states.contains(m.MaterialState.hovered)) {
            return theme.hoveringTrackColor ?? theme.trackColor;
          }
          return theme.trackColor;
        }),
      ),
      child: m.Scrollbar(
        controller: controller,
        thumbVisibility: isAlwaysShown,
        trackVisibility: trackVisibility,
        thickness: thickness,
        radius: radius,
        interactive: interactive,
        notificationPredicate: notificationPredicate,
        child: child,
      ),
    );
  }
}
