import 'package:flutter/foundation.dart';
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

  group('PushButton tests', () {
    testWidgets('PushButton onPressed works', (tester) async {
      await tester.pumpWidget(
        MacosApp(
          theme: MacosThemeData.dark().copyWith(
            pushButtonTheme: darkPushButtonThemeData,
          ),
          home: MacosWindow(
            child: MacosScaffold(
              children: [
                ContentArea(
                  builder: (context, _) {
                    return PushButton(
                      controlSize: ControlSize.regular,
                      onPressed: mockOnPressedFunction.handler,
                      child: const Text('Push me'),
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
            pushButtonTheme: darkPushButtonThemeData,
          ),
          home: MacosWindow(
            disableWallpaperTinting: true,
            child: MacosScaffold(
              children: [
                ContentArea(
                  builder: (context, _) {
                    return PushButton(
                      controlSize: ControlSize.regular,
                      key: pushButtonKey,
                      onPressed: mockOnTapCancelFunction.handler,
                      child: const Text('Push me'),
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
        controlSize: ControlSize.regular,
        child: Text('Test'),
      ).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'controlSize: regular',
          'color: null',
          'disabledColor: null',
          'alignment: Alignment.center',
          'semanticLabel: null',
          'borderRadius: BorderRadius.circular(4.0)',
          'disabled',
          'secondary: null',
        ],
      );
    });
  });
}

final darkPushButtonThemeData = PushButtonThemeData(
  color: CupertinoColors.activeBlue.darkColor,
  disabledColor: const Color.fromRGBO(56, 56, 56, 1.0),
);
