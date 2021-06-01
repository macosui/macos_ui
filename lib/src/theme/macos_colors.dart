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

  /// The text of a label containing primary content.
  static const labelColor = Color.fromRGBO(0, 0, 0, 0.85);
  static const labelColorDark = Color.fromRGBO(255, 255, 255, 0.85);

  /// The text of a label of lesser importance than a primary label, such as
  /// a label used to represent a subheading or additional information.
  static const secondaryLabelColor = Color.fromRGBO(0, 0, 0, 0.5);
  static const secondaryLabelColorDark = Color.fromRGBO(255, 255, 255, 0.55);

  /// The text of a label of lesser importance than a secondary label such as
  /// a label used to represent disabled text.
  static const tertiaryLabelColor = Color.fromRGBO(0, 0, 0, 0.26);
  static const tertiaryLabelColorDark = Color.fromRGBO(255, 255, 255, 0.26);

  /// The text of a label of lesser importance than a tertiary label such as
  /// watermark text.
  static const quaternaryLabelColor = Color.fromRGBO(0, 0, 0, 0.1);
  static const quaternaryLabelColorDark = Color.fromRGBO(255, 255, 255, 0.1);

  static const systemRedColor = MacosColor(0xffFF3B30);
  static const systemRedColorDark = MacosColor(0xffFF453A);

  static const systemGreenColor = MacosColor(0xff34C759);
  static const systemGreenColorDark = MacosColor(0xff30D158);

  static const systemBlueColor = MacosColor(0xff007AFF);
  static const systemBlueColorDark = MacosColor(0xff0A84FF);

  static const systemOrangeColor = MacosColor(0xffFF9500);
  static const systemOrangeColorDark = MacosColor(0xffFF9F0A);

  static const systemYellowColor = MacosColor(0xffFF9F0A);
  static const systemYellowColorDark = MacosColor(0xffFFD60A);

  static const systemBrownColor = MacosColor(0xffA2845E);
  static const systemBrownColorDark = MacosColor(0xffAC8E68);

  static const systemPinkColor = MacosColor(0xffFF2D55);
  static const systemPinkColorDark = MacosColor(0xffFF375F);

  static const systemPurpleColor = MacosColor(0xffAF52DE);
  static const systemPurpleColorDark = MacosColor(0xffBF5AF2);

  static const systemTealColor = MacosColor(0xff55BEF0);
  static const systemTealColorDark = MacosColor(0xff5AC8F5);

  static const systemIndigoColor = MacosColor(0xff5856D6);
  static const systemIndigoColorDark = MacosColor(0xff5E5CE6);

  static const systemGrayColor = MacosColor(0xff8E8E93);
  static const systemGrayColorDark = MacosColor(0xff98989D);

  /// A link to other content.
  static const linkColor = MacosColor(0xff0068DA);
  static const linkColorDark = Color.fromRGBO(65, 156, 255, 1);

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
  static const unemphasizedSelectedTextBackgroundColor = MacosColor(0xffDCDCDC);
  static const unemphasizedSelectedTextBackgroundColorDark = MacosColor(0xff464646);

  /// Selected text in a non-key window or view.
  static const unemphasizedSelectedTextColor = MacosColors.white;

  /// The background of a window.
  static const windowBackgroundColor = MacosColor(0xff3b373d);

  /// The background behind a document's content.
  static const underPageBackgroundColor = MacosColor(0xff282828);

  /// The background of a large interface element, such as a browser or table.
  static const controlBackgroundColor = MacosColor(0xffFFFFFF);
  static const controlBackgroundColorDark = MacosColor(0xff1E1E1E);

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
  static const controlColor = MacosColor(0xffFFFFFF);
  static const controlColorDark = Color.fromRGBO(255, 255, 255, 0.25);

  /// The text of a control that isn’t disabled.
  static const controlTextColor = Color.fromRGBO(0, 0, 0, 0.85);
  static const controlTextColorDark = MacosColor(0xffddddde);

  /// The text of a control that’s disabled.
  static const disabledControlTextColor = Color.fromRGBO(0, 0, 0, 0.25);
  static const disabledControlTextColorDark =
      Color.fromRGBO(255, 255, 255, 0.25);

  /// The surface of a selected control.
  static const selectedControlColor = Color.fromRGBO(179, 215, 255, 1);
  static const selectedControlColorDark = Color.fromRGBO(63, 99, 139, 1);

  /// The text of a selected control.
  static const selectedControlTextColor = MacosColor(0xffddddde);
  static const disabledControlColor = MacosColor(0xff5a585c);

  /// The ring that appears around the currently focused control when using
  /// the keyboard for interface navigation.
  static const keyboardFocusIndicatorColor = Color.fromRGBO(0, 103, 244, 0.25);
  static const keyboardFocusIndicatorColorDark = Color.fromRGBO(26, 169, 255, 0.3);

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
