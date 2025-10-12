import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:macos_ui/src/theme/macos_colors.dart';
import 'package:macos_ui/src/theme/macos_theme.dart';

const _kDefaultFontFamily = '.AppleSystemUIFont';

/// macOS typography.
///
/// To obtain the current typography, call [MacosTheme.of] with the current
/// [BuildContext] and read the [MacosThemeData.typography] property.
///
/// See also:
///
///  * [MacosTheme], for aspects of a macos application that can be globally
///    adjusted, such as the primary color.
///  * <https://developer.apple.com/design/human-interface-guidelines/macos/visual-design/typography/>
class MacosTypography extends Equatable with Diagnosticable {
  /// Creates a typography that uses the given values.
  ///
  /// Rather than creating a new typography, consider using [MacosTypography.darkOpaque]
  /// or [MacosTypography.lightOpaque].
  ///
  /// If you do decide to create your own typography, consider using one of
  /// those predefined themes as a starting point for [copyWith].
  factory MacosTypography({
    required Color color,
    TextStyle? largeTitle,
    TextStyle? title1,
    TextStyle? title2,
    TextStyle? title3,
    TextStyle? headline,
    TextStyle? subheadline,
    TextStyle? body,
    TextStyle? callout,
    TextStyle? footnote,
    TextStyle? caption1,
    TextStyle? caption2,
  }) {
    largeTitle ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 26,
      letterSpacing: 0.22,
      color: color,
    );
    title1 ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 22,
      letterSpacing: -0.26,
      color: color,
    );
    title2 ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 17,
      letterSpacing: -0.43,
      color: color,
    );
    title3 ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 15,
      letterSpacing: -0.23,
      color: color,
    );
    headline ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 13,
      letterSpacing: -0.08,
      color: color,
    );
    body ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 13,
      letterSpacing: 0.06,
      color: color,
    );
    callout ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: color,
    );
    subheadline ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 11,
      letterSpacing: 0.06,
      color: color,
    );
    footnote ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 10,
      letterSpacing: 0.12,
      color: color,
    );
    caption1 ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 10,
      letterSpacing: 0.12,
      color: color,
    );
    caption2 ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: MacosFontWeight.w510,
      fontSize: 10,
      letterSpacing: 0.12,
      color: color,
    );
    return MacosTypography.raw(
      largeTitle: largeTitle,
      title1: title1,
      title2: title2,
      title3: title3,
      headline: headline,
      subheadline: subheadline,
      body: body,
      callout: callout,
      footnote: footnote,
      caption1: caption1,
      caption2: caption2,
    );
  }

  const MacosTypography.raw({
    required this.largeTitle,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.headline,
    required this.subheadline,
    required this.body,
    required this.callout,
    required this.footnote,
    required this.caption1,
    required this.caption2,
  });

  factory MacosTypography.darkOpaque() =>
      MacosTypography(color: MacosColors.labelColor.color);
  factory MacosTypography.lightOpaque() =>
      MacosTypography(color: MacosColors.labelColor.darkColor);

  /// Style used for body text.
  final TextStyle body;

  /// Style used for callouts.
  final TextStyle callout;

  /// Style used for standard captions.
  final TextStyle caption1;

  /// Style used for alternate captions.
  final TextStyle caption2;

  /// Style used in footnotes
  final TextStyle footnote;

  /// Style used for headings.
  final TextStyle headline;

  /// Style used for large titles.
  final TextStyle largeTitle;

  /// Style used for subheadings.
  final TextStyle subheadline;

  /// Style used for first-level hierarchical headings.
  final TextStyle title1;

  /// Style used for second-level hierarchical headings.
  final TextStyle title2;

  /// Style used for third-level hierarchical headings.
  final TextStyle title3;

  /// Creates a new [MacosTypography] where each text style from this object has been
  /// merged with the matching text style from the `other` object.
  ///
  /// The merging is done by calling [TextStyle.merge] on each respective pair
  /// of text styles from this and the [other] typographies and is subject to
  /// the value of [TextStyle.inherit] flag. For more details, see the
  /// documentation on [TextStyle.merge] and [TextStyle.inherit].
  ///
  /// If this theme, or the `other` theme has members that are null, then the
  /// non-null one (if any) is used. If the `other` theme is itself null, then
  /// this [MacosTypography] is returned unchanged. If values in both are set, then
  /// the values are merged using [TextStyle.merge].
  ///
  /// This is particularly useful if one [MacosTypography] defines one set of
  /// properties and another defines a different set, e.g. having colors
  /// defined in one typography and font sizes in another, or when one
  /// [MacosTypography] has only some fields defined, and you want to define the rest
  /// by merging it with a default theme.
  MacosTypography merge(MacosTypography? other) {
    if (other == null) return this;
    return MacosTypography.raw(
      largeTitle: largeTitle.merge(other.largeTitle),
      title1: title1.merge(other.title1),
      title2: title2.merge(other.title2),
      title3: title3.merge(other.title3),
      headline: headline.merge(other.headline),
      subheadline: subheadline.merge(other.subheadline),
      body: body.merge(other.body),
      callout: callout.merge(other.callout),
      footnote: callout.merge(other.footnote),
      caption1: caption1.merge(other.caption1),
      caption2: caption2.merge(other.caption2),
    );
  }

  /// Linearly interpolate between two typographies.
  static MacosTypography lerp(MacosTypography a, MacosTypography b, double t) {
    return MacosTypography.raw(
      largeTitle: TextStyle.lerp(a.largeTitle, b.largeTitle, t)!,
      title1: TextStyle.lerp(a.title1, b.title1, t)!,
      title2: TextStyle.lerp(a.title2, b.title2, t)!,
      title3: TextStyle.lerp(a.title3, b.title3, t)!,
      headline: TextStyle.lerp(a.headline, b.headline, t)!,
      subheadline: TextStyle.lerp(a.subheadline, b.subheadline, t)!,
      body: TextStyle.lerp(a.body, b.body, t)!,
      callout: TextStyle.lerp(a.callout, b.callout, t)!,
      footnote: TextStyle.lerp(a.footnote, b.footnote, t)!,
      caption1: TextStyle.lerp(a.caption1, b.caption1, t)!,
      caption2: TextStyle.lerp(a.caption2, b.caption2, t)!,
    );
  }

  static MacosTypography of(BuildContext context) {
    final theme = MacosTheme.of(context);
    return theme.typography;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final defaultStyle = MacosTypography.darkOpaque();
    properties.add(DiagnosticsProperty<TextStyle>(
      'largeTitle',
      largeTitle,
      defaultValue: defaultStyle.largeTitle,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'title1',
      title1,
      defaultValue: defaultStyle.title1,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'title2',
      title2,
      defaultValue: defaultStyle.title2,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'title3',
      title3,
      defaultValue: defaultStyle.title3,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'headline',
      headline,
      defaultValue: defaultStyle.headline,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'subheadline',
      subheadline,
      defaultValue: defaultStyle.subheadline,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'body',
      body,
      defaultValue: defaultStyle.body,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'callout',
      callout,
      defaultValue: defaultStyle.callout,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'footnote',
      footnote,
      defaultValue: defaultStyle.footnote,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'caption1',
      caption1,
      defaultValue: defaultStyle.caption1,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'caption2',
      caption2,
      defaultValue: defaultStyle.caption2,
    ));
  }

  @override
  List<Object?> get props => [
        body,
        callout,
        caption1,
        caption2,
        footnote,
        headline,
        largeTitle,
        subheadline,
        title1,
        title2,
        title3,
      ];
}

/// The thickness of the glyphs used to draw the text.
///
/// Implements [FontWeight] in order to provide the following custom weight
/// values that Apple use in some of their text styles:
/// * [w510]
/// * [w590]
/// * [w860]
///
/// Reference:
/// * [macOS Sonoma Figma Kit](https://www.figma.com/file/IX6ph2VWrJiRoMTI1Byz0K/Apple-Design-Resources---macOS-(Community)?node-id=0%3A1745&mode=dev)
class MacosFontWeight implements FontWeight {
  const MacosFontWeight._(this.index, this.value);

  /// The encoded integer value of this font weight.
  @override
  final int index;

  /// The thickness value of this font weight.
  @override
  final int value;

  /// Thin, the least thick
  static const MacosFontWeight w100 = MacosFontWeight._(0, 100);

  /// Extra-light
  static const MacosFontWeight w200 = MacosFontWeight._(1, 200);

  /// Light
  static const MacosFontWeight w300 = MacosFontWeight._(2, 300);

  /// Normal / regular / plain
  static const MacosFontWeight w400 = MacosFontWeight._(3, 400);

  /// Medium
  static const MacosFontWeight w500 = MacosFontWeight._(4, 500);

  /// An Apple-specific font weight.
  ///
  /// When [MacosTypography.caption1] needs to be bolded, use this value.
  static const MacosFontWeight w510 = MacosFontWeight._(5, 510);

  /// An Apple-specific font weight.
  ///
  /// When [MacosTypography.body], [MacosTypography.callout],
  /// [MacosTypography.subheadline], [MacosTypography.footnote], or
  /// [MacosTypography.caption2] need to be bolded, use this value.
  static const MacosFontWeight w590 = MacosFontWeight._(6, 590);

  /// Semi-bold
  static const MacosFontWeight w600 = MacosFontWeight._(7, 600);

  /// Bold
  static const MacosFontWeight w700 = MacosFontWeight._(8, 700);

  /// Extra-bold
  static const MacosFontWeight w800 = MacosFontWeight._(9, 800);

  /// An Apple-specific font weight.
  ///
  /// When [MacosTypography.title3] needs to be bolded, use this value.
  static const MacosFontWeight w860 = MacosFontWeight._(10, 860);

  /// Black, the most thick
  static const MacosFontWeight w900 = MacosFontWeight._(11, 900);

  /// The default font weight.
  static const MacosFontWeight normal = w400;

  /// A commonly used font weight that is heavier than normal.
  static const MacosFontWeight bold = w700;

  /// A list of all the font weights.
  static const List<MacosFontWeight> values = <MacosFontWeight>[
    w100,
    w200,
    w300,
    w400,
    w500,
    w510,
    w590,
    w600,
    w700,
    w800,
    w860,
    w900,
  ];

  /// Linearly interpolates between two font weights.
  ///
  /// Rather than using fractional weights, the interpolation rounds to the
  /// nearest weight.
  ///
  /// If both `a` and `b` are null, then this method will return null. Otherwise,
  /// any null values for `a` or `b` are interpreted as equivalent to [normal]
  /// (also known as [w400]).
  ///
  /// The `t` argument represents position on the timeline, with 0.0 meaning
  /// that the interpolation has not started, returning `a` (or something
  /// equivalent to `a`), 1.0 meaning that the interpolation has finished,
  /// returning `b` (or something equivalent to `b`), and values in between
  /// meaning that the interpolation is at the relevant point on the timeline
  /// between `a` and `b`. The interpolation can be extrapolated beyond 0.0 and
  /// 1.0, so negative values and values greater than 1.0 are valid (and can
  /// easily be generated by curves such as [Curves.elasticInOut]). The result
  /// is clamped to the range [w100]–[w900].
  ///
  /// Values for `t` are usually obtained from an [Animation<double>], such as
  /// an [AnimationController].
  static MacosFontWeight? lerp(
    MacosFontWeight? a,
    MacosFontWeight? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return values[_lerpInt((a ?? normal).index, (b ?? normal).index, t)
        .round()
        .clamp(0, 8)];
  }

  @override
  String toString() {
    return const <int, String>{
      0: 'MacosFontWeight.w100',
      1: 'MacosFontWeight.w200',
      2: 'MacosFontWeight.w300',
      3: 'MacosFontWeight.w400',
      4: 'MacosFontWeight.w500',
      5: 'MacosFontWeight.w510',
      6: 'MacosFontWeight.w590',
      7: 'MacosFontWeight.w600',
      8: 'MacosFontWeight.w700',
      9: 'MacosFontWeight.w800',
      10: 'MacosFontWeight.w860',
      11: 'MacosFontWeight.w900',
    }[index]!;
  }
}

/// Linearly interpolate between two integers.
///
/// Same as [lerpDouble] but specialized for non-null `int` type.
double _lerpInt(int a, int b, double t) {
  return a + (b - a) * t;
}
