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
      _helpButtonTheme.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'backgroundColor: MacosColor(0xffffffff)',
          'iconColor: MacosColor(0xd8000000)',
          'disabledColor: MacosColor(0xfff4f4f4)',
        ],
      );
    });

    testWidgets('Default light values in widget tree', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MacosApp(
          home: MacosWindow(
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
      expect(theme.backgroundColor, _helpButtonTheme.backgroundColor);
      expect(theme.iconColor, _helpButtonTheme.iconColor);
      expect(theme.disabledColor, _helpButtonTheme.disabledColor);
    });

    testWidgets('Default light values in widget tree', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MacosApp(
          home: MacosWindow(
            child: MacosScaffold(
              children: [
                ContentArea(
                  builder: (context, _) {
                    capturedContext = context;
                    return HelpButtonTheme(
                      data: _helpButtonThemeDark,
                      child: const HelpButton(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final theme = HelpButtonTheme.of(capturedContext);
      expect(theme.backgroundColor, _helpButtonTheme.backgroundColor);
      expect(theme.iconColor, _helpButtonTheme.iconColor);
      expect(theme.disabledColor, _helpButtonTheme.disabledColor);
    });
  });
}

final _helpButtonTheme = HelpButtonThemeData(
  backgroundColor: MacosColors.white,
  iconColor: MacosColors.controlTextColor.color.toMacosColor(),
  disabledColor: const MacosColor.fromRGBO(244, 244, 244, 1.0),
);

final _helpButtonThemeDark = HelpButtonThemeData(
  backgroundColor: const MacosColor.fromRGBO(84, 84, 84, 1.0),
  iconColor: MacosColors.controlTextColor.color.toMacosColor(),
  disabledColor: MacosColors.quaternaryLabelColor.darkColor.toMacosColor(),
);
