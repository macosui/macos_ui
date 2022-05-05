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
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

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

/// A style that overrides the default appearance of
/// [MacosSearchField]s when it is used with [MacosSearchFieldTheme] or with the
/// overall [MacosTheme]'s [MacosThemeData.MacosSearchFieldTheme].
///
/// See also:
///
///  * [MacosSearchFieldTheme], the theme which is configured with this class.
///  * [MacosThemeData.MacosSearchFieldTheme], which can be used to override the default
///    style for [MacosSearchField]s below the overall [MacosTheme].
class MacosSearchFieldThemeData with Diagnosticable {
  /// Creates a [MacosSearchFieldThemeData].
  const MacosSearchFieldThemeData({
    this.highlightColor,
    this.suggestionsBackgroundColor,
  });

  /// The default highlight color for [MacosSearchField].
  ///
  /// Sets the color of a [SearchSuggestionItem]'s background when the mouse
  /// hovers over it.
  final Color? highlightColor;

  /// The default background color for the [MacosSearchField] search suggestions
  /// overlay.
  final Color? suggestionsBackgroundColor;

  MacosSearchFieldThemeData copyWith({
    Color? highlightColor,
    Color? suggestionsBackgroundColor,
  }) {
    return MacosSearchFieldThemeData(
      highlightColor: highlightColor ?? this.highlightColor,
      suggestionsBackgroundColor:
          suggestionsBackgroundColor ?? this.suggestionsBackgroundColor,
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
      suggestionsBackgroundColor: Color.lerp(
        a.suggestionsBackgroundColor,
        b.suggestionsBackgroundColor,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MacosSearchFieldThemeData &&
          runtimeType == other.runtimeType &&
          highlightColor?.value == other.highlightColor?.value &&
          suggestionsBackgroundColor?.value ==
              other.suggestionsBackgroundColor?.value;

  @override
  int get hashCode =>
      highlightColor.hashCode ^ suggestionsBackgroundColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('highlightColor', highlightColor));
    properties.add(ColorProperty(
      'suggestionsBackgroundColor',
      suggestionsBackgroundColor,
    ));
  }

  MacosSearchFieldThemeData merge(MacosSearchFieldThemeData? other) {
    if (other == null) return this;
    return copyWith(
      highlightColor: other.highlightColor,
      suggestionsBackgroundColor: other.suggestionsBackgroundColor,
    );
  }
}
