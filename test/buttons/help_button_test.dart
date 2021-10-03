import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import '../mocks.dart';

void main() {
  late MockOnPressedFunction mockOnPressedFunction;

  setUp(() {
    mockOnPressedFunction = MockOnPressedFunction();
  });

  group('HelpButton tests', () {
    testWidgets('HelpButton onPressed works', (tester) async {
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

      expect(mockOnPressedFunction.called, 1);
    });
  });
}
