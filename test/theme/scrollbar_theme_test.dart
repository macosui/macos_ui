import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

void main() {
  test('==, hashCode, copyWith basics', () {
    expect(
      const ScrollbarThemeData(),
      const ScrollbarThemeData().copyWith(),
    );
    expect(
      const ScrollbarThemeData().hashCode,
      const ScrollbarThemeData().copyWith().hashCode,
    );
  });

  test('lerps from light to dark', () {
    final actual = ScrollbarThemeData.lerp(
      _scrollbarThemeData,
      _scrollbarThemeDataDark,
      1,
    );

    expect(actual, _scrollbarThemeDataDark);
  });

  test('lerps from dark to light', () {
    final actual = ScrollbarThemeData.lerp(
      _scrollbarThemeDataDark,
      _scrollbarThemeData,
      1,
    );

    expect(actual, _scrollbarThemeData);
  });

  //FIXME: Why does this pass??
  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const ScrollbarThemeData().debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [],
    );
  });
}

final _scrollbarThemeData = ScrollbarThemeData(
  draggingThumbColor: Colors.grey.shade600,
  hoveringThumbColor: Colors.grey.shade600,
  hoveringTrackBorderColor: Colors.grey.shade600,
  hoveringTrackColor: Colors.grey.shade600,
  thumbColor: Colors.grey.shade600,
  trackBorderColor: Colors.grey.shade600,
  trackColor: Colors.grey.shade600,
);

final _scrollbarThemeDataDark = ScrollbarThemeData(
  draggingThumbColor: Colors.grey.shade300,
  hoveringThumbColor: Colors.grey.shade300,
  hoveringTrackBorderColor: Colors.grey.shade300,
  hoveringTrackColor: Colors.grey.shade300,
  thumbColor: Colors.grey.shade300,
  trackBorderColor: Colors.grey.shade300,
  trackColor: Colors.grey.shade300,
);

