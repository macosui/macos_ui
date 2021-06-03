import 'dart:ui';

import 'package:macos_ui/src/library.dart';

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
    color: MacosColor(0xffFFFFFF),
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
