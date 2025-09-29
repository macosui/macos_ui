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

    expect(description, [
      'state: "unchecked"',
      'enabled',
      'size: 14.0',
      'activeColor: null',
      'disabledColor: quaternaryLabel(*color = Color(alpha: 0.1765, red: 0.2353, green: 0.2353, blue: 0.2627, colorSpace: ColorSpace.sRGB)*, darkColor = Color(alpha: 0.1569, red: 0.9216, green: 0.9216, blue: 0.9608, colorSpace: ColorSpace.sRGB), highContrastColor = Color(alpha: 0.2588, red: 0.2353, green: 0.2353, blue: 0.2627, colorSpace: ColorSpace.sRGB), darkHighContrastColor = Color(alpha: 0.2392, red: 0.9216, green: 0.9216, blue: 0.9608, colorSpace: ColorSpace.sRGB), resolved by: UNRESOLVED)',
      'offBorderColor: tertiaryLabel(*color = Color(alpha: 0.2980, red: 0.2353, green: 0.2353, blue: 0.2627, colorSpace: ColorSpace.sRGB)*, darkColor = Color(alpha: 0.2980, red: 0.9216, green: 0.9216, blue: 0.9608, colorSpace: ColorSpace.sRGB), highContrastColor = Color(alpha: 0.3765, red: 0.2353, green: 0.2353, blue: 0.2627, colorSpace: ColorSpace.sRGB), darkHighContrastColor = Color(alpha: 0.3765, red: 0.9216, green: 0.9216, blue: 0.9608, colorSpace: ColorSpace.sRGB), resolved by: UNRESOLVED)',
      'semanticLabel: null',
    ]);
  });
}
