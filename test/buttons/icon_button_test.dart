import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

import '../mocks.dart';

void main() {
  late MockOnPressedFunction mockOnPressedFunction;

  setUp(() {
    mockOnPressedFunction = MockOnPressedFunction();
  });

  testWidgets('MacosIconButton onPressed works', (tester) async {
    await tester.pumpWidget(
      MacosApp(
        home: MacosWindow(
          child: MacosScaffold(
            children: [
              ContentArea(
                builder: (context, _) {
                  return MacosIconButton(
                    icon: const Icon(CupertinoIcons.add),
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
          disableWallpaperTinting: true,
          child: MacosScaffold(
            children: [
              ContentArea(
                builder: (context, _) {
                  return MacosIconButton(
                    key: iconButtonKey,
                    icon: const Icon(CupertinoIcons.add),
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

  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const MacosIconButton(
      icon: Icon(CupertinoIcons.add),
    ).debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'backgroundColor: null',
        'disabledColor: null',
        'hoverColor: null',
        'pressedOpacity: 0.4',
        'alignment: Alignment.center',
        'padding: null',
        'semanticLabel: null',
      ],
    );
  });
}
