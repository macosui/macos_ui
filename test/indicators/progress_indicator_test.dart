import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  testWidgets('ProgressBar debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const ProgressBar(
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
        'height: 4.5',
        'trackColor: null',
        'backgroundColor: null',
        'semanticLabel: null',
      ],
    );
  });

  testWidgets('ProgressCircle debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const ProgressCircle(
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
        'radius: 10.0',
        'innerColor: null',
        'borderColor: null',
        'semanticLabel: null',
      ],
    );
  });
}
