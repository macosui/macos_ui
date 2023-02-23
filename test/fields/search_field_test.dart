import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

void main() {
  testWidgets(
    'Can input a search query and display suggestions accordingly',
    (tester) async {
      const List<String> kOptions = <String>[
        'aardvark',
        'bobcat',
        'chameleon',
        'dingo',
        'elephant',
        'flamingo',
        'goose',
        'hippopotamus',
        'iguana',
        'jaguar',
        'koala',
        'lemur',
        'mouse',
        'northern white rhinoceros',
      ];
      final controller = TextEditingController();
      await tester.pumpWidget(
        MacosApp(
          home: MacosWindow(
            child: MacosScaffold(
              children: [
                ContentArea(
                  builder: (context, _) {
                    return Center(
                      child: SizedBox(
                        width: 300.0,
                        height: 500.0,
                        child: MacosSearchField(
                          results:
                              kOptions.map((e) => SearchResultItem(e)).toList(),
                          controller: controller,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      // The field is always rendered, but the options are not unless needed.
      expect(find.byType(MacosSearchField), findsOneWidget);
      expect(find.byType(ListView), findsNothing);

      // Focus the empty MacosTextField (contained within MacosSearchField).
      await tester.tap(find.byType(MacosTextField));
      // Enter text. The options are filtered by the text.
      await tester.enterText(find.byType(MacosTextField), 'ele');
      await tester.pump();
      expect(controller.text, 'ele');
      await tester.pumpAndSettle();
      expect(find.byType(MacosTextField), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      ListView list = find.byType(ListView).evaluate().first.widget as ListView;
      // 'chameleon' and 'elephant' are displayed.
      expect(list.semanticChildCount, 2);

      await tester.ensureVisible(find.text('elephant'));
      await tester.pump();

      await tester.tap(find.text('elephant'));
      await tester.pump();

      expect(controller.text, 'elephant');
      expect(find.byType(ListView), findsNothing);
    },
  );
}
