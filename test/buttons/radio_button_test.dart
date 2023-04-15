import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

enum TestOptions {
  first,
  second,
  third,
}

Type typeOf<T>() => T;

void main() {
  testWidgets('MacosRadioButton is enabled', (tester) async {
    const selectedOption = TestOptions.first;
    await tester.pumpWidget(
      MacosApp(
        home: MacosWindow(
          disableWallpaperTinting: true,
          child: MacosScaffold(
            children: [
              ContentArea(
                builder: (context, _) {
                  return Center(
                    child: MacosRadioButton<TestOptions>(
                      value: TestOptions.first,
                      groupValue: selectedOption,
                      onChanged: (value) {},
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    final radio = find.byType(typeOf<MacosRadioButton<TestOptions>>());
    expect(
      (radio.evaluate().first.widget as MacosRadioButton<TestOptions>)
          .isDisabled,
      false,
    );
  });

  testWidgets('Trigger MacosIconButton onChanged', (tester) async {
    const selectedOption = TestOptions.first;
    int called = 0;
    await tester.pumpWidget(
      MacosApp(
        home: MacosWindow(
          child: MacosScaffold(
            children: [
              ContentArea(
                builder: (context, _) {
                  return Center(
                    child: MacosRadioButton<TestOptions>(
                      value: TestOptions.second,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        called++;
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    final radio = find.byType(typeOf<MacosRadioButton<TestOptions>>());
    expect(radio, findsOneWidget);
    await tester.tap(radio);
    await tester.pumpAndSettle();
    expect(called, 1);
  });

  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const selectedOption = TestOptions.first;
    MacosRadioButton(
      value: selectedOption,
      groupValue: TestOptions.first,
      onChanged: (value) {},
    ).debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'enabled',
        'size: 16.0',
        'onColor: null',
        'offColor: tertiaryLabel(*color = Color(0x4c3c3c43)*, darkColor = Color(0x4cebebf5), highContrastColor = Color(0x603c3c43), darkHighContrastColor = Color(0x60ebebf5), resolved by: UNRESOLVED)',
        'innerColor: null',
        'semanticLabel: null',
      ],
    );
  });
}
