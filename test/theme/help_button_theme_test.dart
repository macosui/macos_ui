import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';
import 'package:mocktail/mocktail.dart';

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
          'color: Color(0xff0433ff)',
          'disabledColor: Color(0xff8e8e93)',
        ],
      );
    });

    testWidgets('Default values in widget tree', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MacosApp(
          home: MacosWindow(
            child: MacosScaffold(
              children: [
                ContentArea(
                  builder: (context, scrollController) {
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
      expect(theme.color, Color(0xfff4f5f5));
      expect(theme.disabledColor, Color(0xfff4f5f5));
    });

    testWidgets('Default values in widget tree', (tester) async {
      await tester.pumpWidget(
        MacosApp(
          theme: MacosThemeData.dark().copyWith(
            helpButtonTheme: const HelpButtonThemeData(),
          ),
          home: MacosWindow(
            child: MacosScaffold(
              children: [
                ContentArea(
                  builder: (context, scrollController) {
                    return HelpButton(
                      onPressed: () {},
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final helpButton = find.byType(HelpButton);
      await tester.tap(helpButton);
      await tester.pumpAndSettle();
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
