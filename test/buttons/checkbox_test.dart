import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

void main() {
  testWidgets('Can check and uncheck the MacosCheckbox', (tester) async {
    bool? checked;
    await tester.pumpWidget(
      MacosApp(
        home: MacosWindow(
          child: MacosScaffold(
            children: [
              ContentArea(
                builder: (context, _) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return MacosCheckbox(
                        value: checked,
                        onChanged: (value) {
                          setState(() => checked = value);
                        },
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

    expect(
      tester.widget<MacosCheckbox>(find.byType(MacosCheckbox)).value,
      null,
    );

    await tester.tap(find.byType(MacosCheckbox));
    await tester.pumpAndSettle();
    expect(checked, true);

    await tester.tap(find.byType(MacosCheckbox));
    await tester.pumpAndSettle();
    expect(checked, false);
  });

  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    MacosCheckbox(
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
        'state: "unchecked"',
        'enabled',
        'size: 14.0',
        'activeColor: null',
        'disabledColor: quaternaryLabel(*color = Color(0x2d3c3c43)*, darkColor = Color(0x28ebebf5), highContrastColor = Color(0x423c3c43), darkHighContrastColor = Color(0x3debebf5), resolved by: UNRESOLVED)',
        'offBorderColor: tertiaryLabel(*color = Color(0x4c3c3c43)*, darkColor = Color(0x4cebebf5), highContrastColor = Color(0x603c3c43), darkHighContrastColor = Color(0x60ebebf5), resolved by: UNRESOLVED)',
        'semanticLabel: null',
      ],
    );
  });
}
