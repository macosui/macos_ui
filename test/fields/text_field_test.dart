import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
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

  Offset caretAt(WidgetTester tester, int offset) {
    final renderEditable = tester
        .state<EditableTextState>(find.byType(EditableText))
        .renderEditable;
    final rect = renderEditable.getLocalRectForCaret(
      TextPosition(offset: offset),
    );
    return renderEditable.localToGlobal(rect.center);
  }

  testWidgets(
    'Shift-click extends the selection and keeps it after the release',
    (tester) async {
      final controller = TextEditingController(text: 'Hello brave world');
      await tester.pumpWidget(field(controller));

      await tester.tapAt(caretAt(tester, 11), kind: PointerDeviceKind.mouse);
      await tester.pump(const Duration(milliseconds: 500));
      expect(controller.selection, const TextSelection.collapsed(offset: 11));

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.tapAt(caretAt(tester, 0), kind: PointerDeviceKind.mouse);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pump(const Duration(milliseconds: 500));

      expect(controller.selection.start, 0);
      expect(controller.selection.end, 11);
    },
    variant: TargetPlatformVariant.desktop(),
  );

  testWidgets('A plain click places the caret', (tester) async {
    final controller = TextEditingController(text: 'Hello brave world');
    await tester.pumpWidget(field(controller));

    await tester.tapAt(caretAt(tester, 6), kind: PointerDeviceKind.mouse);
    await tester.pump(const Duration(milliseconds: 500));

    expect(controller.selection, const TextSelection.collapsed(offset: 6));
  }, variant: TargetPlatformVariant.all());
}
