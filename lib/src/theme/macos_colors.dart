import 'dart:ui';

/// An immutable 32 bit color value in ARGB format.
class MacosColor extends Color {
  /// Construct a color from the lower 32 bits of an [int].
  const MacosColor(int value) : super(value);

  /// Linearly interpolate between two [MacosColor]s.
  static MacosColor lerp(MacosColor a, MacosColor b, double t) {
    final Color? color = Color.lerp(a, b, t);
    return MacosColor(color!.value);
  }
}

/// A collection of color values lifted from the macOS system color picker.
class MacosColors {
  static const Color transparent = MacosColor(0x00000000);
  static const black = MacosColor(0xff000000);
  static const white = MacosColor(0xffffffff);
  static const labelColor = MacosColors.white;
  static const secondaryLabelColor = MacosColor(0xff9c9b9e);
  static const tertiaryLabelColor = MacosColor(0xff5a585c);
  static const quaternaryLabelColor = MacosColor(0xff39373c);
  static const systemRedColor = MacosColor(0xffff453a);
  static const systemGreenColor = MacosColor(0xff32d74b);
  static const systemBlueColor = MacosColor(0xff0a84ff);
  static const systemOrangeColor = MacosColor(0xffff9f0a);
  static const systemYellowColor = MacosColor(0xffffd60a);
  static const systemBrownColor = MacosColor(0xffac8e68);
  static const systemPinkColor = MacosColor(0xffff375f);
  static const systemPurpleColor = MacosColor(0xffbf5af2);
  static const systemTealColor = MacosColor(0xff5ac8f5);
  static const systemIndigoColor = MacosColor(0xff5e5ce6);
  static const systemGrayColor = MacosColor(0xff9c9b9e);
  static const linkColor = MacosColor(0xff419cff);
  static const placeholderTextColor = MacosColor(0xff737473);
  static const windowFrameColor = MacosColor(0xffddddde);
  static const selectedMenuItemTextColor = MacosColor(0xfffeffff);
  static const alternateSelectedControlTextColor = MacosColors.white;
  static const headerTextColor = MacosColors.white;
  static const separatorColor = MacosColor(0xff39373c);
  static const gridColor = MacosColor(0xff39373c);
  static const textColor = MacosColors.white;
  static const textBackgroundColor = MacosColor(0xff1e1e1e);
  static const selectedTextColor = MacosColors.white;
  static const selectedTextBackgroundColor = MacosColor(0xff3f638b);
  static const unemphasizedSelectedTextBackgroundColor = MacosColor(0xff464646);
  static const unemphasizedSelectedTextColor = MacosColors.white;
  static const windowBackgroundColor = MacosColor(0xff3b373d);
  static const underPageBackgroundColor = MacosColor(0xff282828);
  static const controlBackgroundColor = MacosColor(0xff1e1e1e);
  static const selectedControlBackgroundColor = MacosColor(0xff0058d0);
  static const unemphasizedSelectedContentBackgroundColor =
      MacosColor(0xff464646);
  static const alternatingContentBackgroundColor = MacosColor(0xff2e2c31);
  static const findHighlightColor = MacosColor(0xffffff00);
  static const controlColor = MacosColor(0xff5a585c);
  static const controlTextColor = MacosColor(0xffddddde);
  static const selectedControlColor = MacosColor(0xffddddde);
  static const selectedControlTextColor = MacosColor(0xffddddde);
  static const disabledControlColor = MacosColor(0xff5a585c);
  static const keyboardFocusIndicatorColor = MacosColor(0xff294a69);
  static const controlAccentColor = MacosColor(0xff007aff);
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
