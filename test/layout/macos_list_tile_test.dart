import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

import '../mocks.dart';

void main() {
  late MockOnPressedFunction mockOnPressedFunction;
  late MockOnLongPressedFunction mockOnLongPressedFunction;

  setUp(() {
    mockOnPressedFunction = MockOnPressedFunction();
    mockOnLongPressedFunction = MockOnLongPressedFunction();
  });

  testWidgets('MacosListTile onClick works', (tester) async {
    await tester.pumpWidget(
      MacosApp(
        theme: MacosThemeData.dark().copyWith(
          pushButtonTheme: const PushButtonThemeData(),
        ),
        home: MacosWindow(
          disableWallpaperTinting: true,
          child: MacosScaffold(
            children: [
              ContentArea(
                builder: (context, _) {
                  return MacosListTile(
                    title: const Text('List Tile'),
                    onClick: mockOnPressedFunction.handler,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    final listTile = find.byType(MacosListTile);
    expect(listTile, findsOneWidget);
    await tester.tap(listTile);
    expect(mockOnPressedFunction.called, 2);
  });

  testWidgets('MacosListTile onLongPress works', (tester) async {
    await tester.pumpWidget(
      MacosApp(
        theme: MacosThemeData.dark().copyWith(
          pushButtonTheme: const PushButtonThemeData(),
        ),
        home: MacosWindow(
          child: MacosScaffold(
            children: [
              ContentArea(
                builder: (context, _) {
                  return MacosListTile(
                    title: const Text('List Tile'),
                    subtitle: const Text('Subtitle'),
                    onClick: mockOnLongPressedFunction.handler,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    final listTile = find.byType(MacosListTile);
    await tester.longPress(listTile);
    await tester.pumpAndSettle();

    expect(mockOnLongPressedFunction.called, 3);
  });
}
