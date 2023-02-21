import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

void main() {
  testWidgets('Entered text matches', (tester) async {
    const input = 'GroovinChip';
    final controller = TextEditingController();
    await tester.pumpWidget(
      MacosApp(
        home: MacosWindow(
          child: MacosScaffold(
            children: [
              ContentArea(
                builder: (context, _) {
                  return Center(
                    child: MacosTextField(
                      controller: controller,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    final textField = find.byType(MacosTextField);
    await tester.enterText(textField, input);
    expect(controller.text, input);
  });
}
