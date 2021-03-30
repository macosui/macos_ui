import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/painting.dart';

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

  final TextStyle? largeTitle;
  final TextStyle? title1;
  final TextStyle? title2;
  final TextStyle? title3;
  final TextStyle? headline;
  final TextStyle? subheadline;
  final TextStyle? body;
  final TextStyle? callout;
  final TextStyle? footnote;
  final TextStyle? caption1;
  final TextStyle? caption2;

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
      ),
      title1: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 22,
        height: 26,
      ),
      title2: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 17,
        height: 22,
      ),
      title3: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 15,
        height: 20,
      ),
      headline: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontWeight: FontWeight.bold,
        fontSize: 13,
        height: 16,
      ),
      subheadline: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 11,
        height: 14,
      ),
      body: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 13,
        height: 16,
      ),
      callout: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 12,
        height: 15,
      ),
      footnote: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 10,
        height: 13,
      ),
      caption1: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 10,
        height: 13,
      ),
      caption2: TextStyle(
        fontFamily: 'SanFranciscoPro',
        fontSize: 10,
        height: 13,
      ),
    );
  }

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
  }
}
