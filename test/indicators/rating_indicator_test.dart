import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const RatingIndicator(
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
        'ratedIcon: IconData(U+0F822)',
        'unratedIcon: IconData(U+0F81F)',
        'iconColor: null',
        'iconSize: 16.0',
        'amount: 100',
        'value: 50.0',
        'semanticLabel: null',
      ],
    );
  });
}
