import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

void main() {
  testWidgets('copyWith, ==, hashcode basics', (tester) async {
    expect(
      const MacosIconButtonThemeData(),
      const MacosIconButtonThemeData().copyWith(),
    );
    expect(
      const MacosIconButtonThemeData().hashCode,
      const MacosIconButtonThemeData().copyWith().hashCode,
    );
  });

  test('lerps from light to dark', () {
    final actual = MacosIconButtonThemeData.lerp(
      _iconButtonTheme,
      _iconButtonThemeDark,
      1,
    );

    expect(actual, _iconButtonThemeDark);
  });

  test('lerps from dark to light', () {
    final actual = MacosIconButtonThemeData.lerp(
      _iconButtonThemeDark,
      _iconButtonTheme,
      1,
    );

    expect(actual, _iconButtonTheme);
  });

  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const MacosIconButtonThemeData().debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'backgroundColor: null',
        'disabledColor: null',
        'hoverColor: null',
        'shape: null',
        'borderRadius: null',
        'boxConstraints: null',
        'padding: null',
      ],
    );
  });

  testWidgets('Default values in widget tree', (tester) async {
    late BuildContext capturedContext;
    await tester.pumpWidget(
      MacosApp(
        home: MacosWindow(
          disableWallpaperTinting: true,
          child: MacosScaffold(
            children: [
              ContentArea(
                builder: (context, _) {
                  capturedContext = context;
                  return MacosIconButton(
                    icon: const Icon(CupertinoIcons.add),
                    onPressed: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    final theme = MacosIconButtonTheme.of(capturedContext);
    expect(theme.backgroundColor, MacosColors.transparent);
    expect(theme.disabledColor, const Color(0xffE5E5E5));
  });
}

final _iconButtonTheme = MacosIconButtonThemeData(
  backgroundColor: MacosColors.transparent,
  disabledColor: MacosColors.systemGrayColor.color,
);

final _iconButtonThemeDark = MacosIconButtonThemeData(
  backgroundColor: MacosColors.systemBlueColor.color,
  disabledColor: MacosColors.systemGrayColor.darkColor,
);
