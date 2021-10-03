import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  group('HelpButton tests', () {
    testWidgets('HelpButton tap test', (tester) async {
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
                      onPressed: () {},
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
    });
  });
}
