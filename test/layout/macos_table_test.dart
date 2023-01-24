import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

@immutable
class Person {
  const Person({
    required this.firstName,
    required this.lastName,
    required this.age,
  });

  final String firstName;
  final String lastName;
  final int age;
}

void main() {
  group('MacosTable', () {
    const List<Person> people = [
      Person(firstName: "Alice", lastName: "Smith", age: 36),
      Person(firstName: "Bob", lastName: "Jones", age: 54),
      Person(firstName: "Charlie", lastName: "Brown", age: 15),
    ];
    final dataSource = MacosTableDataSource<Person>(
      columnDefinitions: [
        ColumnDefinition(
          label: "First Name",
          width: const FlexColumnWidth(),
          cellBuilder: (context, person) => Text(person.firstName),
        ),
        ColumnDefinition(
          label: "Last Name",
          width: const FlexColumnWidth(),
          cellBuilder: (context, person) => Text(person.lastName),
        ),
        ColumnDefinition(
          label: "Age",
          width: const FixedColumnWidth(100),
          cellBuilder: (context, person) => Text(person.age.toString()),
        ),
      ],
      getRowCount: () => people.length,
      getRowValue: (index) => MacosTableValue(
        key: ObjectKey(people[index]),
        value: people[index],
      ),
      changeTableOrder: (order) {
        return true;
      },
    );

    testWidgets(
      'Can order the table by tapping column headers',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosTable(
                rowHeight: 30,
                dataSource: dataSource,
              ),
            ),
          ),
        );
        expect(dataSource.tableOrder, null);
        final firstNameColumnLabel = find.text("First Name");
        expect(firstNameColumnLabel, findsOneWidget);
        await tester.tap(firstNameColumnLabel);
        await tester.pump();
        expect(dataSource.tableOrder?.column, dataSource.columnDefinitions[0]);
        expect(
          dataSource.tableOrder?.direction,
          MacosTableOrderDirection.descending,
        );
        // Reverse direction
        await tester.tap(firstNameColumnLabel);
        await tester.pump();
        expect(dataSource.tableOrder?.column, dataSource.columnDefinitions[0]);
        expect(
          dataSource.tableOrder?.direction,
          MacosTableOrderDirection.ascending,
        );
      },
    );

    testWidgets(
      'Can select a row',
      (tester) async {
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              child: MacosTable(
                rowHeight: 30,
                dataSource: dataSource,
              ),
            ),
          ),
        );
        // Select the first row
        final aliceFirstNameCell = find.text(people[0].firstName);
        expect(aliceFirstNameCell, findsOneWidget);
        await tester.tap(aliceFirstNameCell);
        var selectedRows = dataSource.selectedRows;
        expect(selectedRows.length, 1);
        expect(selectedRows[0], people[0]);
        // Select the third row
        final charlieFirstNameCell = find.text(people[2].firstName);
        expect(charlieFirstNameCell, findsOneWidget);
        await tester.tap(charlieFirstNameCell);
        selectedRows = dataSource.selectedRows;
        expect(selectedRows.length, 1);
        expect(selectedRows[0], people[2]);
      },
    );
  });
}
