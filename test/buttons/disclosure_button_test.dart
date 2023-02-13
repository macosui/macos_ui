import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

import '../mocks.dart';

void main() {
  late MockOnPressedFunction mockOnPressedFunction;

  setUp(() {
    mockOnPressedFunction = MockOnPressedFunction();
  });

  testWidgets('MacosDisclosureButton onPressed works', (tester) async {
    await tester.pumpWidget(
      MacosApp(
        home: MacosWindow(
          child: MacosScaffold(
            children: [
              ContentArea(
                builder: (context, scrollController) {
                  return MacosDisclosureButton(
                    onPressed: mockOnPressedFunction.handler,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    final disclosureButton = find.byType(MacosDisclosureButton);
    await tester.tap(disclosureButton);
    await tester.pumpAndSettle();

    expect(mockOnPressedFunction.called, 2);
  });

  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const MacosDisclosureButton().debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'fillColor: null',
        'hoverColor: null',
        'semanticLabel: null',
        'disabled',
      ],
    );
  });
}
