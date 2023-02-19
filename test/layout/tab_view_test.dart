import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

void main() {
  group('MacosTabView tests', () {
    testWidgets(
      'Tapping a tab changes the child in view',
      (tester) async {
        final controller = MacosTabController(length: 3, initialIndex: 0);
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: MacosTabView(
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
                          children: const [
                            Center(
                              child: Text('Tab child 1'),
                            ),
                            Center(
                              child: Text('Tab child 2'),
                            ),
                            Center(
                              child: Text('Tab child 3'),
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

        final segmentedControl = find.byType(MacosSegmentedControl);
        expect(segmentedControl, findsOneWidget);
        final secondTab = find.byType(MacosTab).at(1);
        expect(secondTab, findsOneWidget);
        await tester.tap(secondTab);
        await tester.pumpAndSettle();
        expect(controller.index, 1);
      },
    );
  });
}
