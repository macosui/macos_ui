import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

void main() {
  group('MacosSearchField theme tests', () {
    test('lerps from light to dark', () {
      final actual = MacosSearchFieldThemeData.lerp(
        _macosSearchFieldTheme,
        _macosSearchFieldThemeDark,
        1,
      );

      expect(actual, _macosSearchFieldThemeDark);
    });

    test('lerps from dark to light', () {
      final actual = MacosSearchFieldThemeData.lerp(
        _macosSearchFieldThemeDark,
        _macosSearchFieldTheme,
        1,
      );

      expect(actual, _macosSearchFieldTheme);
    });

    test('copyWith, hashCode, ==', () {
      expect(
        const MacosSearchFieldThemeData(),
        const MacosSearchFieldThemeData().copyWith(),
      );
      expect(
        const MacosSearchFieldThemeData().hashCode,
        const MacosSearchFieldThemeData().copyWith().hashCode,
      );
    });

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      MacosSearchFieldThemeData(
        highlightColor: CupertinoColors.activeBlue.color,
        suggestionsBackgroundColor: const Color.fromRGBO(242, 242, 247, 1),
      ).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'highlightColor: Color(0xff007aff)',
          'suggestionsBackgroundColor: Color(0xfff2f2f7)',
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
                    return const Center(
                      child: MacosSearchField(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final theme = MacosSearchFieldTheme.of(capturedContext);
      expect(theme.highlightColor, const Color(0xff007aff));
      expect(theme.suggestionsBackgroundColor, const Color(0xfff2f2f7));
    });
  });
}

final _macosSearchFieldTheme = MacosSearchFieldThemeData(
  highlightColor: CupertinoColors.activeBlue.color,
  suggestionsBackgroundColor: const Color.fromRGBO(242, 242, 247, 1),
);

final _macosSearchFieldThemeDark = MacosSearchFieldThemeData(
  highlightColor: CupertinoColors.activeBlue.darkColor,
  suggestionsBackgroundColor: const Color.fromRGBO(30, 30, 30, 1),
);
