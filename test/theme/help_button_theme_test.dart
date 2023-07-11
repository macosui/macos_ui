import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

void main() {
  group('HelpButtonTheme tests', () {
    test('lerps from light to dark', () {
      final actual =
          HelpButtonThemeData.lerp(_helpButtonTheme, _helpButtonThemeDark, 1);

      expect(actual, _helpButtonThemeDark);
    });

    test('lerps from dark to light', () {
      final actual =
          HelpButtonThemeData.lerp(_helpButtonThemeDark, _helpButtonTheme, 1);

      expect(actual, _helpButtonTheme);
    });

    test('copyWith, hashCode, ==', () {
      expect(
        const HelpButtonThemeData(),
        const HelpButtonThemeData().copyWith(),
      );
      expect(
        const HelpButtonThemeData().hashCode,
        const HelpButtonThemeData().copyWith().hashCode,
      );
    });

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      HelpButtonThemeData(
        color: MacosColors.appleBlue,
        disabledColor: MacosColors.systemGrayColor.color,
      ).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'color: MacosColor(0xff0433ff)',
          'disabledColor: MacosColor(0xff8e8e93)',
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
                    return const HelpButton();
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final theme = HelpButtonTheme.of(capturedContext);
      expect(theme.color, const Color(0xfff4f5f5));
      expect(theme.disabledColor, const Color(0xfff4f5f5));
    });
  });
}

final _helpButtonTheme = HelpButtonThemeData(
  color: MacosColors.appleRed,
  disabledColor: MacosColors.systemGrayColor.color,
);

final _helpButtonThemeDark = HelpButtonThemeData(
  color: MacosColors.appleBlue,
  disabledColor: MacosColors.systemGrayColor.darkColor,
);
