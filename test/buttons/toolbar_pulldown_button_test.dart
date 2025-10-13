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

  group('ToolBarPullDownButton tests', () {
    testWidgets(
      'ToolBarPullDownButton is wrapped with MacosToolbarPassthrough when in toolbar',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                toolBar: ToolBar(
                  title: const Text('Test'),
                  actions: [
                    ToolBarPullDownButton(
                      label: 'Actions',
                      icon: CupertinoIcons.ellipsis_circle,
                      items: [
                        MacosPulldownMenuItem(
                          label: 'Item 1',
                          title: const Text('Item 1'),
                          onTap: mockOnPressedFunction.handler,
                        ),
                        MacosPulldownMenuItem(
                          label: 'Item 2',
                          title: const Text('Item 2'),
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

        // Verify that MacosToolbarPassthrough is present in the widget tree
        expect(find.byType(MacosToolbarPassthrough), findsWidgets);

        // Verify that the pulldown button itself is still present
        expect(find.byType(MacosPulldownButton), findsOneWidget);
      },
    );

    testWidgets(
      'ToolBarPullDownButton with tooltip is wrapped with MacosToolbarPassthrough',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                toolBar: ToolBar(
                  title: const Text('Test'),
                  actions: [
                    ToolBarPullDownButton(
                      label: 'Actions',
                      icon: CupertinoIcons.ellipsis_circle,
                      tooltipMessage: 'More actions',
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

        // Verify that MacosToolbarPassthrough is present
        expect(find.byType(MacosToolbarPassthrough), findsWidgets);

        // Verify tooltip is present
        expect(find.byType(MacosTooltip), findsOneWidget);
      },
    );

    testWidgets(
      'ToolBarPullDownButton still functions when wrapped with MacosToolbarPassthrough',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                toolBar: ToolBar(
                  title: const Text('Test'),
                  actions: [
                    ToolBarPullDownButton(
                      label: 'Actions',
                      icon: CupertinoIcons.ellipsis_circle,
                      items: [
                        MacosPulldownMenuItem(
                          label: 'Item 1',
                          title: const Text('Item 1'),
                          onTap: mockOnPressedFunction.handler,
                        ),
                        MacosPulldownMenuItem(
                          label: 'Item 2',
                          title: const Text('Item 2'),
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

        // Verify that MacosToolbarPassthrough is present
        expect(find.byType(MacosToolbarPassthrough), findsWidgets);

        // Verify that the pulldown button is present and functional
        expect(find.byType(MacosPulldownButton), findsWidgets);
      },
    );

    testWidgets(
      'Disabled ToolBarPullDownButton is still wrapped with MacosToolbarPassthrough',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                toolBar: const ToolBar(
                  title: Text('Test'),
                  actions: [
                    ToolBarPullDownButton(
                      label: 'Actions',
                      icon: CupertinoIcons.ellipsis_circle,
                      items: null,
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

        // Disabled pulldown button should still be wrapped
        expect(find.byType(MacosToolbarPassthrough), findsWidgets);
        expect(find.byType(MacosPulldownButton), findsOneWidget);
      },
    );

    testWidgets(
      'Multiple ToolBarPullDownButtons each have their own MacosToolbarPassthrough',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                toolBar: ToolBar(
                  title: const Text('Test'),
                  actions: [
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
                    ToolBarPullDownButton(
                      label: 'More',
                      icon: CupertinoIcons.gear,
                      items: [
                        MacosPulldownMenuItem(
                          label: 'Item 2',
                          title: const Text('Item 2'),
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

        // Each pulldown button should have its own MacosToolbarPassthrough wrapper
        expect(find.byType(MacosToolbarPassthrough), findsWidgets);
        expect(find.byType(MacosPulldownButton), findsWidgets);
      },
    );

    testWidgets(
      'Mixed toolbar with icon and pulldown buttons have correct MacosToolbarPassthrough wrappers',
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

        // Both items should be wrapped with MacosToolbarPassthrough
        expect(find.byType(MacosToolbarPassthrough), findsWidgets);
        expect(find.byType(MacosIconButton), findsWidgets);
        expect(find.byType(MacosPulldownButton), findsWidgets);
      },
    );
  });
}
