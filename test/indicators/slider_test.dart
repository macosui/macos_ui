import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    MacosSlider(
      value: 0.5,
      onChanged: (newValue) {},
    ).debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(description, [
      'value: 0.5',
      'has onChanged',
      'min: 0.0',
      'max: 1.0',
      'color: systemBlue(*color = Color(alpha: 1.0000, red: 0.0000, green: 0.4784, blue: 1.0000, colorSpace: ColorSpace.sRGB)*, darkColor = Color(alpha: 1.0000, red: 0.0392, green: 0.5176, blue: 1.0000, colorSpace: ColorSpace.sRGB), highContrastColor = Color(alpha: 1.0000, red: 0.0000, green: 0.2510, blue: 0.8667, colorSpace: ColorSpace.sRGB), darkHighContrastColor = Color(alpha: 1.0000, red: 0.2510, green: 0.6118, blue: 1.0000, colorSpace: ColorSpace.sRGB), resolved by: UNRESOLVED)',
      'backgroundColor: CupertinoDynamicColor(*color = Color(alpha: 0.1000, red: 0.0000, green: 0.0000, blue: 0.0000, colorSpace: ColorSpace.sRGB)*, darkColor = Color(alpha: 0.1000, red: 1.0000, green: 1.0000, blue: 1.0000, colorSpace: ColorSpace.sRGB), resolved by: UNRESOLVED)',
      'tickBackgroundColor: CupertinoDynamicColor(*color = Color(alpha: 1.0000, red: 0.8627, green: 0.8627, blue: 0.8627, colorSpace: ColorSpace.sRGB)*, darkColor = Color(alpha: 1.0000, red: 0.2745, green: 0.2745, blue: 0.2745, colorSpace: ColorSpace.sRGB), resolved by: UNRESOLVED)',
      'thumbColor: CupertinoDynamicColor(*color = Color(alpha: 1.0000, red: 1.0000, green: 1.0000, blue: 1.0000, colorSpace: ColorSpace.sRGB)*, darkColor = Color(alpha: 1.0000, red: 0.5961, green: 0.5961, blue: 0.6157, colorSpace: ColorSpace.sRGB), resolved by: UNRESOLVED)',
      'splits: 15',
      'semanticLabel: null',
    ]);
  });

  testWidgets('Continuous slider can move when tapped', (tester) async {
    tester.view.physicalSize = const Size(100, 50);
    tester.view.devicePixelRatio = 1.0;

    final value = ValueNotifier<double>(0.25);
    await tester.pumpWidget(
      CupertinoApp(
        home: Center(
          child: MacosSlider(
            value: value.value,
            onChanged: (newValue) {
              value.value = newValue;
            },
          ),
        ),
      ),
    );

    expect(value.value, 0.25);

    // Tap on the right half of the slider.
    await tester.tapAt(const Offset(50, 25));
    await tester.pumpAndSettle();

    expect(value.value, greaterThan(0.25));

    await tester.tapAt(const Offset(0, 25));
    await tester.pumpAndSettle();

    expect(value.value, 0.0);
    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('Discrete slider snaps to correct values', (widgetTester) async {
    widgetTester.view.physicalSize = const Size(100, 50);
    widgetTester.view.devicePixelRatio = 1.0;

    final value = ValueNotifier<double>(0.25);
    await widgetTester.pumpWidget(
      CupertinoApp(
        home: Center(
          child: MacosSlider(
            value: value.value,
            onChanged: (newValue) {
              value.value = newValue;
            },
            min: 0.0,
            max: 1.0,
            discrete: true,
            splits: 3,
          ),
        ),
      ),
    );

    expect(value.value, 0.25);

    // Tap on the right half of the slider.
    await widgetTester.tapAt(const Offset(50, 25));
    await widgetTester.pumpAndSettle();

    expect(value.value, 0.5);

    await widgetTester.tapAt(const Offset(0, 25));
    await widgetTester.pumpAndSettle();

    expect(value.value, 0.0);

    // Tap slightly to the right of the 0.5 mark.
    await widgetTester.tapAt(const Offset(55, 25));
    await widgetTester.pumpAndSettle();

    expect(value.value, 0.5);

    addTearDown(widgetTester.view.resetPhysicalSize);
  });
}
