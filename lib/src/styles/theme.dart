import 'package:macos_ui/macos_ui.dart';
import 'package:flutter/foundation.dart';

//todo: documentation
class MacosTheme extends InheritedWidget {
  const MacosTheme({
    Key? key,
    required this.style,
    required this.child,
  }) : super(key: key, child: child);

  final Widget child;
  final Style style;

  static Style of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MacosTheme>()!
        .style
        .build();
  }

  static Style maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MacosTheme>()!
        .style
        .build();
  }

  @override
  bool updateShouldNotify(covariant MacosTheme oldWidget) =>
      oldWidget.style != style;
}

extension themeContext on BuildContext {
  Style get style => MacosTheme.of(this);
  Style? get maybeStyle => MacosTheme.maybeOf(this);
}

extension brightnessExtension on Brightness {
  bool get isLight => this == Brightness.light;
  bool get isDark => this == Brightness.dark;

  Brightness get opposite => isLight ? Brightness.dark : Brightness.light;
}

//todo: documentation
class Style with Diagnosticable {
  const Style({
    this.typography,
    this.brightness,
    this.primaryColor,
    this.accentColor,
    this.animationCurve,
    this.mediumAnimationDuration,
    this.checkboxStyle,
    this.disclosureControlStyle,
    this.gradientButtonStyle,
    this.helpButtonStyle,
    this.imageButtonStyle,
    this.popupButtonStyle,
    this.pulldownButtonStyle,
    this.pushButtonStyle,
    this.radioButtonStyle,
    this.switchStyle,
  });

  final CupertinoDynamicColor? primaryColor;

  final CupertinoDynamicColor? accentColor;

  final Curve? animationCurve;

  final Brightness? brightness;

  final CheckboxStyle? checkboxStyle;

  final DisclosureControlStyle? disclosureControlStyle;

  final GradientButtonStyle? gradientButtonStyle;

  final HelpButtonStyle? helpButtonStyle;

  final ImageButtonStyle? imageButtonStyle;

  final Duration? mediumAnimationDuration;

  final PopupButtonStyle? popupButtonStyle;

  final PulldownButtonStyle? pulldownButtonStyle;

  final PushButtonStyle? pushButtonStyle;

  final RadioButtonStyle? radioButtonStyle;

  final SwitchStyle? switchStyle;

  final Typography? typography;

  Style build() {
    final brightness = this.brightness ?? Brightness.light;
    final defaultStyle = Style(
      brightness: brightness,
      typography: Typography.defaultTypography(brightness: brightness)
          .copyWith(typography),
      primaryColor: primaryColor ?? CupertinoColors.systemBlue,
      accentColor: accentColor ?? CupertinoColors.systemBlue,
      mediumAnimationDuration: Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
    );

    //return defaultStyle.copyWith(Style());
    return defaultStyle;
  }

  static Style fallback([Brightness? brightness]) {
    return Style(brightness: brightness).build();
  }

  Style copyWith(Style? other) {
    if (other == null) return this;
    return Style(
      brightness: other.brightness ?? brightness,
      typography: other.typography ?? typography,
      animationCurve: other.animationCurve ?? animationCurve,
      mediumAnimationDuration:
          other.mediumAnimationDuration ?? mediumAnimationDuration,
      primaryColor: other.primaryColor ?? primaryColor,
      accentColor: other.accentColor ?? accentColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('brightness', brightness));
    properties.add(EnumProperty('primaryColor', primaryColor));
    properties.add(EnumProperty('accentColor', accentColor));
  }
}
