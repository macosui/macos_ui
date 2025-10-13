import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_window_utils/widgets/macos_toolbar_passthrough.dart';

import '../mocks.dart';

void main() {
  late MockOnPressedFunction mockOnPressedFunction;

  setUp(() {
    mockOnPressedFunction = MockOnPressedFunction();
  });

  group('CustomToolbarItem tests', () {
    testWidgets(
      'CustomToolbarItem is wrapped with MacosToolbarPassthrough when in toolbar',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                toolBar: ToolBar(
                  title: const Text('Test'),
                  actions: [
                    CustomToolbarItem(
                      inToolbarBuilder: (context) => Container(
                        width: 100,
                        height: 30,
                        color: CupertinoColors.systemBlue,
                        child: const Center(child: Text('Custom Widget')),
                      ),
                    ),
                  ],
                ),
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return const Center(child: Text('Content'));
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify that MacosToolbarPassthrough is present in the widget tree
        expect(find.byType(MacosToolbarPassthrough), findsWidgets);

        // Verify that the custom widget is still present
        expect(find.text('Custom Widget'), findsOneWidget);
      },
    );

    testWidgets(
      'CustomToolbarItem with MacosSearchField is wrapped with MacosToolbarPassthrough',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                toolBar: ToolBar(
                  title: const Text('Test'),
                  actions: [
                    CustomToolbarItem(
                      inToolbarBuilder: (context) =>
                          const SizedBox(width: 200, child: MacosSearchField()),
                    ),
                  ],
                ),
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return const Center(child: Text('Content'));
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify that MacosToolbarPassthrough is present
        expect(find.byType(MacosToolbarPassthrough), findsWidgets);

        // Verify that the search field is present
        expect(find.byType(MacosSearchField), findsOneWidget);
      },
    );

    testWidgets(
      'CustomToolbarItem with tooltip is wrapped with MacosToolbarPassthrough',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                toolBar: ToolBar(
                  title: const Text('Test'),
                  actions: [
                    CustomToolbarItem(
                      tooltipMessage: 'Custom Tooltip',
                      inToolbarBuilder: (context) => Container(
                        width: 100,
                        height: 30,
                        color: CupertinoColors.systemBlue,
                        child: const Center(child: Text('Custom Widget')),
                      ),
                    ),
                  ],
                ),
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return const Center(child: Text('Content'));
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify that MacosToolbarPassthrough is present
        expect(find.byType(MacosToolbarPassthrough), findsWidgets);

        // Verify tooltip is present
        expect(find.byType(MacosTooltip), findsOneWidget);
      },
    );

    testWidgets('CustomToolbarItem interaction still works when wrapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        MacosApp(
          home: MacosWindow(
            child: MacosScaffold(
              toolBar: ToolBar(
                title: const Text('Test'),
                actions: [
                  CustomToolbarItem(
                    inToolbarBuilder: (context) => GestureDetector(
                      onTap: mockOnPressedFunction.handler,
                      child: Container(
                        width: 100,
                        height: 30,
                        color: CupertinoColors.systemBlue,
                        child: const Center(child: Text('Tap Me')),
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                ContentArea(
                  builder: (context, _) {
                    return const Center(child: Text('Content'));
                  },
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap the custom widget
      final customWidget = find.text('Tap Me');
      expect(customWidget, findsOneWidget);

      await tester.tap(customWidget);
      await tester.pumpAndSettle();

      // Verify the callback was called
      expect(mockOnPressedFunction.called, greaterThan(0));
    });

    testWidgets(
      'Multiple CustomToolbarItems each have their own MacosToolbarPassthrough',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                toolBar: ToolBar(
                  title: const Text('Test'),
                  actions: [
                    CustomToolbarItem(
                      inToolbarBuilder: (context) => Container(
                        width: 100,
                        height: 30,
                        color: CupertinoColors.systemBlue,
                        child: const Center(child: Text('Custom 1')),
                      ),
                    ),
                    CustomToolbarItem(
                      inToolbarBuilder: (context) => Container(
                        width: 100,
                        height: 30,
                        color: CupertinoColors.systemGreen,
                        child: const Center(child: Text('Custom 2')),
                      ),
                    ),
                  ],
                ),
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return const Center(child: Text('Content'));
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Each custom item should have its own MacosToolbarPassthrough wrapper
        expect(find.byType(MacosToolbarPassthrough), findsWidgets);
        expect(find.text('Custom 1'), findsOneWidget);
        expect(find.text('Custom 2'), findsOneWidget);
      },
    );

    testWidgets(
      'Mixed toolbar with custom, icon, and pulldown items all have MacosToolbarPassthrough',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                toolBar: ToolBar(
                  title: const Text('Test'),
                  actions: [
                    ToolBarIconButton(
                      label: 'Add',
                      icon: const MacosIcon(CupertinoIcons.add),
                      showLabel: false,
                      onPressed: mockOnPressedFunction.handler,
                    ),
                    CustomToolbarItem(
                      inToolbarBuilder: (context) =>
                          const SizedBox(width: 150, child: MacosSearchField()),
                    ),
                    ToolBarPullDownButton(
                      label: 'Actions',
                      icon: CupertinoIcons.ellipsis_circle,
                      items: [
                        MacosPulldownMenuItem(
                          label: 'Item 1',
                          title: const Text('Item 1'),
                          onTap: mockOnPressedFunction.handler,
                        ),
                      ],
                    ),
                  ],
                ),
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return const Center(child: Text('Content'));
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // All three toolbar items should be wrapped with MacosToolbarPassthrough
        expect(find.byType(MacosToolbarPassthrough), findsWidgets);
        expect(find.byType(MacosIconButton), findsWidgets);
        expect(find.byType(MacosSearchField), findsWidgets);
        expect(find.byType(MacosPulldownButton), findsWidgets);
      },
    );
  });
}
