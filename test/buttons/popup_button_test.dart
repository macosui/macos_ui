import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

const List<String> menuItems = <String>['one', 'two', 'three', 'four'];

void main() {
  group('MacosPopupButton tests', () {
    testWidgets(
      'Can tap the MacosPopupButton and select a menu item',
      (tester) async {
        String? value = 'two';
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return MacosPopupButton<String>(
                            value: value,
                            onChanged: (String? newValue) {
                              setState(() {
                                value = newValue!;
                              });
                            },
                            items: menuItems.map<MacosPopupMenuItem<String>>(
                              (String value) {
                                return MacosPopupMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.text("two").first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('one').last);
        await tester.pumpAndSettle();
        expect(value, equals('one'));

        await tester.tap(find.text('one').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('three').last);
        await tester.pumpAndSettle();
        expect(value, equals('three'));
      },
    );

    testWidgets(
      'MacosPopupButton does not allow duplicate item values',
      (WidgetTester tester) async {
        final List<MacosPopupMenuItem<String>> itemsWithDuplicateValues =
            <String>[
          'a',
          'b',
          'c',
          'c',
        ].map<MacosPopupMenuItem<String>>((String value) {
          return MacosPopupMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();

        await expectLater(
          () => tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: MacosPopupButton<String>(
                  value: 'c',
                  onChanged: (String? newValue) {},
                  items: itemsWithDuplicateValues,
                ),
              ),
            ),
          ),
          throwsA(isAssertionError.having(
            (AssertionError error) => error.toString(),
            '.toString()',
            contains(
              "There should be exactly one item with [MacosPopupButton]'s value",
            ),
          )),
        );
      },
    );

    testWidgets(
      'MacosPopupButton value should only appear in one menu item',
      (WidgetTester tester) async {
        final List<MacosPopupMenuItem<String>> itemsWithDuplicateValues =
            <String>[
          'a',
          'b',
          'c',
          'd',
        ].map<MacosPopupMenuItem<String>>((String value) {
          return MacosPopupMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();

        await expectLater(
          () => tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: MacosPopupButton<String>(
                  value: 'e',
                  onChanged: (String? newValue) {},
                  items: itemsWithDuplicateValues,
                ),
              ),
            ),
          ),
          throwsA(isAssertionError.having(
            (AssertionError error) => error.toString(),
            '.toString()',
            contains(
              "There should be exactly one item with [MacosPopupButton]'s value",
            ),
          )),
        );
      },
    );

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      String? value = "one";
      MacosPopupButton<String>(
        value: value,
        onChanged: (String? newValue) {
          value = newValue!;
        },
        items: menuItems.map<MacosPopupMenuItem<String>>((String value) {
          return MacosPopupMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();
      // ignore: avoid_print
      print(description);
      expect(
        description,
        [
          'itemHeight: 24.0',
          'noAutofocus',
          'popupColor: null',
          'menuMaxHeight: null',
          'alignment: AlignmentDirectional.centerStart',
        ],
      );
    });
  });
}
