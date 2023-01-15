import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  testWidgets('debugFillProperties with splits = 10', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const CapacityIndicator(
      value: 50,
    ).debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'value: 50.0',
        'continuous',
        'splits: 10',
        'color: systemGreen(*color = Color(0xff34c759)*, darkColor = Color(0xff30d158), highContrastColor = Color(0xff248a3d), darkHighContrastColor = Color(0xff30db5b), resolved by: UNRESOLVED)',
        'backgroundColor: tertiarySystemGroupedBackground(*color = Color(0xfff2f2f7)*, darkColor = Color(0xff2c2c2e), highContrastColor = Color(0xffebebf0), darkHighContrastColor = Color(0xff363638), *elevatedColor = Color(0xfff2f2f7)*, darkElevatedColor = Color(0xff3a3a3c), highContrastElevatedColor = Color(0xffebebf0), darkHighContrastElevatedColor = Color(0xff444446), resolved by: UNRESOLVED)',
        'borderColor: tertiaryLabel(*color = Color(0x4c3c3c43)*, darkColor = Color(0x4cebebf5), highContrastColor = Color(0x603c3c43), darkHighContrastColor = Color(0x60ebebf5), resolved by: UNRESOLVED)',
        'semanticLabel: null',
      ],
    );
  });

  testWidgets('debugFillProperties with splits = 20', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const CapacityIndicator(
      value: 50,
      splits: 20,
    ).debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'value: 50.0',
        'continuous',
        'splits: 20',
        'color: systemGreen(*color = Color(0xff34c759)*, darkColor = Color(0xff30d158), highContrastColor = Color(0xff248a3d), darkHighContrastColor = Color(0xff30db5b), resolved by: UNRESOLVED)',
        'backgroundColor: tertiarySystemGroupedBackground(*color = Color(0xfff2f2f7)*, darkColor = Color(0xff2c2c2e), highContrastColor = Color(0xffebebf0), darkHighContrastColor = Color(0xff363638), *elevatedColor = Color(0xfff2f2f7)*, darkElevatedColor = Color(0xff3a3a3c), highContrastElevatedColor = Color(0xffebebf0), darkHighContrastElevatedColor = Color(0xff444446), resolved by: UNRESOLVED)',
        'borderColor: tertiaryLabel(*color = Color(0x4c3c3c43)*, darkColor = Color(0x4cebebf5), highContrastColor = Color(0x603c3c43), darkHighContrastColor = Color(0x60ebebf5), resolved by: UNRESOLVED)',
        'semanticLabel: null',
      ],
    );
  });
}
