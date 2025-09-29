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

      expect(description, [
        'highlightColor: MacosColor(alpha: 1.0000, red: 0.5569, green: 0.5569, blue: 0.5765, colorSpace: ColorSpace.sRGB)',
        'backgroundColor: MacosColor(alpha: 1.0000, red: 0.0157, green: 0.2000, blue: 1.0000, colorSpace: ColorSpace.sRGB)',
        'pulldownColor: Color(alpha: 0.1000, red: 0.0000, green: 0.0000, blue: 0.0000, colorSpace: ColorSpace.sRGB)',
        'iconColor: MacosColor(alpha: 1.0000, red: 0.0000, green: 0.9765, blue: 0.0000, colorSpace: ColorSpace.sRGB)',
      ]);
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
      expect(
        theme.highlightColor,
        const MacosColor.fromRGBO(9, 129, 255, 0.749),
      );
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
