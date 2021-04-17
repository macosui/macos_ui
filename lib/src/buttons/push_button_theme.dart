import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';

class PushButtonTheme extends InheritedTheme {
  const PushButtonTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final PushButtonThemeData data;

  static PushButtonThemeData of(BuildContext context) {
    final PushButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<PushButtonTheme>();
    return buttonTheme?.data ?? MacosTheme.of(context).pushButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return PushButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(PushButtonTheme oldWidget) => data != oldWidget.data;
}

class PushButtonThemeData with Diagnosticable {
  const PushButtonThemeData({
    required this.color,
    required this.disabledColor,
  });

  final Color color;
  final Color disabledColor;

  PushButtonThemeData copyWith(PushButtonThemeData? themeData) {
    if (themeData == null) {
      return this;
    }
    return PushButtonThemeData(
      color: themeData.color,
      disabledColor: themeData.disabledColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('color', color));
    properties.add(DiagnosticsProperty('disabledColor', disabledColor));
  }
}
