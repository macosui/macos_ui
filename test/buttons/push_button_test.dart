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

  group('PushButton tests', () {
    testWidgets('PushButton onPressed works', (tester) async {
      await tester.pumpWidget(
        MacosApp(
          theme: MacosThemeData.dark().copyWith(
            pushButtonTheme: const PushButtonThemeData(),
          ),
          home: MacosWindow(
            child: MacosScaffold(
              children: [
                ContentArea(
                  builder: (context, scrollController) {
                    return PushButton(
                      buttonSize: ButtonSize.small,
                      child: const Text('Push me'),
                      onPressed: mockOnPressedFunction.handler,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final pushButton = find.byType(PushButton);
      await tester.tap(pushButton);
      await tester.pumpAndSettle();

      expect(mockOnPressedFunction.called, 2);
    });

    testWidgets('PushButton onTapCancel works', (tester) async {
      final pushButtonKey = GlobalKey<PushButtonState>();

      await tester.pumpWidget(
        MacosApp(
          theme: MacosThemeData.dark().copyWith(
            pushButtonTheme: const PushButtonThemeData(),
          ),
          home: MacosWindow(
            child: MacosScaffold(
              children: [
                ContentArea(
                  builder: (context, scrollController) {
                    return PushButton(
                      buttonSize: ButtonSize.small,
                      child: const Text('Push me'),
                      key: pushButtonKey,
                      onPressed: mockOnTapCancelFunction.handler,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final pushButton = find.byType(PushButton);
      final gesture = await tester.press(pushButton);
      await gesture.cancel();

      expect(pushButtonKey.currentState!.buttonHeldDown, false);
    });

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      const PushButton(
        buttonSize: ButtonSize.small,
        child: Text('Test'),
      ).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'buttonSize: small',
          'color: null',
          'disabledColor: null',
          'pressedOpacity: 0.4',
          'alignment: Alignment.center',
          'semanticLabel: null',
          'borderRadius: BorderRadius.circular(4.0)',
          'disabled',
        ],
      );
    });
  });
}
