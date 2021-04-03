import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/painting.dart';

/// Defines macOS text styling.
///
/// todo: More documentation
/// todo: Figure out how to implement leading (see guidelines)
///
/// https://developer.apple.com/design/human-interface-guidelines/macos/visual-design/typography/
class Typography with Diagnosticable {
  const Typography({
    this.largeTitle,
    this.title1,
    this.title2,
    this.title3,
    this.headline,
    this.subheadline,
    this.body,
    this.callout,
    this.footnote,
    this.caption1,
    this.caption2,
  });

  /// Style used for body text.
  final TextStyle? body;

  /// Style used for callouts.
  final TextStyle? callout;

  /// Style used for standard captions.
  final TextStyle? caption1;

  /// Style used for alternate captions.
  final TextStyle? caption2;

  /// Style used in footnotes
  final TextStyle? footnote;

  /// Style used for headings.
  final TextStyle? headline;

  /// Style used for large titles.
  final TextStyle? largeTitle;

  /// Style used for subheadings.
  final TextStyle? subheadline;

  /// Style used for first-level hierarchical headings.
  final TextStyle? title1;

  /// Style used for second-level hierarchical headings.
  final TextStyle? title2;

  /// Style used for third-level hierarchical headings.
  final TextStyle? title3;

  /// Provides the default macOS Typography.
  ///
  /// Font sizes, weights, line heights, and emphasized weights (??) are defined
  /// at https://developer.apple.com/design/human-interface-guidelines/macos/visual-design/typography/
  static Typography defaultTypography({
    required Brightness brightness,
    Color? color,
  }) {
    color ??= brightness == Brightness.light ? Colors.black : Colors.white;
    return Typography(
      largeTitle: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 26,
        height: 32,
        color: color,
      ),
      title1: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 22,
        height: 26,
        color: color,
      ),
      title2: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 17,
        height: 22,
        color: color,
      ),
      title3: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 15,
        height: 20,
        color: color,
      ),
      headline: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontWeight: FontWeight.bold,
        fontSize: 13,
        height: 16,
        color: color,
      ),
      subheadline: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 11,
        height: 14,
        color: color,
      ),
      body: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 13,
        height: 16,
        color: color,
      ),
      callout: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 12,
        height: 15,
        color: color,
      ),
      footnote: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 10,
        height: 13,
        color: color,
      ),
      caption1: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 10,
        height: 13,
        color: color,
      ),
      caption2: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 10,
        height: 13,
        color: color,
      ),
    );
  }

  /// Returns the default Typography along with customized properties.
  Typography copyWith(Typography? typography) {
    if (typography == null) return this;
    return Typography(
      largeTitle: typography.largeTitle ?? largeTitle,
      title1: typography.title1 ?? title1,
      title2: typography.title2 ?? title2,
      title3: typography.title3 ?? title3,
      headline: typography.headline ?? headline,
      subheadline: typography.subheadline ?? subheadline,
      body: typography.body ?? body,
      callout: typography.callout ?? callout,
      footnote: typography.footnote ?? footnote,
      caption1: typography.caption1 ?? caption1,
      caption2: typography.caption2 ?? caption2,
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
