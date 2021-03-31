import 'package:macos_ui/macos_ui.dart';
import 'package:flutter/foundation.dart';

//todo: documentation
class MacosTheme extends InheritedWidget {
  const MacosTheme({
    Key? key,
    required this.style,
    required this.child,
  }) : super(key: key, child: child);

  final Style style;
  final Widget child;

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
  Style get theme => MacosTheme.of(this);
  Style? get maybeTheme => MacosTheme.maybeOf(this);
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
    this.accentColor,
  });

  final Typography? typography;

  final Brightness? brightness;

  final CupertinoDynamicColor? accentColor;

  Style build() {
    final brightness = this.brightness ?? Brightness.light;
    final defaultStyle = Style(
      brightness: brightness,
      typography: Typography.defaultTypography(brightness: brightness)
          .copyWith(typography),
      accentColor: accentColor ?? CupertinoColors.systemBlue,
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
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('brightness', brightness));
  }
}
