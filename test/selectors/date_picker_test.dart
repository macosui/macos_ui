import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  group('MacosDatePicker tests', () {
    testWidgets(
      'Textual MacosDatePicker renders the expected initial date',
      (tester) async {
        final initialDate = DateTime.now().add(const Duration(days: 30));
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              disableWallpaperTinting: true,
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return Center(
                        child: MacosDatePicker(
                          onDateChanged: (date) {},
                          initialDate: initialDate,
                          style: DatePickerStyle.textual,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.text('/'), findsNWidgets(2));
        expect(find.text('${initialDate.year}'), findsOneWidget);
        if (initialDate.month == initialDate.day) {
          expect(find.text('${initialDate.day}'), findsNWidgets(2));
          expect(find.text('${initialDate.month}'), findsNWidgets(2));
        } else {
          expect(find.text('${initialDate.day}'), findsOneWidget);
          expect(find.text('${initialDate.month}'), findsOneWidget);
        }
      },
    );

    testWidgets(
      "Textual MacosDatePicker renders the today's date by default",
      (tester) async {
        final today = DateTime.now();
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              disableWallpaperTinting: true,
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return Center(
                        child: MacosDatePicker(
                          onDateChanged: (date) {},
                          style: DatePickerStyle.textual,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.text('/'), findsNWidgets(2));
        expect(find.text('${today.year}'), findsOneWidget);
        if (today.month == today.day) {
          expect(find.text('${today.day}'), findsNWidgets(2));
          expect(find.text('${today.month}'), findsNWidgets(2));
        } else {
          expect(find.text('${today.day}'), findsOneWidget);
          expect(find.text('${today.month}'), findsOneWidget);
        }
      },
    );

    testWidgets(
      'Textual MacosDatePicker renders the date with respect to "dateFormat" property',
      (tester) async {
        renderWidget(String dateFormat) => MacosApp(
              home: MacosWindow(
                disableWallpaperTinting: true,
                child: MacosScaffold(
                  children: [
                    ContentArea(
                      builder: (context, _) {
                        return Center(
                          child: MacosDatePicker(
                            initialDate: DateTime.parse('2023-04-01'),
                            onDateChanged: (date) {},
                            dateFormat: dateFormat,
                            style: DatePickerStyle.textual,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );

        getNthTextFromWidget(int index) =>
            (find.byType(Text).at(index).evaluate().first.widget as Text).data
                as String;

        await tester.pumpWidget(renderWidget('dd.mm.yyyy'));
        String firstDateElement = getNthTextFromWidget(0);
        expect(firstDateElement, '01');
        String secondDateElement = getNthTextFromWidget(1);
        expect(secondDateElement, '.');
        String thirdDateElement = getNthTextFromWidget(2);
        expect(thirdDateElement, '04');
        String fourthDateElement = getNthTextFromWidget(3);
        expect(fourthDateElement, '.');
        String fifthDateElement = getNthTextFromWidget(4);
        expect(fifthDateElement, '2023');

        await tester.pumpWidget(renderWidget('yyyy-m-d'));
        firstDateElement = getNthTextFromWidget(0);
        expect(firstDateElement, '2023');
        secondDateElement = getNthTextFromWidget(1);
        expect(secondDateElement, '-');
        thirdDateElement = getNthTextFromWidget(2);
        expect(thirdDateElement, '4');
        fourthDateElement = getNthTextFromWidget(3);
        expect(fourthDateElement, '-');
        fifthDateElement = getNthTextFromWidget(4);
        expect(fifthDateElement, '1');
      },
    );

    testWidgets(
      'Can select the date field element and change the value',
      (tester) async {
        final today = DateTime.now();
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return Center(
                        child: MacosDatePicker(
                          onDateChanged: (date) {},
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        int day = today.day;
        final dayFieldElement = find.text('${today.day}').first;
        final upCaretControl = find.byType(CustomPaint).first;
        final downCaretControl = find.byType(CustomPaint).last;
        await tester.tap(dayFieldElement);
        await tester.pumpAndSettle();
        await tester.tap(upCaretControl);
        await tester.pumpAndSettle();
        day++;
        expect(day, today.day + 1);
        await tester.tap(downCaretControl);
        await tester.pumpAndSettle();
        day--;
        expect(day, today.day);
        await tester.tap(downCaretControl);
        await tester.pumpAndSettle();
        day--;
        expect(day, today.day - 1);
      },
    );

    testWidgets(
      'Can select the month field element and change the value',
      (tester) async {
        final today = DateTime.now();
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return Center(
                        child: MacosDatePicker(
                          onDateChanged: (date) {},
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        int month = today.month;
        final monthFieldElement = find.text('${today.month}').first;
        final upCaretControl = find.byType(CustomPaint).first;
        final downCaretControl = find.byType(CustomPaint).last;
        await tester.tap(monthFieldElement);
        await tester.pumpAndSettle();
        await tester.tap(upCaretControl);
        await tester.pumpAndSettle();
        month++;
        expect(month, today.month + 1);
        await tester.tap(downCaretControl);
        await tester.pumpAndSettle();
        month--;
        expect(month, today.month);
        await tester.tap(downCaretControl);
        await tester.pumpAndSettle();
        month--;
        expect(month, today.month - 1);
      },
    );

    testWidgets(
      'Can select the month field element and change the value',
      (tester) async {
        final today = DateTime.now();
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return Center(
                        child: MacosDatePicker(
                          onDateChanged: (date) {},
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        int year = today.year;
        final yearFieldElement = find.text('${today.year}');
        final upCaretControl = find.byType(CustomPaint).first;
        final downCaretControl = find.byType(CustomPaint).last;
        await tester.tap(yearFieldElement);
        await tester.pumpAndSettle();
        await tester.tap(upCaretControl);
        await tester.pumpAndSettle();
        year++;
        expect(year, today.year + 1);
        await tester.tap(downCaretControl);
        await tester.pumpAndSettle();
        year--;
        expect(year, today.year);
        await tester.tap(downCaretControl);
        await tester.pumpAndSettle();
        year--;
        expect(year, today.year - 1);
      },
    );

    testWidgets(
      'The selected calendar day matches the expected value',
      (tester) async {
        final today = DateTime.now();
        int selectedDay = 0;
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return Center(
                        child: MacosDatePicker(
                          onDateChanged: (date) {
                            selectedDay = date.day;
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        int dayToFind = today.day == 21 ? 22 : 21;
        final dayToSelect = find.text(dayToFind.toString());
        await tester.tap(dayToSelect);
        await tester.pumpAndSettle();
        expect(selectedDay, dayToFind);
      },
    );

    testWidgets(
      'Can change the month by clicking the left and right calendar view controls',
      (tester) async {
        final today = DateTime.now();
        int selectedMonth = 0;
        DateTime? selectedDate;
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return Center(
                        child: MacosDatePicker(
                          onDateChanged: (date) {
                            selectedDate = date;
                            selectedMonth = date.month;
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        final leftControl = find.byType(MacosIcon).first;
        final rightControl = find.byType(MacosIcon).last;
        await tester.tap(leftControl);
        await tester.pumpAndSettle();
        final diff = today.difference(selectedDate!);

        // Account for going from January to December
        if (today.month == 1) {
          expect(today.subtract(diff).month, 12);
        } else {
          expect(selectedMonth, today.month - 1);
        }
        await tester.tap(rightControl);
        await tester.pumpAndSettle();
        expect(selectedMonth, today.month);
        await tester.tap(rightControl);
        await tester.pumpAndSettle();

        // Account for going from December to January
        if (today.month == 12) {
          expect(today.add(diff).month, 1);
        } else {
          expect(selectedMonth, today.month + 1);
        }
      },
    );

    testWidgets(
      'Graphical MacosDatePicker renders abbreviations based on "weekdayAbbreviations" and "monthAbbreviations" properties',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosScaffold(
                children: [
                  ContentArea(
                    builder: (context, _) {
                      return Center(
                        child: MacosDatePicker(
                          initialDate: DateTime.parse('2023-04-01'),
                          onDateChanged: (date) {},
                          weekdayAbbreviations: const [
                            'Nd',
                            'Po',
                            'Wt',
                            'Śr',
                            'Cz',
                            'Pt',
                            'So',
                          ],
                          monthAbbreviations: const [
                            'Sty',
                            'Lut',
                            'Mar',
                            'Kwi',
                            'Maj',
                            'Cze',
                            'Lip',
                            'Sie',
                            'Wrz',
                            'Paź',
                            'Lis',
                            'Gru',
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

        await tester.pumpAndSettle();

        expect(find.text('Kwi 2023'), findsOneWidget);
        expect(find.text('Nd'), findsOneWidget);
        expect(find.text('Po'), findsOneWidget);
        expect(find.text('Wt'), findsOneWidget);
        expect(find.text('Śr'), findsOneWidget);
        expect(find.text('Cz'), findsOneWidget);
        expect(find.text('Pt'), findsOneWidget);
        expect(find.text('So'), findsOneWidget);
      },
    );
  });

  testWidgets(
    'Graphical MacosDatePicker with "startWeekOnMonday" set to true shows Monday as the first day of the week',
    (tester) async {
      await tester.pumpWidget(
        MacosApp(
          home: MacosWindow(
            child: MacosScaffold(
              children: [
                ContentArea(
                  builder: (context, _) {
                    return Center(
                      child: MacosDatePicker(
                        startWeekOnMonday: true,
                        initialDate: DateTime.parse('2023-04-01'),
                        onDateChanged: (date) {},
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final dayHeadersRow = find.byType(GridView).first;
      final dayHeaders = find.descendant(
        of: dayHeadersRow,
        matching: find.byType(Text),
      );
      final firstWeekday = dayHeaders.first;
      final firstWeekdayText =
          (firstWeekday.evaluate().first.widget as Text).data;
      await tester.pumpAndSettle();

      expect(firstWeekdayText, 'Mo');

      final calendarGrid = find.byType(GridView).last;
      final dayOffsetWidgets = find.descendant(
        of: calendarGrid,
        matching: find.byType(SizedBox),
      );
      final dayOffset = dayOffsetWidgets.evaluate().length;

      expect(dayOffset, 5);
    },
  );

  // Regression test due to invalid "firstDayOfWeekIndex" implementation in MaterialLocalizations
  // issue: https://github.com/flutter/flutter/issues/122274
  // TODO: remove this once the issue is fixed and test starts failing
  testWidgets(
    'Graphical MacosDatePicker still needs "startWeekOnMonday" to show Monday as the first day of the week, even when the locale is set to something other than "en_US"',
    (tester) async {
      await tester.pumpWidget(
        MacosApp(
          supportedLocales: const [
            Locale('en', 'PL'),
          ],
          home: MacosWindow(
            child: MacosScaffold(
              children: [
                ContentArea(
                  builder: (context, _) {
                    return Center(
                      child: MacosDatePicker(
                        startWeekOnMonday: true,
                        initialDate: DateTime.parse('2023-04-01'),
                        onDateChanged: (date) {},
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final dayHeadersRow = find.byType(GridView).first;
      final dayHeaders = find.descendant(
        of: dayHeadersRow,
        matching: find.byType(Text),
      );
      final firstWeekday = dayHeaders.first;
      final firstWeekdayText =
          (firstWeekday.evaluate().first.widget as Text).data;
      await tester.pumpAndSettle();

      // The result will be 'Tu' if the fix is no longer needed and can be removed
      expect(firstWeekdayText, 'Mo');
    },
  );
}
