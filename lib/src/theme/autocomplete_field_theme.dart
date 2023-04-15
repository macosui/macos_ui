import 'package:flutter/foundation.dart';

import '../../macos_ui.dart';
import '../library.dart';

/// Overrides the default style of its [MacosAutoCompleteField] descendants.
///
/// See also:
///
///  * [MacosAutoCompleteFieldThemeData], which is used to configure this theme.
class MacosAutoCompleteFieldTheme extends InheritedTheme {
  /// Creates a [MacosAutoCompleteFieldTheme].
  ///
  /// The [data] parameter must not be null.
  const MacosAutoCompleteFieldTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final MacosAutoCompleteFieldThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [MacosAutoCompleteFieldTheme] widget, then
  /// [MacosThemeData.MacosAutoCompleteFieldTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// MacosAutoCompleteFieldTheme theme = MacosAutoCompleteFieldTheme.of(context);
  /// ```
  static MacosAutoCompleteFieldThemeData of(BuildContext context) {
    final MacosAutoCompleteFieldTheme? autoCompleteFieldTheme = context
        .dependOnInheritedWidgetOfExactType<MacosAutoCompleteFieldTheme>();
    return autoCompleteFieldTheme?.data ??
        MacosTheme.of(context).autoCompleteFieldTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MacosAutoCompleteFieldTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MacosAutoCompleteFieldTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@template MacosAutoCompleteFieldThemeData}
/// A style that overrides the default appearance of
/// [MacosAutoCompleteField]s when it is used with [MacosAutoCompleteFieldTheme] or with the
/// overall [MacosTheme]'s [MacosThemeData.MacosAutoCompleteFieldTheme].
///
/// See also:
///
///  * [MacosAutoCompleteFieldTheme], the theme which is configured with this class.
///  * [MacosThemeData.MacosAutoCompleteFieldTheme], which can be used to override the default
///    style for [MacosAutoCompleteField]s below the overall [MacosTheme].
/// {@endtemplate}
class MacosAutoCompleteFieldThemeData with Diagnosticable {
  /// {@macro MacosAutoCompleteFieldThemeData}
  const MacosAutoCompleteFieldThemeData({
    this.highlightColor,
    this.resultsBackgroundColor,
  });

  /// The default highlight color for [MacosAutoCompleteField].
  ///
  /// Sets the color of a [SearchSuggestionItem]'s background when the mouse
  /// hovers over it.
  final Color? highlightColor;

  /// The default background color for the [MacosAutoCompleteField] search results
  /// overlay.
  final Color? resultsBackgroundColor;

  /// Copied one [MacosAutoCompleteFieldThemeData] to another.
  MacosAutoCompleteFieldThemeData copyWith({
    Color? highlightColor,
    Color? resultsBackgroundColor,
  }) {
    return MacosAutoCompleteFieldThemeData(
      highlightColor: highlightColor ?? this.highlightColor,
      resultsBackgroundColor:
          resultsBackgroundColor ?? this.resultsBackgroundColor,
    );
  }

  /// Linearly interpolates between two [MacosAutoCompleteFieldThemeData].
  ///
  /// All the properties must be non-null.
  static MacosAutoCompleteFieldThemeData lerp(
    MacosAutoCompleteFieldThemeData a,
    MacosAutoCompleteFieldThemeData b,
    double t,
  ) {
    return MacosAutoCompleteFieldThemeData(
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
      other is MacosAutoCompleteFieldThemeData &&
          runtimeType == other.runtimeType &&
          highlightColor?.value == other.highlightColor?.value &&
          resultsBackgroundColor?.value == other.resultsBackgroundColor?.value;

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

  /// Merges this [MacosAutoCompleteFieldThemeData] with another.
  MacosAutoCompleteFieldThemeData merge(
    MacosAutoCompleteFieldThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      highlightColor: other.highlightColor,
      resultsBackgroundColor: other.resultsBackgroundColor,
    );
  }
}
