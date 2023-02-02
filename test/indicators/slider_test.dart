import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    MacosSlider(
      value: 0.5,
      onChanged: (newValue) {},
    ).debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'value: 0.5',
        'has onChanged',
        'min: 0.0',
        'max: 1.0',
        'color: systemBlue(*color = Color(0xff007aff)*, darkColor = Color(0xff0a84ff), highContrastColor = Color(0xff0040dd), darkHighContrastColor = Color(0xff409cff), resolved by: UNRESOLVED)',
        'backgroundColor: CupertinoDynamicColor(*color = Color(0x19000000)*, darkColor = Color(0x19ffffff), resolved by: UNRESOLVED)',
        'tickBackgroundColor: CupertinoDynamicColor(*color = Color(0xffdcdcdc)*, darkColor = Color(0xff464646), resolved by: UNRESOLVED)',
        'thumbColor: CupertinoDynamicColor(*color = Color(0xffffffff)*, darkColor = Color(0xff98989d), resolved by: UNRESOLVED)',
        'splits: 15',
        'semanticLabel: null',
      ],
    );
  });
}
