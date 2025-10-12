import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  group('MacosPulldownButton theme tests', () {
    test('lerps from light to dark', () {
      final actual = MacosPulldownButtonThemeData.lerp(
        _macosPulldownButtonTheme,
        _macosPulldownButtonThemeDark,
        1,
      );

      expect(actual, _macosPulldownButtonThemeDark);
    });

    test('lerps from dark to light', () {
      final actual = MacosPulldownButtonThemeData.lerp(
        _macosPulldownButtonThemeDark,
        _macosPulldownButtonTheme,
        1,
      );

      expect(actual, _macosPulldownButtonTheme);
    });

    test('copyWith, hashCode, ==', () {
      expect(
        const MacosPulldownButtonThemeData(),
        const MacosPulldownButtonThemeData().copyWith(),
      );
      expect(
        const MacosPulldownButtonThemeData().hashCode,
        const MacosPulldownButtonThemeData().copyWith().hashCode,
      );
    });

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      MacosPulldownButtonThemeData(
        highlightColor: MacosColors.systemGrayColor.color,
        backgroundColor: MacosColors.appleBlue,
        pulldownColor: MacosColors.controlColor.color,
        iconColor: MacosColors.appleGreen,
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
          'pulldownColor: Color(0x19000000)',
          'iconColor: MacosColor(0xff00f900)',
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
                    return const Center(
                      child: MacosPulldownButton(
                        title: "test",
                        items: [
                          MacosPulldownMenuItem(
                            title: Text('one'),
                            onTap: null,
                          ),
                          MacosPulldownMenuItem(
                            title: Text('two'),
                            onTap: null,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final theme = MacosPulldownButtonTheme.of(capturedContext);
      expect(theme.backgroundColor, const Color(0xffffffff));
      expect(theme.highlightColor, const MacosColor(0xbe0981ff));
      expect(theme.pulldownColor, const Color(0xfff2f2f7));
    });
  });
}

final _macosPulldownButtonTheme = MacosPulldownButtonThemeData(
  backgroundColor: MacosColors.appleRed,
  highlightColor: MacosColors.systemGrayColor.color,
  pulldownColor: MacosColors.controlColor.color,
);

final _macosPulldownButtonThemeDark = MacosPulldownButtonThemeData(
  backgroundColor: MacosColors.appleBlue,
  highlightColor: MacosColors.systemGrayColor.darkColor,
  pulldownColor: MacosColors.controlColor.darkColor,
);
