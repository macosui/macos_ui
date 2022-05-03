import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// Overrides the default style of its [MacosDatePicker] descendants.
///
/// See also:
///
///  * [MacosDatePickerThemeData], which is used to configure this theme.
class MacosDatePickerTheme extends InheritedTheme {
  /// Builds a [MacosDatePickerTheme].
  ///
  /// The [data] parameter must not be null.
  const MacosDatePickerTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final MacosDatePickerThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [MacosDatePickerTheme] widget, then
  /// [MacosThemeData.datePickerTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = MacosDatePickerTheme.of(context);
  /// ```
  static MacosDatePickerThemeData of(BuildContext context) {
    final MacosDatePickerTheme? datePickerTheme =
        context.dependOnInheritedWidgetOfExactType<MacosDatePickerTheme>();
    return datePickerTheme?.data ?? MacosTheme.of(context).datePickerTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MacosDatePickerTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MacosDatePickerTheme oldWidget) =>
      data != oldWidget.data;
}

class MacosDatePickerThemeData with Diagnosticable {
  MacosDatePickerThemeData({
    this.backgroundColor,
    this.selectedElementColor,
    this.selectedElementTextColor,
    this.caretColor,
    this.monthViewControlsColor,
    this.caretControlsBackgroundColor,
    this.caretControlsSeparatorColor,
    this.monthViewHeaderColor,
    this.monthViewSelectedDateColor,
    this.monthViewSelectedDateTextColor,
    this.monthViewCurrentDateColor,
    this.monthViewWeekdayHeaderColor,
    this.monthViewHeaderDividerColor,
    this.monthViewDateColor,
    this.shadowColor,
  });

  final Color? backgroundColor;
  final Color? selectedElementColor;
  final Color? selectedElementTextColor;
  final Color? caretColor;
  final Color? caretControlsBackgroundColor;
  final Color? caretControlsSeparatorColor;
  final Color? monthViewControlsColor;
  final Color? monthViewHeaderColor;
  final Color? monthViewSelectedDateColor;
  final Color? monthViewSelectedDateTextColor;
  final Color? monthViewCurrentDateColor;
  final Color? monthViewWeekdayHeaderColor;
  final Color? monthViewHeaderDividerColor;
  final Color? monthViewDateColor;
  final Color? shadowColor;

  /// Copies this [MacosDatePickerThemeData] into another.
  MacosDatePickerThemeData copyWith({
    Color? backgroundColor,
    Color? selectedElementColor,
    Color? selectedElementTextColor,
    Color? caretColor,
    Color? caretControlsBackgroundColor,
    Color? caretControlsSeparatorColor,
    Color? monthViewControlsColor,
    Color? monthViewHeaderColor,
    Color? monthViewSelectedDateColor,
    Color? monthViewSelectedDateTextColor,
    Color? monthViewCurrentDateColor,
    Color? monthViewWeekdayHeaderColor,
    Color? monthViewHeaderDividerColor,
    Color? monthViewDateColor,
    Color? shadowColor,
  }) {
    return MacosDatePickerThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedElementColor: selectedElementColor ?? this.selectedElementColor,
      selectedElementTextColor:
          selectedElementTextColor ?? this.selectedElementTextColor,
      caretColor: caretColor ?? this.caretColor,
      caretControlsBackgroundColor:
          caretControlsBackgroundColor ?? this.caretControlsBackgroundColor,
      caretControlsSeparatorColor:
          caretControlsSeparatorColor ?? this.caretControlsSeparatorColor,
      monthViewControlsColor:
          monthViewControlsColor ?? this.monthViewControlsColor,
      monthViewHeaderColor: monthViewHeaderColor ?? this.monthViewHeaderColor,
      monthViewSelectedDateColor:
          monthViewSelectedDateColor ?? this.monthViewSelectedDateColor,
      monthViewSelectedDateTextColor:
          monthViewSelectedDateTextColor ?? this.monthViewSelectedDateTextColor,
      monthViewCurrentDateColor:
          monthViewCurrentDateColor ?? this.monthViewCurrentDateColor,
      monthViewWeekdayHeaderColor:
          monthViewWeekdayHeaderColor ?? this.monthViewWeekdayHeaderColor,
      monthViewHeaderDividerColor:
          monthViewHeaderDividerColor ?? this.monthViewHeaderDividerColor,
      monthViewDateColor: monthViewDateColor ?? this.monthViewDateColor,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  /// Linearly interpolate between two [MacosDatePickerThemeData].
  ///
  /// All the properties must be non-null.
  static MacosDatePickerThemeData lerp(
    MacosDatePickerThemeData a,
    MacosDatePickerThemeData b,
    double t,
  ) {
    return MacosDatePickerThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      selectedElementColor:
          Color.lerp(a.selectedElementColor, b.selectedElementColor, t),
      selectedElementTextColor:
          Color.lerp(a.selectedElementTextColor, b.selectedElementTextColor, t),
      caretColor: Color.lerp(a.caretColor, b.caretColor, t),
      caretControlsBackgroundColor: Color.lerp(
        a.caretControlsBackgroundColor,
        b.caretControlsBackgroundColor,
        t,
      ),
      caretControlsSeparatorColor: Color.lerp(
        a.caretControlsSeparatorColor,
        b.caretControlsSeparatorColor,
        t,
      ),
      monthViewControlsColor:
          Color.lerp(a.monthViewControlsColor, b.monthViewControlsColor, t),
      monthViewHeaderColor:
          Color.lerp(a.monthViewHeaderColor, b.monthViewHeaderColor, t),
      monthViewSelectedDateColor: Color.lerp(
        a.monthViewSelectedDateColor,
        b.monthViewSelectedDateColor,
        t,
      ),
      monthViewSelectedDateTextColor: Color.lerp(
        a.monthViewSelectedDateTextColor,
        b.monthViewSelectedDateTextColor,
        t,
      ),
      monthViewCurrentDateColor: Color.lerp(
        a.monthViewCurrentDateColor,
        b.monthViewCurrentDateColor,
        t,
      ),
      monthViewWeekdayHeaderColor: Color.lerp(
        a.monthViewWeekdayHeaderColor,
        b.monthViewWeekdayHeaderColor,
        t,
      ),
      monthViewHeaderDividerColor: Color.lerp(
        a.monthViewHeaderDividerColor,
        b.monthViewHeaderDividerColor,
        t,
      ),
      monthViewDateColor:
          Color.lerp(a.monthViewDateColor, b.monthViewDateColor, t),
      shadowColor: Color.lerp(a.shadowColor, b.shadowColor, t),
    );
  }

  MacosDatePickerThemeData merge(MacosDatePickerThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      selectedElementColor: other.selectedElementColor,
      selectedElementTextColor: other.selectedElementTextColor,
      caretColor: other.caretColor,
      caretControlsBackgroundColor: other.caretControlsBackgroundColor,
      caretControlsSeparatorColor: other.caretControlsSeparatorColor,
      monthViewControlsColor: other.monthViewControlsColor,
      monthViewHeaderColor: other.monthViewHeaderColor,
      monthViewSelectedDateColor: other.monthViewSelectedDateColor,
      monthViewSelectedDateTextColor: other.monthViewSelectedDateTextColor,
      monthViewCurrentDateColor: other.monthViewCurrentDateColor,
      monthViewWeekdayHeaderColor: other.monthViewWeekdayHeaderColor,
      monthViewHeaderDividerColor: other.monthViewHeaderDividerColor,
      monthViewDateColor: other.monthViewDateColor,
      shadowColor: other.shadowColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MacosDatePickerThemeData &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          selectedElementColor == other.selectedElementColor &&
          selectedElementTextColor == other.selectedElementTextColor &&
          caretColor == other.caretColor &&
          caretControlsBackgroundColor == other.caretControlsBackgroundColor &&
          caretControlsSeparatorColor == other.caretControlsSeparatorColor &&
          monthViewControlsColor == other.monthViewControlsColor &&
          monthViewHeaderColor == other.monthViewHeaderColor &&
          monthViewSelectedDateColor == other.monthViewSelectedDateColor &&
          monthViewSelectedDateTextColor ==
              other.monthViewSelectedDateTextColor &&
          monthViewCurrentDateColor == other.monthViewCurrentDateColor &&
          monthViewWeekdayHeaderColor == other.monthViewWeekdayHeaderColor &&
          monthViewHeaderDividerColor == other.monthViewHeaderDividerColor &&
          monthViewDateColor == other.monthViewDateColor &&
          shadowColor == other.shadowColor;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      selectedElementColor.hashCode ^
      selectedElementTextColor.hashCode ^
      caretColor.hashCode ^
      caretControlsBackgroundColor.hashCode ^
      caretControlsSeparatorColor.hashCode ^
      monthViewControlsColor.hashCode ^
      monthViewHeaderColor.hashCode ^
      monthViewSelectedDateColor.hashCode ^
      monthViewSelectedDateTextColor.hashCode ^
      monthViewCurrentDateColor.hashCode ^
      monthViewWeekdayHeaderColor.hashCode ^
      monthViewHeaderDividerColor.hashCode ^
      monthViewDateColor.hashCode ^
      shadowColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('selectedElementColor', selectedElementColor));
    properties.add(
      ColorProperty('selectedElementTextColor', selectedElementTextColor),
    );
    properties.add(ColorProperty('caretColor', caretColor));
    properties.add(ColorProperty(
      'caretControlsBackgroundColor',
      caretControlsBackgroundColor,
    ));
    properties.add(ColorProperty(
      'caretControlsSeparatorColor',
      caretControlsSeparatorColor,
    ));
    properties
        .add(ColorProperty('monthViewControlsColor', monthViewControlsColor));
    properties.add(ColorProperty('monthViewHeaderColor', monthViewHeaderColor));
    properties.add(ColorProperty(
      'monthViewSelectedDateColor',
      monthViewSelectedDateColor,
    ));
    properties.add(ColorProperty(
      'monthViewSelectedDateTextColor',
      monthViewSelectedDateTextColor,
    ));
    properties.add(ColorProperty(
      'monthViewCurrentDateColor',
      monthViewCurrentDateColor,
    ));
    properties.add(ColorProperty(
      'monthViewWeekdayHeaderColor',
      monthViewWeekdayHeaderColor,
    ));
    properties.add(ColorProperty(
      'monthViewHeaderDividerColor',
      monthViewHeaderDividerColor,
    ));
    properties.add(ColorProperty('monthViewDateColor', monthViewDateColor));
    properties.add(ColorProperty('shadowColor', shadowColor));
  }
}
