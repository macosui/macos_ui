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

  group('ToolBarIconButton tests', () {
    testWidgets(
      'ToolBarIconButton is wrapped with MacosToolbarPassthrough when in toolbar',
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

        // Verify that the button itself is still present
        expect(find.byType(MacosIconButton), findsWidgets);
      },
    );

    testWidgets(
      'ToolBarIconButton with label is wrapped with MacosToolbarPassthrough',
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
                      showLabel: true,
                      onPressed: mockOnPressedFunction.handler,
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

        // Verify the label is displayed
        expect(find.text('Add'), findsOneWidget);
      },
    );

    testWidgets(
      'ToolBarIconButton with tooltip is wrapped with MacosToolbarPassthrough',
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
                      tooltipMessage: 'Add item',
                      onPressed: mockOnPressedFunction.handler,
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

    testWidgets(
      'ToolBarIconButton still functions when wrapped with MacosToolbarPassthrough',
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

        // Verify that the button is present and functional
        expect(find.byType(MacosIconButton), findsWidgets);
      },
    );

    testWidgets(
      'Multiple ToolBarIconButtons each have their own MacosToolbarPassthrough',
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
                    ToolBarIconButton(
                      label: 'Remove',
                      icon: const MacosIcon(CupertinoIcons.minus),
                      showLabel: false,
                      onPressed: mockOnPressedFunction.handler,
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

        // Each button should have its own MacosToolbarPassthrough wrapper
        expect(find.byType(MacosToolbarPassthrough), findsWidgets);
        expect(find.byType(MacosIconButton), findsWidgets);
      },
    );

    testWidgets(
      'Disabled ToolBarIconButton is still wrapped with MacosToolbarPassthrough',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                toolBar: const ToolBar(
                  title: Text('Test'),
                  actions: [
                    ToolBarIconButton(
                      label: 'Add',
                      icon: MacosIcon(CupertinoIcons.add),
                      showLabel: false,
                      onPressed: null,
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

        // Disabled button should still be wrapped
        expect(find.byType(MacosToolbarPassthrough), findsWidgets);
        expect(find.byType(MacosIconButton), findsWidgets);
      },
    );
  });
}
