import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

void main() {
  group('MacosSegmentedControl tests', () {
    testWidgets(
      'Tapping an unselected item changes the currently selected item',
      (tester) async {
        final controller = MacosTabController(length: 3, initialIndex: 0);
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return Center(
                        child: MacosSegmentedControl(
                          controller: controller,
                          tabs: const [
                            MacosTab(
                              label: 'Tab 1',
                            ),
                            MacosTab(
                              label: 'Tab 2',
                            ),
                            MacosTab(
                              label: 'Tab 3',
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

        final macosSegmentedControl = find.byType(MacosSegmentedControl);
        expect(macosSegmentedControl, findsOneWidget);
        final secondTab = find.byType(MacosTab).at(1);
        expect(secondTab, findsOneWidget);
        await tester.tap(secondTab);
        await tester.pumpAndSettle();
        expect(controller.index, 1);
      },
    );

    testWidgets(
      'Tapping the currently selected item does nothing',
      (tester) async {
        final controller = MacosTabController(length: 3, initialIndex: 0);
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return Center(
                        child: MacosSegmentedControl(
                          controller: controller,
                          tabs: const [
                            MacosTab(
                              label: 'Tab 1',
                            ),
                            MacosTab(
                              label: 'Tab 2',
                            ),
                            MacosTab(
                              label: 'Tab 3',
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

        final macosSegmentedControl = find.byType(MacosSegmentedControl);
        expect(macosSegmentedControl, findsOneWidget);
        final firstTab = find.byType(MacosTab).first;
        expect(firstTab, findsOneWidget);
        await tester.tap(firstTab);
        await tester.pumpAndSettle();
        expect(controller.index, 0);
      },
    );
  });
}
