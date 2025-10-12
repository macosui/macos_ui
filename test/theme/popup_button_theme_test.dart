// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  group('MacosPopupButton theme tests', () {
    test('lerps from light to dark', () {
      final actual = MacosPopupButtonThemeData.lerp(
        _macosPopupButtonTheme,
        _macosPopupButtonThemeDark,
        1,
      );

      expect(actual, _macosPopupButtonThemeDark);
    });

    test('lerps from dark to light', () {
      final actual = MacosPopupButtonThemeData.lerp(
        _macosPopupButtonThemeDark,
        _macosPopupButtonTheme,
        1,
      );

      expect(actual, _macosPopupButtonTheme);
    });

    test('copyWith, hashCode, ==', () {
      expect(
        const MacosPopupButtonThemeData(),
        const MacosPopupButtonThemeData().copyWith(),
      );
      expect(
        const MacosPopupButtonThemeData().hashCode,
        const MacosPopupButtonThemeData().copyWith().hashCode,
      );
    });

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      MacosPopupButtonThemeData(
        highlightColor: MacosColors.systemGrayColor.color,
        backgroundColor: MacosColors.appleBlue,
        popupColor: MacosColors.controlColor.color,
      ).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'highlightColor: MacosColor(0xff8e8e93)',
          'backgroundColor: MacosColor(0xff0433ff)',
          'popupColor: Color(0x19000000)',
        ],
      );
    });

    testWidgets('Default values in widget tree', (tester) async {
      late BuildContext capturedContext;
      String popupValue = 'One';
      await tester.pumpWidget(
        MacosApp(
          home: MacosWindow(
            disableWallpaperTinting: true,
            child: MacosScaffold(
              children: [
                ContentArea(
                  builder: (context, _) {
                    capturedContext = context;
                    return MacosPopupButton<String>(
                      value: popupValue,
                      onChanged: (String? newValue) {
                        print("1");
                      },
                      items: <String>['One', 'Two', 'Three', 'Four']
                          .map<MacosPopupMenuItem<String>>((String value) {
                        return MacosPopupMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final theme = MacosPopupButtonTheme.of(capturedContext);
      expect(theme.backgroundColor, const Color(0xffffffff));
      expect(theme.highlightColor, const MacosColor(0xbe0981ff));
      expect(theme.popupColor, const Color(0xfff2f2f7));
    });
  });
}

final _macosPopupButtonTheme = MacosPopupButtonThemeData(
  backgroundColor: MacosColors.appleRed,
  highlightColor: MacosColors.systemGrayColor.color,
  popupColor: MacosColors.controlColor.color,
);

final _macosPopupButtonThemeDark = MacosPopupButtonThemeData(
  backgroundColor: MacosColors.appleBlue,
  highlightColor: MacosColors.systemGrayColor.darkColor,
  popupColor: MacosColors.controlColor.darkColor,
);
