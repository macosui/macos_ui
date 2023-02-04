import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

void main() {
  test('==, hashCode, copyWith basics', () {
    expect(
      const MacosScrollbarThemeData(),
      const MacosScrollbarThemeData().copyWith(),
    );
    expect(
      const MacosScrollbarThemeData().hashCode,
      const MacosScrollbarThemeData().copyWith().hashCode,
    );
  });

  test('lerps from light to dark', () {
    final actual = MacosScrollbarThemeData.lerp(
      _scrollbarThemeData,
      _scrollbarThemeDataDark,
      1,
    );

    expect(actual, _scrollbarThemeDataDark);
  });

  test('lerps from dark to light', () {
    final actual = MacosScrollbarThemeData.lerp(
      _scrollbarThemeDataDark,
      _scrollbarThemeData,
      1,
    );

    expect(actual, _scrollbarThemeData);
  });

  //FIXME: Why does this pass??
  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const MacosScrollbarThemeData().debugFillProperties(builder);

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

final _scrollbarThemeData = MacosScrollbarThemeData(
  thumbColor: Colors.grey.shade600,
);

final _scrollbarThemeDataDark = MacosScrollbarThemeData(
  thumbColor: Colors.grey.shade300,
);
