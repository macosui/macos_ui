import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/src/styles/typography.dart';

//todo: documentation
class Theme extends InheritedWidget {
  const Theme({
    Key? key,
    required this.style,
    required this.child,
  }) : super(key: key, child: child);

  final Style style;
  final Widget child;

  static Style of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Theme>()!.style.build();
  }

  static Style maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Theme>()!.style.build();
  }

  @override
  bool updateShouldNotify(covariant Theme oldWidget) =>
      oldWidget.style != style;
}

extension themeContext on BuildContext {
  Style get theme => Theme.of(this);
  Style? get maybeTheme => Theme.maybeOf(this);
}

extension brightnessExtension on Brightness {
  bool get isLight => this == Brightness.light;
  bool get isDark => this == Brightness.dark;

  Brightness get opposite => isLight ? Brightness.dark : Brightness.light;
}

//todo: documentation
class Style with Diagnosticable {
  const Style({
    this.brightness,
    this.typography,
  });

  final Brightness? brightness;

  final Typography? typography;

  Style build() {
    final brightness = this.brightness ?? Brightness.light;
    final defaultStyle = Style(
      brightness: brightness,
      typography: Typography.defaultTypography(brightness: brightness)
          .copyWith(typography),
    );

    return defaultStyle.copyWith(Style());
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
