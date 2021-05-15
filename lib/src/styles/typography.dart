import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/painting.dart';

const _kDefaultFontFamily = 'SanFranciscoPro';

/// Defines macOS text styling.
///
/// TODO: More documentation
/// TODO: Figure out how to implement leading (see guidelines)
///
/// https://developer.apple.com/design/human-interface-guidelines/macos/visual-design/typography/
@immutable
class Typography with Diagnosticable {
  factory Typography({
    required Brightness brightness,
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
    final color = brightness == Brightness.light ? Colors.black : Colors.white;
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
      fontWeight: FontWeight.w400,
      fontSize: 13,
      letterSpacing: -0.08,
      color: color,
    );
    subheadline ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 11,
      letterSpacing: 0.06,
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
      fontWeight: FontWeight.w400,
      fontSize: 10,
      letterSpacing: 0.12,
      color: color,
    );
    return Typography.raw(
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

  const Typography.raw({
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

  /// Linearly interpolate between two typographys.
  static Typography lerp(Typography a, Typography b, double t) {
    return Typography.raw(
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('largeTitle', largeTitle));
    properties.add(DiagnosticsProperty<TextStyle>('title1', title1));
    properties.add(DiagnosticsProperty<TextStyle>('title2', title2));
    properties.add(DiagnosticsProperty<TextStyle>('title3', title3));
    properties.add(DiagnosticsProperty<TextStyle>('headline', headline));
    properties.add(DiagnosticsProperty<TextStyle>('subheadline', subheadline));
    properties.add(DiagnosticsProperty<TextStyle>('body', body));
    properties.add(DiagnosticsProperty<TextStyle>('callout', callout));
    properties.add(DiagnosticsProperty<TextStyle>('footnote', footnote));
    properties.add(DiagnosticsProperty<TextStyle>('caption1', caption1));
    properties.add(DiagnosticsProperty<TextStyle>('caption2', caption2));
  }
}
