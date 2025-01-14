import 'package:macos_ui/src/library.dart';

/// An immutable 32 bit color value in ARGB format.
class MacosColor extends Color {
  /// Construct a color from the lower 32 bits of an [int].
  const MacosColor(super.value);

  /// Construct a color from the lower 8 bits of four integers.
  ///
  /// * `a` is the alpha value, with 0 being transparent and 255 being fully
  ///   opaque.
  /// * `r` is red, from 0 to 255.
  /// * `g` is green, from 0 to 255.
  /// * `b` is blue, from 0 to 255.
  ///
  /// Out of range values are brought into range using modulo 255.
  ///
  /// See also [fromRGBO], which takes the alpha value as a floating point
  /// value.
  const MacosColor.fromARGB(super.a, super.r, super.g, super.b)
      : super.fromARGB();

  /// Create a color from red, green, blue, and opacity, similar to `rgba()`
  /// in CSS.
  ///
  /// * `r` is red, from 0 to 255.
  /// * `g` is green, from 0 to 255.
  /// * `b` is blue, from 0 to 255.
  /// * `opacity` is alpha channel of this color as a double, with 0.0 being
  ///   transparent and 1.0 being fully opaque.
  ///
  /// Out of range values are brought into range using modulo 255.
  ///
  /// See also [fromARGB], which takes the opacity as an integer value.
  const MacosColor.fromRGBO(super.r, super.g, super.b, super.opacity)
      : super.fromRGBO();

  /// Linearly interpolate between two [MacosColor]s.
  static MacosColor lerp(MacosColor a, MacosColor b, double t) {
    final Color? color = Color.lerp(a, b, t);
    return MacosColor.fromRGBO(
      (color!.r * 255).toInt(),
      (color.g * 255).toInt(),
      (color.b * 255).toInt(),
      color.a,
    );
  }

  /// Combine the foreground color as a transparent color over top
  /// of a background color, and return the resulting combined color.
  ///
  /// This uses standard alpha blending ("SRC over DST") rules to produce a
  /// blended color from two colors. This can be used as a performance
  /// enhancement when trying to avoid needless alpha blending compositing
  /// operations for two things that are solid colors with the same shape, but
  /// overlay each other: instead, just paint one with the combined color.
  static MacosColor alphaBlend(MacosColor foreground, MacosColor background) {
    final newColor = Color.alphaBlend(foreground, background);

    return MacosColor.fromRGBO(
      (newColor.r * 255).toInt(),
      (newColor.g * 255).toInt(),
      (newColor.b * 255).toInt(),
      newColor.a,
    );
  }

  /// Returns an alpha value representative of the provided [opacity] value.
  ///
  /// The [opacity] value may not be null.
  static int getAlphaFromOpacity(double opacity) {
    return (opacity.clamp(0.0, 1.0) * 255).round();
  }

  /// Returns a new color that matches this color with the alpha channel
  /// replaced with the given `opacity` (which ranges from 0.0 to 1.0).
  ///
  /// Out of range values will have unexpected effects.
  @override
  MacosColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((255.0 * opacity).round());
  }

  /// Returns a new color that matches this color with the alpha channel
  /// replaced with `a` (which ranges from 0 to 255).
  ///
  /// Out of range values will have unexpected effects.
  @override
  MacosColor withAlpha(int a) {
    return MacosColor.fromARGB(
      a,
      (r * 255).toInt(),
      (g * 255).toInt(),
      (b * 255).toInt(),
    );
  }

  /// Darkens a [MacosColor] by a [percent] amount (100 = black) without
  /// changing the tint of the color.
  static MacosColor darken(MacosColor c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return MacosColor.fromRGBO(
      (c.r * f * 255).round(),
      (c.g * f * 255).round(),
      (c.b * f * 255).round(),
      c.a,
    );
  }

  /// Lightens a [MacosColor] by a [percent] amount (100 = white) without
  /// changing the tint of the color
  static MacosColor lighten(MacosColor c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return MacosColor.fromRGBO(
      (c.r + ((1.0 - c.r) * p) * 255).toInt(),
      (c.g + ((1.0 - c.g) * p) * 255).toInt(),
      (c.b + ((1.0 - c.b) * p) * 255).toInt(),
      c.a,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MacosColor && other.hashCode == hashCode;
  }

  @override
  int get hashCode => Object.hash(r, g, b, a);

  @override
  String toString() =>
      'MacosColor(alpha: ${a.toStringAsFixed(4)}, red: ${r.toStringAsFixed(4)}, green: ${g.toStringAsFixed(4)}, blue: ${b.toStringAsFixed(4)}, colorSpace: $colorSpace)';
}

extension ColorX on Color {
  /// Returns a [MacosColor] with the same color values as this [Color].
  MacosColor toMacosColor() {
    return MacosColor.fromRGBO(
      (r * 255).floor(),
      (g * 255).floor(),
      (b * 255).floor(),
      a,
    );
  }
}

/// A collection of color values lifted from the macOS system color picker.
class MacosColors {
  /// A fully transparent color.
  static const Color transparent = MacosColor(0x00000000);

  /// A fully opaque black color.
  static const black = MacosColor(0xff000000);

  /// A fully opaque white color.
  static const white = MacosColor(0xffffffff);

  /// The text of a label containing primary content.
  static const labelColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.85),
    darkColor: Color.fromRGBO(255, 255, 255, 0.85),
  );

  /// The text of a label of lesser importance than a primary label, such as
  /// a label used to represent a subheading or additional information.
  static const secondaryLabelColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.5),
    darkColor: Color.fromRGBO(255, 255, 255, 0.55),
  );

  /// The text of a label of lesser importance than a secondary label such as
  /// a label used to represent disabled text.
  static const tertiaryLabelColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.26),
    darkColor: Color.fromRGBO(255, 255, 255, 0.26),
  );

  /// The text of a label of lesser importance than a tertiary label such as
  /// watermark text.
  static const quaternaryLabelColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    darkColor: Color.fromRGBO(255, 255, 255, 0.1),
  );

  static const systemRedColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xffFF3B30),
    darkColor: MacosColor(0xffFF453A),
  );

  static const systemGreenColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xff34C759),
    darkColor: MacosColor(0xff30D158),
  );

  static const systemBlueColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xff007AFF),
    darkColor: MacosColor(0xff0A84FF),
  );

  static const systemOrangeColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xffFF9500),
    darkColor: MacosColor(0xffFF9F0A),
  );

  static const systemYellowColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xffFF9F0A),
    darkColor: MacosColor(0xffFFD60A),
  );

  static const systemBrownColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xffA2845E),
    darkColor: MacosColor(0xffAC8E68),
  );

  static const systemPinkColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xffFF2D55),
    darkColor: MacosColor(0xffFF375F),
  );

  static const systemPurpleColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xffAF52DE),
    darkColor: MacosColor(0xffBF5AF2),
  );

  static const systemTealColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xff55BEF0),
    darkColor: MacosColor(0xff5AC8F5),
  );

  static const systemIndigoColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xff5856D6),
    darkColor: MacosColor(0xff5E5CE6),
  );

  static const systemGrayColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xff8E8E93),
    darkColor: MacosColor(0xff98989D),
  );

  /// A link to other content.
  static const linkColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xff0068DA),
    darkColor: Color.fromRGBO(65, 156, 255, 1),
  );

  /// A placeholder string in a control or text view.
  static const placeholderTextColor = MacosColor(0xff737473);

  static const windowFrameColor = MacosColor(0xffddddde);

  /// The text of a selected menu.
  static const selectedMenuItemTextColor = MacosColor(0xfffeffff);

  /// The text on a selected surface in a list or table.
  static const alternateSelectedControlTextColor = MacosColors.white;

  ///	The text of a header cell in a table.
  static const headerTextColor = MacosColors.white;

  ///	A separator between different sections of content.
  static const separatorColor = MacosColor(0xff39373c);

  ///	The gridlines of an interface element such as a table.
  static const gridColor = MacosColor(0xff39373c);

  ///	The text in a document.
  static const textColor = MacosColors.white;

  ///	Text background.
  static const textBackgroundColor = MacosColor(0xff1e1e1e);

  ///	Selected text.
  static const selectedTextColor = MacosColors.white;

  ///	The background of selected text.
  static const selectedTextBackgroundColor = MacosColor(0xff3f638b);

  /// A background for selected text in a non-key window or view.
  static const unemphasizedSelectedTextBackgroundColor =
      CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xffDCDCDC),
    darkColor: MacosColor(0xff464646),
  );

  /// Selected text in a non-key window or view.
  static const unemphasizedSelectedTextColor = MacosColors.white;

  /// The background of a window.
  static const windowBackgroundColor = MacosColor(0xff3b373d);

  /// The background behind a document's content.
  static const underPageBackgroundColor = MacosColor(0xff282828);

  /// The background of a large interface element, such as a browser or table.
  static const controlBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xffFFFFFF),
    darkColor: MacosColor(0xff1E1E1E),
  );

  static const selectedControlBackgroundColor = MacosColor(0xff0058d0);

  /// The selected content in a non-key window or view.
  static const unemphasizedSelectedContentBackgroundColor =
      MacosColor(0xff464646);

  static const alternatingContentBackgroundColor = MacosColor(0xff2e2c31);

  /// The color of a find indicator.
  ///
  /// Has no dark variant.
  static const findHighlightColor = MacosColor(0xffffff00);

  /// The surface of a control.
  static const controlColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    darkColor: Color.fromRGBO(255, 255, 255, 0.25),
  );

  /// The text of a control that isn’t disabled.
  static const controlTextColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.85),
    darkColor: MacosColor(0xffddddde),
  );

  /// The text of a control that’s disabled.
  static const disabledControlTextColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.25),
    darkColor: Color.fromRGBO(255, 255, 255, 0.25),
  );

  /// The surface of a selected control.
  static const selectedControlColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(179, 215, 255, 1),
    darkColor: Color.fromRGBO(63, 99, 139, 1),
  );

  /// The text of a selected control.
  static const selectedControlTextColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xffddddde),
    darkColor: MacosColor(0xff5a585c),
  );

  /// The ring that appears around the currently focused control when using
  /// the keyboard for interface navigation.
  static const keyboardFocusIndicatorColor =
      CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 103, 244, 0.25),
    darkColor: Color.fromRGBO(26, 169, 255, 0.3),
  );

  /// The color of the thumb of [MacosSlider].
  static const sliderThumbColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(255, 255, 255, 1),
    darkColor: Color.fromRGBO(152, 152, 157, 1),
  );

  /// The color of the tick marks which are not selected (the portion to the right of the thumb) of [MacosSlider].
  static const tickBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(220, 220, 220, 1),
    darkColor: Color.fromRGBO(70, 70, 70, 1),
  );

  /// The color of the slider in [MacosSlider] which is not selected (the portion
  /// to the right of the thumb).
  static const sliderBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    darkColor: Color.fromRGBO(255, 255, 255, 0.1),
  );

  /// The accent color selected by the user in system preferences.
  ///
  /// No dark variant.
  static const controlAccentColor = Color.fromRGBO(0, 122, 255, 1);

  static const appleBlue = MacosColor(0xff0433ff);
  static const appleBrown = MacosColor(0xffaa7942);
  static const appleCyan = MacosColor(0xff00fdff);
  static const appleGreen = MacosColor(0xff00f900);
  static const appleMagenta = MacosColor(0xffff40ff);
  static const appleOrange = MacosColor(0xffff9300);
  static const applePurple = MacosColor(0xff0942192);
  static const appleRed = MacosColor(0xffff2600);
  static const appleYellow = MacosColor(0xfffffb00);
}
