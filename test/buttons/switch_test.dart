import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

void main() {
  testWidgets('Toggle switch', (tester) async {
    bool selected = false;
    await tester.pumpWidget(
      MacosApp(
        home: MacosWindow(
          child: MacosScaffold(
            children: [
              ContentArea(
                builder: (context, _) {
                  return Center(
                    child: MacosSwitch(
                      value: selected,
                      onChanged: (value) {
                        selected = value;
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

    final macosSwitch = find.byType(MacosSwitch);
    expect(macosSwitch, findsOneWidget);
    await tester.tap(macosSwitch);
    await tester.pumpAndSettle();
    expect(selected, true);
  });

  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    MacosSwitch(
      value: false,
      onChanged: (value) {},
    ).debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'unchecked',
        'size: regular',
        'dragStartBehavior: start',
        'disabled',
        'activeColor: null',
        'trackColor: null',
        'knobColor: null',
        'semanticLabel: null',
      ],
    );
  });
}
