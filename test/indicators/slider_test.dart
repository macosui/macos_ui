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

    expect(
      description,
      [
        'value: 0.5',
        'has onChanged',
        'min: 0.0',
        'max: 1.0',
        'color: systemBlue(*color = Color(0xff007aff)*, darkColor = Color(0xff0a84ff), highContrastColor = Color(0xff0040dd), darkHighContrastColor = Color(0xff409cff), resolved by: UNRESOLVED)',
        'backgroundColor: CupertinoDynamicColor(*color = Color(0x19000000)*, darkColor = Color(0x19ffffff), resolved by: UNRESOLVED)',
        'tickBackgroundColor: CupertinoDynamicColor(*color = Color(0xffdcdcdc)*, darkColor = Color(0xff464646), resolved by: UNRESOLVED)',
        'thumbColor: CupertinoDynamicColor(*color = Color(0xffffffff)*, darkColor = Color(0xff98989d), resolved by: UNRESOLVED)',
        'splits: 15',
        'semanticLabel: null',
      ],
    );
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
