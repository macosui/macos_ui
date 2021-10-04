import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

import '../mocks.dart';

void main() {
  late MockOnPressedFunction mockOnPressedFunction;
  late MockOnTapCancelFunction mockOnTapCancelFunction;

  setUp(() {
    mockOnPressedFunction = MockOnPressedFunction();
    mockOnTapCancelFunction = MockOnTapCancelFunction();
  });

  testWidgets('MacosIconButton onPressed works', (tester) async {
    await tester.pumpWidget(
      MacosApp(
        home: MacosWindow(
          child: MacosScaffold(
            children: [
              ContentArea(
                builder: (context, scrollController) {
                  return MacosIconButton(
                    icon: Icon(CupertinoIcons.add),
                    onPressed: mockOnPressedFunction.handler,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    final iconButton = find.byType(MacosIconButton);
    await tester.tap(iconButton);
    await tester.pumpAndSettle();

    expect(mockOnPressedFunction.called, 2);
  });

  testWidgets('MacosIconButton onTapCancel works', (tester) async {
    final iconButtonKey = GlobalKey<MacosIconButtonState>();

    await tester.pumpWidget(
      MacosApp(
        home: MacosWindow(
          child: MacosScaffold(
            children: [
              ContentArea(
                builder: (context, scrollController) {
                  return MacosIconButton(
                    key: iconButtonKey,
                    icon: Icon(CupertinoIcons.add),
                    onPressed: mockOnPressedFunction.handler,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    final iconButton = find.byType(MacosIconButton);
    final gesture = await tester.press(iconButton);
    await gesture.cancel();

    expect(iconButtonKey.currentState?.buttonHeldDown, false);
  });
}
