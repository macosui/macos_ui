import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

void main() {
  group('MacosAutoCompleteField theme tests', () {
    test('lerps from light to dark', () {
      final actual = MacosAutoCompleteFieldThemeData.lerp(
        _macosAutoCompleteFieldTheme,
        _macosAutoCompleteFieldThemeDark,
        1,
      );

      expect(actual, _macosAutoCompleteFieldThemeDark);
    });

    test('lerps from dark to light', () {
      final actual = MacosAutoCompleteFieldThemeData.lerp(
        _macosAutoCompleteFieldThemeDark,
        _macosAutoCompleteFieldTheme,
        1,
      );

      expect(actual, _macosAutoCompleteFieldTheme);
    });

    test('copyWith, hashCode, ==', () {
      expect(
        const MacosAutoCompleteFieldThemeData(),
        const MacosAutoCompleteFieldThemeData().copyWith(),
      );
      expect(
        const MacosAutoCompleteFieldThemeData().hashCode,
        const MacosAutoCompleteFieldThemeData().copyWith().hashCode,
      );
    });

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      MacosAutoCompleteFieldThemeData(
        highlightColor: CupertinoColors.activeBlue.color,
        resultsBackgroundColor: const Color.fromRGBO(242, 242, 247, 1),
      ).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'highlightColor: Color(0xff007aff)',
          'resultsBackgroundColor: Color(0xfff2f2f7)',
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
                  builder: (context, _) {
                    capturedContext = context;
                    return const Center(
                      child: MacosAutoCompleteField(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final theme = MacosAutoCompleteFieldTheme.of(capturedContext);
      expect(theme.highlightColor, const Color(0xff007aff));
      expect(theme.resultsBackgroundColor, const Color(0xfff2f2f7));
    });
  });
}

final _macosAutoCompleteFieldTheme = MacosAutoCompleteFieldThemeData(
  highlightColor: CupertinoColors.activeBlue.color,
  resultsBackgroundColor: const Color.fromRGBO(242, 242, 247, 1),
);

final _macosAutoCompleteFieldThemeDark = MacosAutoCompleteFieldThemeData(
  highlightColor: CupertinoColors.activeBlue.darkColor,
  resultsBackgroundColor: const Color.fromRGBO(30, 30, 30, 1),
);
