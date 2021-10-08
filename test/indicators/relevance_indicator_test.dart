import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const RelevanceIndicator(
      value: 50,
      amount: 100,
    ).debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'value: 50',
        'amount: 100',
        'barHeight: 20.0',
        'barWidth: 0.8',
        'selectedColor: label(*color = Color(0xff000000)*, darkColor = Color(0xffffffff), resolved by: UNRESOLVED)',
        'unselectedColor: secondaryLabel(*color = Color(0x993c3c43)*, darkColor = Color(0x99ebebf5), highContrastColor = Color(0xad3c3c43), darkHighContrastColor = Color(0xadebebf5), resolved by: UNRESOLVED)',
        'semanticLabel: null',
      ],
    );
  });
}
