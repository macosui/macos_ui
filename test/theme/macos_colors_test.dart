import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

final ValueVariant<ThemeMode> modes = ValueVariant<ThemeMode>({
  ThemeMode.light,
  ThemeMode.dark,
});

void main() {
  test('MacosColors lerp', () {
    expect(
      MacosColor.lerp(MacosColors.appleBlue, MacosColors.appleRed, 1),
      MacosColors.appleRed,
    );
  });

  test('MacosColor.fromRGBO produces the correct RGB values', () {
    const MacosColor color = MacosColor.fromRGBO(79, 72, 75, 1.0);
    expect(color.red, 79);
    expect(color.green, 72);
    expect(color.blue, 75);
  });

  testWidgets(
    'MacosDynamicColor resolves to the correct color',
    (tester) async {
      late BuildContext capturedContext;
      const CupertinoDynamicColor color = CupertinoDynamicColor.withBrightness(
        color: MacosColors.appleBlue,
        darkColor: MacosColors.appleRed,
      );

      await tester.pumpWidget(
        MacosApp(
          theme: MacosThemeData.light(),
          darkTheme: MacosThemeData.dark(),
          themeMode: modes.currentValue,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final Color resolvedColor =
          MacosDynamicColor.resolve(color, capturedContext);
      if (modes.currentValue == ThemeMode.light) {
        expect(resolvedColor, color);
      } else {
        expect(MacosColor(resolvedColor.value), color.darkColor);
      }
    },
    variant: modes,
  );
}
