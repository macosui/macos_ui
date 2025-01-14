import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// Overrides the default style of its [MacosPulldownButton] descendants.
///
/// See also:
///
///  * [MacosPulldownButtonThemeData], which is used to configure this theme.
class MacosPulldownButtonTheme extends InheritedTheme {
  /// Creates a [MacosPulldownButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const MacosPulldownButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final MacosPulldownButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [MacosPulldownButtonTheme] widget, then
  /// [MacosThemeData.MacosPulldownButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// MacosPulldownButtonTheme theme = MacosPulldownButtonTheme.of(context);
  /// ```
  static MacosPulldownButtonThemeData of(BuildContext context) {
    final MacosPulldownButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<MacosPulldownButtonTheme>();
    return buttonTheme?.data ?? MacosTheme.of(context).pulldownButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MacosPulldownButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MacosPulldownButtonTheme oldWidget) =>
      data != oldWidget.data;
}

/// A style that overrides the default appearance of
/// [MacosPulldownButton]s when it is used with [MacosPulldownButtonTheme] or with the
/// overall [MacosTheme]'s [MacosThemeData.MacosPulldownButtonTheme].
///
/// See also:
///
///  * [MacosPulldownButtonTheme], the theme which is configured with this class.
///  * [MacosThemeData.MacosPulldownButtonTheme], which can be used to override the default
///    style for [MacosPulldownButton]s below the overall [MacosTheme].
class MacosPulldownButtonThemeData with Diagnosticable {
  /// Creates a [MacosPulldownButtonThemeData].
  const MacosPulldownButtonThemeData({
    this.highlightColor,
    this.backgroundColor,
    this.pulldownColor,
    this.iconColor,
  });

  /// The default highlight color for [MacosPulldownButton].
  ///
  /// Sets the color of the caret icon and the color of a [MacosPulldownMenuItem]'s background when the mouse hovers over it.
  final Color? highlightColor;

  /// The default background color for [MacosPulldownButton].
  final Color? backgroundColor;

  /// The default pull-down menu color for [MacosPulldownButton].
  final Color? pulldownColor;

  /// The default color for a [MacosPulldownButton]'s icon.
  final Color? iconColor;

  /// Copies this [MacosPulldownButtonThemeData] into another.
  MacosPulldownButtonThemeData copyWith({
    Color? highlightColor,
    Color? backgroundColor,
    Color? pulldownColor,
    Color? iconColor,
  }) {
    return MacosPulldownButtonThemeData(
      highlightColor: highlightColor ?? this.highlightColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      pulldownColor: pulldownColor ?? this.pulldownColor,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  /// Linearly interpolates between two [MacosPulldownButtonThemeData].
  ///
  /// All the properties must be non-null.
  static MacosPulldownButtonThemeData lerp(
    MacosPulldownButtonThemeData a,
    MacosPulldownButtonThemeData b,
    double t,
  ) {
    return MacosPulldownButtonThemeData(
      highlightColor: Color.lerp(a.highlightColor, b.highlightColor, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      pulldownColor: Color.lerp(a.pulldownColor, b.pulldownColor, t),
      iconColor: Color.lerp(a.iconColor, b.iconColor, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MacosPulldownButtonThemeData &&
          runtimeType == other.runtimeType &&
          highlightColor == other.highlightColor &&
          backgroundColor == other.backgroundColor &&
          pulldownColor == other.pulldownColor &&
          iconColor == other.iconColor;

  @override
  int get hashCode => highlightColor.hashCode ^ backgroundColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('highlightColor', highlightColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('pulldownColor', pulldownColor));
    properties.add(ColorProperty('iconColor', iconColor));
  }

  /// Merges this [MacosPulldownButtonThemeData] with another.
  MacosPulldownButtonThemeData merge(MacosPulldownButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      highlightColor: other.highlightColor,
      backgroundColor: other.backgroundColor,
      pulldownColor: other.pulldownColor,
      iconColor: other.iconColor,
    );
  }
}
