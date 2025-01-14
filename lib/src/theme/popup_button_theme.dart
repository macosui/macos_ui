import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// Overrides the default style of its [MacosPopupButton] descendants.
///
/// See also:
///
///  * [MacosPopupButtonThemeData], which is used to configure this theme.
class MacosPopupButtonTheme extends InheritedTheme {
  /// Creates a [MacosPopupButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const MacosPopupButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final MacosPopupButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [MacosPopupButtonTheme] widget, then
  /// [MacosThemeData.MacosPopupButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// MacosPopupButtonTheme theme = MacosPopupButtonTheme.of(context);
  /// ```
  static MacosPopupButtonThemeData of(BuildContext context) {
    final MacosPopupButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<MacosPopupButtonTheme>();
    return buttonTheme?.data ?? MacosTheme.of(context).popupButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MacosPopupButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MacosPopupButtonTheme oldWidget) =>
      data != oldWidget.data;
}

/// A style that overrides the default appearance of
/// [MacosPopupButton]s when it is used with [MacosPopupButtonTheme] or with the
/// overall [MacosTheme]'s [MacosThemeData.MacosPopupButtonTheme].
///
/// See also:
///
///  * [MacosPopupButtonTheme], the theme which is configured with this class.
///  * [MacosThemeData.MacosPopupButtonTheme], which can be used to override the default
///    style for [MacosPopupButton]s below the overall [MacosTheme].
class MacosPopupButtonThemeData with Diagnosticable {
  /// Creates a [MacosPopupButtonThemeData].
  const MacosPopupButtonThemeData({
    this.highlightColor,
    this.backgroundColor,
    this.popupColor,
  });

  /// The default highlight color for [MacosPopupButton].
  ///
  /// Sets the color of the caret icons and the color of a [MacosPopupMenuItem]'s background when the mouse hovers over it.
  final Color? highlightColor;

  /// The default background color for [MacosPopupButton]
  final Color? backgroundColor;

  /// The default popup menu color for [MacosPopupButton]
  final Color? popupColor;

  /// Copies this [MacosPopupButtonThemeData] into another.
  MacosPopupButtonThemeData copyWith({
    Color? highlightColor,
    Color? backgroundColor,
    Color? popupColor,
  }) {
    return MacosPopupButtonThemeData(
      highlightColor: highlightColor ?? this.highlightColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      popupColor: popupColor ?? this.popupColor,
    );
  }

  /// Linearly interpolates between two [MacosPopupButtonThemeData].
  ///
  /// All the properties must be non-null.
  static MacosPopupButtonThemeData lerp(
    MacosPopupButtonThemeData a,
    MacosPopupButtonThemeData b,
    double t,
  ) {
    return MacosPopupButtonThemeData(
      highlightColor: Color.lerp(a.highlightColor, b.highlightColor, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      popupColor: Color.lerp(a.popupColor, b.popupColor, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MacosPopupButtonThemeData &&
          runtimeType == other.runtimeType &&
          highlightColor == other.highlightColor &&
          backgroundColor == other.backgroundColor &&
          popupColor == other.popupColor;

  @override
  int get hashCode => highlightColor.hashCode ^ backgroundColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('highlightColor', highlightColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('popupColor', popupColor));
  }

  /// Merges this [MacosPopupButtonThemeData] with another.
  MacosPopupButtonThemeData merge(MacosPopupButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      highlightColor: other.highlightColor,
      backgroundColor: other.backgroundColor,
      popupColor: other.popupColor,
    );
  }
}
