import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

import '../mocks.dart';

void main() {
  late MockOnPressedFunction mockOnPressedFunction;

  setUp(() {
    mockOnPressedFunction = MockOnPressedFunction();
  });

  group('MacosPulldownButton tests', () {
    testWidgets(
      'Can tap the MacosPulldownButton and select a menu item',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return Center(
                        child: MacosPulldownButton(
                          title: "test",
                          items: [
                            MacosPulldownMenuItem(
                              title: const Text('one'),
                              onTap: mockOnPressedFunction.handler,
                            ),
                            const MacosPulldownMenuItem(
                              title: Text('two'),
                              onTap: null,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        final pulldownButton = find.byType(MacosPulldownButton);
        await tester.tap(pulldownButton);
        await tester.pumpAndSettle();
        await tester.tap(find.text("one"));
        await tester.pumpAndSettle();

        expect(mockOnPressedFunction.called, 2);
      },
    );

    testWidgets(
      'MacosPulldownButtonItems\' onTap callback is called when defined',
      (WidgetTester tester) async {
        final List<int> menuItemTapCounters = <int>[0, 0];

        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return Center(
                        child: MacosPulldownButton(
                          title: "test",
                          items: [
                            MacosPulldownMenuItem(
                              title: const Text('one'),
                              onTap: () {
                                menuItemTapCounters.first += 1;
                              },
                            ),
                            MacosPulldownMenuItem(
                              title: const Text('two'),
                              onTap: () {
                                menuItemTapCounters[1] += 1;
                              },
                            ),
                            const MacosPulldownMenuItem(
                              title: Text('no tap'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        // Tap the first time
        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('one'));
        await tester.pumpAndSettle();
        expect(menuItemTapCounters, <int>[1, 0]);

        // Tap the item again
        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('one'));
        await tester.pumpAndSettle();
        expect(menuItemTapCounters, <int>[2, 0]);

        // Tap a different item
        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('two'));
        await tester.pumpAndSettle();
        expect(menuItemTapCounters, <int>[2, 1]);

        // Tap an item without onTap
        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('no tap'));
        await tester.pumpAndSettle();
        expect(menuItemTapCounters, <int>[2, 1]);
      },
    );

    test(
      "MacosPulldownButton's label and icon properties cannot be simultaneously defined",
      () {
        expect(
          () {
            MacosPulldownButton(
              icon: CupertinoIcons.eyedropper,
              title: "test label",
              items: const [],
            );
          },
          throwsAssertionError,
        );
      },
    );

    test(
      "MacosPulldownButton's label and icon properties cannot be simultaneously missing",
      () {
        expect(
          () {
            MacosPulldownButton(
              items: const [],
            );
          },
          throwsAssertionError,
        );
      },
    );

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      const MacosPulldownButton(
        title: "test",
        items: [],
      ).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'itemHeight: 20.0',
          'noAutofocus',
          'alignment: AlignmentDirectional.centerStart',
          'menuAlignment: PulldownMenuAlignment.left',
        ],
      );
    });

    testWidgets(
      'MacosPulldownMenuItem.onTap shows alert dialog',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return Center(
                          child: MacosPulldownButton(
                        title: "test",
                        items: [
                          MacosPulldownMenuItem(
                            title: const Text('Open Alert Dialog'),
                            onTap: () => showMacosAlertDialog(
                              context: context,
                              builder: (context) => MacosAlertDialog(
                                appIcon: const MacosIcon(CupertinoIcons.eyedropper),
                                title: const Text('Title'),
                                message: const Text('Message'),
                                primaryButton: PushButton(
                                  controlSize: ControlSize.large,
                                  onPressed: Navigator.of(context).pop,
                                  child: const Text('Close'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        // Tap the pulldown button.
        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();
        // Tap the menu item to show the alert dialog.
        await tester.tap(find.text('Open Alert Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Open Alert Dialog'), findsNothing);
        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Message'), findsOneWidget);
        expect(find.text('Close'), findsOneWidget);
      },
    );
  });
}
