import 'package:macos_ui/src/library.dart';

/// An immutable 32 bit color value in ARGB format.
class MacosColor extends Color {
  /// Construct a color from the lower 32 bits of an [int].
  const MacosColor(super.value);

  /// Construct a color from the lower 8 bits of four integers.
  ///
  /// * `a` is the alpha value, with 0 being transparent and 255 being fully
  ///   opaque.
  /// * `r` is [red], from 0 to 255.
  /// * `g` is [green], from 0 to 255.
  /// * `b` is [blue], from 0 to 255.
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
  /// * `r` is [red], from 0 to 255.
  /// * `g` is [green], from 0 to 255.
  /// * `b` is [blue], from 0 to 255.
  /// * `opacity` is alpha channel of this color as a double, with 0.0 being
  ///   transparent and 1.0 being fully opaque.
  ///
  /// Out of range values are brought into range using modulo 255.
  ///
  /// See also [fromARGB], which takes the opacity as an integer value.
  const MacosColor.fromRGBO(super.r, super.g, super.b, super.opcacity)
      : super.fromRGBO();

  /// Linearly interpolate between two [MacosColor]s.
  static MacosColor lerp(MacosColor? a, MacosColor? b, double t) {
    final Color? color = Color.lerp(a, b, t);
    return MacosColor(color!.value);
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
    final int alpha = foreground.alpha;
    if (alpha == 0x00) {
      // Foreground completely transparent.
      return background;
    }
    final int invAlpha = 0xff - alpha;
    int backAlpha = background.alpha;
    if (backAlpha == 0xff) {
      // Opaque background case
      return MacosColor.fromARGB(
        0xff,
        (alpha * foreground.red + invAlpha * background.red) ~/ 0xff,
        (alpha * foreground.green + invAlpha * background.green) ~/ 0xff,
        (alpha * foreground.blue + invAlpha * background.blue) ~/ 0xff,
      );
    } else {
      // General case
      backAlpha = (backAlpha * invAlpha) ~/ 0xff;
      final int outAlpha = alpha + backAlpha;
      assert(outAlpha != 0x00);
      return MacosColor.fromARGB(
        outAlpha,
        (foreground.red * alpha + background.red * backAlpha) ~/ outAlpha,
        (foreground.green * alpha + background.green * backAlpha) ~/ outAlpha,
        (foreground.blue * alpha + background.blue * backAlpha) ~/ outAlpha,
      );
    }
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
    return MacosColor.fromARGB(a, red, green, blue);
  }

  /// Darkens a [MacosColor] by a [percent] amount (100 = black) without
  /// changing the tint of the color.
  static MacosColor darken(MacosColor c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return MacosColor.fromARGB(
      c.alpha,
      (c.red * f).round(),
      (c.green * f).round(),
      (c.blue * f).round(),
    );
  }

  /// Lightens a [MacosColor] by a [percent] amount (100 = white) without
  /// changing the tint of the color
  static MacosColor lighten(MacosColor c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return MacosColor.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round(),
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
    return other is MacosColor && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'MacosColor(0x${value.toRadixString(16).padLeft(8, '0')})';
  }
}

extension ColorX on Color {
  /// Returns a [MacosColor] with the same color values as this [Color].
  MacosColor toMacosColor() {
    return MacosColor(value);
  }
}

/// A collection of color values lifted from the macOS system color picker.
class MacosColors {
  /// A fully transparent color.
  static const transparent = MacosColor(0x00000000);

  /// A fully opaque black color.
  static const black = MacosColor(0xFF000000);

  /// A fully opaque white color.
  static const white = MacosColor(0xFFFFFFFF);

  static const systemRedColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(255, 59, 48, 1.0),
    darkColor: MacosColor.fromRGBO(255, 69, 58, 1.0),
  );

  static const systemOrangeColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xFFFF9500),
    darkColor: MacosColor(0xFFFF9F0A),
  );

  static const systemYellowColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xFFFFCC00),
    darkColor: MacosColor(0xFFFFD60A),
  );

  static const systemGreenColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(40, 205, 65, 1.0),
    darkColor: MacosColor(0xFF32D74B),
  );

  static const systemMintColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xFF00C7bE),
    darkColor: MacosColor.fromRGBO(102, 212, 207, 1.0),
  );

  static const systemTealColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(89, 173, 196, 1.0),
    darkColor: MacosColor(0xFF64D2FF),
  );

  static const systemCyanColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xFF55BEF0),
    darkColor: MacosColor.fromRGBO(90, 200, 245, 1.0),
  );

  static const systemBlueColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xFF007AFF),
    darkColor: MacosColor(0xFF0A84FF),
  );

  static const systemIndigoColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xFF5856D6),
    darkColor: MacosColor(0xFF5E5CE6),
  );

  static const systemPurpleColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xFFAF52DE),
    darkColor: MacosColor(0xFFBF5AF2),
  );

  static const systemPinkColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xFFFF2D55),
    darkColor: MacosColor(0xFFFF375F),
  );

  static const systemBrownColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xFFA2845E),
    darkColor: MacosColor(0xFFAC8E68),
  );

  static const systemGrayColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xFF8E8E93),
    darkColor: MacosColor(0xFF98989D),
  );

  /// The text on a selected surface in a list or table.
  static const alternateSelectedControlTextColor = MacosColors.white;

  /// The backgrounds of alternating rows or columns in a list, table, or
  /// collection view.
  static const alternatingContentBackgroundColor =
      CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(245, 245, 245, 1.0),
    darkColor: MacosColor.fromRGBO(255, 255, 255, 0.05),
  );

  /// The accent color selected by the user in system preferences.
  ///
  /// No dark variant.
  static const controlAccentColor = MacosColor.fromRGBO(0, 122, 255, 1);

  /// The surface of a control.
  static const controlColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(0, 0, 0, 0.1),
    darkColor: MacosColor.fromRGBO(255, 255, 255, 0.25),
  );

  /// The background of a large interface element, such as a browser or table.
  static const controlBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: MacosColors.white,
    darkColor: MacosColor.fromRGBO(30, 30, 30, 1.0),
  );

  /// The text of a control that isn’t disabled.
  static const controlTextColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(0, 0, 0, 0.85),
    darkColor: MacosColor(0xFFDDDDDE),
  );

  /// The text of a control that’s disabled.
  static const disabledControlTextColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(0, 0, 0, 0.25),
    darkColor: MacosColor.fromRGBO(255, 255, 255, 0.25),
  );

  /// The color of a find indicator.
  ///
  /// Has no dark variant.
  static const findHighlightColor = MacosColor(0xFFFFFF00);

  ///	The gridlines of an interface element such as a table.
  static const gridColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xFFE6E6E6),
    darkColor: MacosColor(0xFF1A1A1A),
  );

  ///	The text of a header cell in a table.
  static const headerTextColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(0, 0, 0, 0.85),
    darkColor: MacosColors.white,
  );

  /// The ring that appears around the currently focused control when using
  /// the keyboard for interface navigation.
  static const keyboardFocusIndicatorColor =
      CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(0, 103, 244, 0.5),
    darkColor: MacosColor.fromRGBO(26, 169, 255, 0.5),
  );

  /// The text of a label containing primary content.
  static const labelColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(0, 0, 0, 0.85),
    darkColor: MacosColor.fromRGBO(255, 255, 255, 0.85),
  );

  /// A link to other content.
  static const linkColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xFF0068DA),
    darkColor: MacosColor(0xFF419CFF),
  );

  /// A placeholder string in a control or text view.
  static const placeholderTextColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(0, 0, 0, 0.25),
    darkColor: MacosColor.fromRGBO(255, 255, 255, 0.25),
  );

  /// The text of a label of lesser importance than a tertiary label such as
  /// watermark text.
  static const quaternaryLabelColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(0, 0, 0, 0.1),
    darkColor: MacosColor.fromRGBO(255, 255, 255, 0.1),
  );

  /// The text of a label of lesser importance than a primary label, such as
  /// a label used to represent a subheading or additional information.
  static const secondaryLabelColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(0, 0, 0, 0.5),
    darkColor: MacosColor.fromRGBO(255, 255, 255, 0.55),
  );

  /// The surface of a selected control.
  static const selectedContentBackgroundColor =
      CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(0, 99, 255, 1),
    darkColor: MacosColor.fromRGBO(0, 88, 208, 1),
  );

  /// The surface of a selected control.
  static const selectedControlColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(179, 215, 255, 1),
    darkColor: MacosColor.fromRGBO(63, 99, 139, 1),
  );

  /// The text of a selected control.
  static const selectedControlTextColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(0, 0, 0, 0.85),
    darkColor: MacosColor.fromRGBO(255, 255, 255, 0.85),
  );

  /// The text of a selected menu.
  static const selectedMenuItemTextColor = MacosColors.white;

  ///	The background of selected text.
  static const selectedTextBackgroundColor =
      CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(179, 215, 255, 1.0),
    darkColor: MacosColor.fromRGBO(63, 99, 139, 1.0),
  );

  ///	Selected text.
  static const selectedTextColor = CupertinoDynamicColor.withBrightness(
    color: MacosColors.black,
    darkColor: MacosColors.white,
  );

  ///	A separator between different sections of content.
  static const separatorColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(225, 225, 225, 1.0),
    darkColor: MacosColor.fromRGBO(65, 65, 65, 1.0),
  );

  /// The text of a label of lesser importance than a secondary label such as
  /// a label used to represent disabled text.
  static const tertiaryLabelColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(0, 0, 0, 0.26),
    darkColor: MacosColor.fromRGBO(255, 255, 255, 0.25),
  );

  ///	Text background.
  static const textBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: MacosColors.white,
    darkColor: MacosColor(0xFF1E1E1E),
  );

  ///	The text in a document.
  static const textColor = CupertinoDynamicColor.withBrightness(
    color: MacosColors.black,
    darkColor: MacosColors.white,
  );

  /// The background behind a document's content.
  static const underPageBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(150, 150, 150, 0.9),
    darkColor: MacosColor(0xFF282828),
  );

  /// The selected content in a non-key window or view.
  static const unemphasizedSelectedContentBackgroundColor =
      CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xFFDCDCDC),
    darkColor: MacosColor(0xFF464646),
  );

  /// A background for selected text in a non-key window or view.
  static const unemphasizedSelectedTextBackgroundColor =
      CupertinoDynamicColor.withBrightness(
    color: MacosColor(0xFFDCDCDC),
    darkColor: MacosColor(0xFF464646),
  );

  /// Selected text in a non-key window or view.
  static const unemphasizedSelectedTextColor =
      CupertinoDynamicColor.withBrightness(
    color: MacosColors.black,
    darkColor: MacosColors.white,
  );

  /// The color to use for the window background.
  /*FIXME: These values are not correct - they are the values that the Digital
     Color Meter application shows, but aren't correct due to the translucency
     effect of macOS applications. The CORRECT values are commented below,
     but cannot be turned on yet due to the unknown default value of the
     translucency effect.*/
  static const windowBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(236, 236, 236, 1.0),
    darkColor: MacosColor.fromRGBO(50, 50, 50, 1.0),
  );

  static const scaffoldBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(246, 246, 246, 1.0),
    darkColor: MacosColor.fromRGBO(40, 40, 40, 1.0),
  );

  /// The color of text in the window’s title bar area.
  static const windowFrameTextColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(0, 0, 0, 0.85),
    darkColor: MacosColor.fromRGBO(255, 255, 255, 0.85),
  );

  static const appleBlue = MacosColor(0xFF0433FF);
  static const appleBrown = MacosColor(0xFFAA7942);
  static const appleCyan = MacosColor(0xFF00FDFF);
  static const appleGreen = MacosColor(0xFF00F900);
  static const appleMagenta = MacosColor(0xFFFF40FF);
  static const appleOrange = MacosColor(0xFFFF9300);
  static const applePurple = MacosColor(0xFF0942192);
  static const appleRed = MacosColor(0xFFFF2600);
  static const appleYellow = MacosColor(0xFFFFFB00);

  /// The color of the thumb of [MacosSlider].
  static const sliderThumbColor = CupertinoDynamicColor.withBrightness(
    color: MacosColors.white,
    darkColor: MacosColor.fromRGBO(152, 152, 157, 1),
  );

  /// The color of the tick marks which are not selected (the portion to the right of the thumb) of [MacosSlider].
  static const tickBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(220, 220, 220, 1),
    darkColor: MacosColor.fromRGBO(70, 70, 70, 1),
  );

  /// The color of the slider in [MacosSlider] which is not selected (the portion
  /// to the right of the thumb).
  static const sliderBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: MacosColor.fromRGBO(0, 0, 0, 0.1),
    darkColor: MacosColor.fromRGBO(255, 255, 255, 0.1),
  );
}
