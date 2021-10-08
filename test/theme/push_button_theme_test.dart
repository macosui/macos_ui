import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  group('PushButton theme tests', () {
    test('lerps from light to dark', () {
      final actual =
          PushButtonThemeData.lerp(_pushButtonTheme, _pushButtonThemeDark, 1);

      expect(actual, _pushButtonThemeDark);
    });

    test('lerps from dark to light', () {
      final actual =
          PushButtonThemeData.lerp(_pushButtonThemeDark, _pushButtonTheme, 1);

      expect(actual, _pushButtonTheme);
    });

    test('copyWith, hashCode, ==', () {
      expect(
        const PushButtonThemeData(),
        const PushButtonThemeData().copyWith(),
      );
      expect(
        const PushButtonThemeData().hashCode,
        const PushButtonThemeData().copyWith().hashCode,
      );
    });

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      PushButtonThemeData(
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
                    return const PushButton(
                      buttonSize: ButtonSize.small,
                      child: Text('Push me'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final theme = PushButtonTheme.of(capturedContext);
      expect(theme.color, const Color(0xff007aff));
      expect(theme.disabledColor, const Color(0xfff4f5f5));
    });
  });
}

final _pushButtonTheme = PushButtonThemeData(
  color: MacosColors.appleRed,
  disabledColor: MacosColors.systemGrayColor.color,
);

final _pushButtonThemeDark = PushButtonThemeData(
  color: MacosColors.appleBlue,
  disabledColor: MacosColors.systemGrayColor.darkColor,
);
