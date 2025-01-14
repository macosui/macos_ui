import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// Overrides the default style of its [MacosSearchField] descendants.
///
/// See also:
///
///  * [MacosSearchFieldThemeData], which is used to configure this theme.
class MacosSearchFieldTheme extends InheritedTheme {
  /// Creates a [MacosSearchFieldTheme].
  ///
  /// The [data] parameter must not be null.
  const MacosSearchFieldTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final MacosSearchFieldThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [MacosSearchFieldTheme] widget, then
  /// [MacosThemeData.MacosSearchFieldTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// MacosSearchFieldTheme theme = MacosSearchFieldTheme.of(context);
  /// ```
  static MacosSearchFieldThemeData of(BuildContext context) {
    final MacosSearchFieldTheme? searchFieldTheme =
        context.dependOnInheritedWidgetOfExactType<MacosSearchFieldTheme>();
    return searchFieldTheme?.data ?? MacosTheme.of(context).searchFieldTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MacosSearchFieldTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MacosSearchFieldTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@template macosSearchFieldThemeData}
/// A style that overrides the default appearance of
/// [MacosSearchField]s when it is used with [MacosSearchFieldTheme] or with the
/// overall [MacosTheme]'s [MacosThemeData.MacosSearchFieldTheme].
///
/// See also:
///
///  * [MacosSearchFieldTheme], the theme which is configured with this class.
///  * [MacosThemeData.MacosSearchFieldTheme], which can be used to override the default
///    style for [MacosSearchField]s below the overall [MacosTheme].
/// {@endtemplate}
class MacosSearchFieldThemeData with Diagnosticable {
  /// {@macro macosSearchFieldThemeData}
  const MacosSearchFieldThemeData({
    this.highlightColor,
    this.resultsBackgroundColor,
  });

  /// The default highlight color for [MacosSearchField].
  ///
  /// Sets the color of a [SearchSuggestionItem]'s background when the mouse
  /// hovers over it.
  final Color? highlightColor;

  /// The default background color for the [MacosSearchField] search results
  /// overlay.
  final Color? resultsBackgroundColor;

  /// Copied one [MacosSearchFieldThemeData] to another.
  MacosSearchFieldThemeData copyWith({
    Color? highlightColor,
    Color? resultsBackgroundColor,
  }) {
    return MacosSearchFieldThemeData(
      highlightColor: highlightColor ?? this.highlightColor,
      resultsBackgroundColor:
          resultsBackgroundColor ?? this.resultsBackgroundColor,
    );
  }

  /// Linearly interpolates between two [MacosSearchFieldThemeData].
  ///
  /// All the properties must be non-null.
  static MacosSearchFieldThemeData lerp(
    MacosSearchFieldThemeData a,
    MacosSearchFieldThemeData b,
    double t,
  ) {
    return MacosSearchFieldThemeData(
      highlightColor: Color.lerp(a.highlightColor, b.highlightColor, t),
      resultsBackgroundColor: Color.lerp(
        a.resultsBackgroundColor,
        b.resultsBackgroundColor,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MacosSearchFieldThemeData &&
          runtimeType == other.runtimeType &&
          highlightColor == other.highlightColor &&
          resultsBackgroundColor == other.resultsBackgroundColor;

  @override
  int get hashCode => highlightColor.hashCode ^ resultsBackgroundColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('highlightColor', highlightColor));
    properties.add(ColorProperty(
      'resultsBackgroundColor',
      resultsBackgroundColor,
    ));
  }

  /// Merges this [MacosSearchFieldThemeData] with another.
  MacosSearchFieldThemeData merge(MacosSearchFieldThemeData? other) {
    if (other == null) return this;
    return copyWith(
      highlightColor: other.highlightColor,
      resultsBackgroundColor: other.resultsBackgroundColor,
    );
  }
}
