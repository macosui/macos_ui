import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

void main() {
  test('copyWith, ==, hashcode basics', () {
    expect(
      const MacosIconThemeData(),
      const MacosIconThemeData().copyWith(),
    );
    expect(
      const MacosIconThemeData().hashCode,
      const MacosIconThemeData().copyWith().hashCode,
    );
  });

  test('lerps from light to dark', () {
    final actual = MacosIconThemeData.lerp(
      _iconTheme,
      _iconThemeDark,
      1,
    );

    expect(actual, _iconThemeDark);
  });

  test('lerps from dark to light', () {
    final actual = MacosIconThemeData.lerp(
      _iconThemeDark,
      _iconTheme,
      1,
    );

    expect(actual, _iconTheme);
  });

  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const MacosIconThemeData(
      color: MacosColors.white,
      size: 20,
      opacity: 0.0,
    ).debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'MacosColor: MacosColor(0xffffffff)',
        'opacity: 0.0',
        'size: 20.0',
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
                  return const MacosIcon(
                    CupertinoIcons.add,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    final theme = MacosIconTheme.of(capturedContext);
    expect(theme.color, const MacosColor(0xbe0981ff));
    expect(theme.size, 20);
  });
}

const _iconTheme = MacosIconThemeData(
  color: MacosColors.black,
);

const _iconThemeDark = MacosIconThemeData(
  color: MacosColors.white,
);
