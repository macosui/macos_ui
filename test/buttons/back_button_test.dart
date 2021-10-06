import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mocktail/mocktail.dart';

class MockNavigationObserver extends Mock implements NavigatorObserver {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      MaterialPageRoute<dynamic>(builder: (context) => Container()),
    );
  });

  testWidgets('MacosBackButton goes back on click', (tester) async {
    final navigatorObserver = MockNavigationObserver();

    await tester.pumpWidget(
      MacosApp(
        navigatorObservers: [
          navigatorObserver,
        ],
        home: MacosWindow(
          child: MacosScaffold(
            titleBar: TitleBar(
              leading: MacosBackButton(),
            ),
          ),
        ),
      ),
    );

    final backButton = find.byType(MacosBackButton);
    expect(backButton, findsOneWidget);

    await tester.tap(backButton);
    verify(() => navigatorObserver.didPush(any(), any()));
    await tester.pumpAndSettle();
  });

  testWidgets('handleTapDown', (tester) async {
    await tester.pumpWidget(
      MacosApp(
        home: MacosWindow(
          child: MacosScaffold(
            titleBar: TitleBar(
              leading: MacosBackButton(),
            ),
          ),
        ),
      ),
    );

    final backButton = find.byType(MacosBackButton);
    expect(backButton, findsOneWidget);

    final gesture = await tester.press(backButton);
    await gesture.down(Offset.zero);
  });

  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const MacosBackButton().debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'fillColor: null',
        'semanticLabel: null',
        'disabled',
      ],
    );
  });
}
