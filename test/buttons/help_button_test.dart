import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import '../mocks.dart';

void main() {
  late MockOnPressedFunction mockOnPressedFunction;
  late MockOnTapCancelFunction mockOnTapCancelFunction;

  setUp(() {
    mockOnPressedFunction = MockOnPressedFunction();
    mockOnTapCancelFunction = MockOnTapCancelFunction();
  });

  group('HelpButton tests', () {
    testWidgets('HelpButton onPressed works', (tester) async {
      await tester.pumpWidget(
        MacosApp(
          theme: MacosThemeData.dark().copyWith(
            helpButtonTheme: darkHelpButtonThemeData,
          ),
          home: MacosWindow(
            child: MacosScaffold(
              children: [
                ContentArea(
                  builder: (context, _) {
                    return HelpButton(
                      onPressed: mockOnPressedFunction.handler,
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

      expect(mockOnPressedFunction.called, 2);
    });

    testWidgets('HelpButton onTapCancel works', (tester) async {
      final helpButtonKey = GlobalKey<HelpButtonState>();

      await tester.pumpWidget(
        MacosApp(
          theme: MacosThemeData.dark().copyWith(
            helpButtonTheme: darkHelpButtonThemeData,
          ),
          home: MacosWindow(
            disableWallpaperTinting: true,
            child: MacosScaffold(
              children: [
                ContentArea(
                  builder: (context, _) {
                    return HelpButton(
                      key: helpButtonKey,
                      onPressed: mockOnTapCancelFunction.handler,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final helpButton = find.byType(HelpButton);
      final gesture = await tester.press(helpButton);
      await gesture.cancel();

      expect(helpButtonKey.currentState!.buttonHeldDown, false);
    });

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      const HelpButton().debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'color: null',
          'disabledColor: null',
          'pressedOpacity: 0.4',
          'alignment: Alignment.center',
          'semanticLabel: null',
        ],
      );
    });
  });
}

const darkHelpButtonThemeData = HelpButtonThemeData(
  color: Color.fromRGBO(255, 255, 255, 0.1),
  disabledColor: Color.fromRGBO(255, 255, 255, 0.1),
);
