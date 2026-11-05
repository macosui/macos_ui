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
                  return Center(child: MacosTextField(controller: controller));
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
  Widget field(TextEditingController controller, {Brightness? brightness}) {
    return MacosApp(
      theme: MacosThemeData(brightness: brightness ?? Brightness.light),
      home: MacosWindow(
        child: MacosScaffold(
          children: [
            ContentArea(
              builder: (context, _) {
                return Center(
                  child: SizedBox(
                    width: 400,
                    child: MacosTextField(controller: controller),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('The default selection color is opaque in both appearances', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'Hello');
    await tester.pumpWidget(field(controller));
    await tester.pump(const Duration(milliseconds: 1));
    final light = tester
        .widget<EditableText>(find.byType(EditableText))
        .selectionColor!;

    await tester.pumpWidget(field(controller, brightness: Brightness.dark));
    await tester.pump(const Duration(milliseconds: 1));
    final dark = tester
        .widget<EditableText>(find.byType(EditableText))
        .selectionColor!;

    expect(light.a, 1.0);
    expect(dark.a, 1.0);
    expect(dark.computeLuminance(), lessThan(light.computeLuminance()));
  });

  testWidgets('selectionColor overrides the default', (tester) async {
    await tester.pumpWidget(
      MacosApp(
        home: MacosWindow(
          child: MacosScaffold(
            children: [
              ContentArea(
                builder: (context, _) => const Center(
                  child: MacosTextField(selectionColor: Color(0xFF123456)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1));
    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.selectionColor, const Color(0xFF123456));
  });
}
