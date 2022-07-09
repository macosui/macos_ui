import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

void main() {
  test('==, hashCode, copyWith basics', () {
    expect(
      const MacosTooltipThemeData(),
      const MacosTooltipThemeData().copyWith(),
    );
    expect(
      const MacosTooltipThemeData().hashCode,
      const MacosTooltipThemeData().copyWith().hashCode,
    );
  });

  test('lerps from light to dark', () {
    final actual = MacosTooltipThemeData.lerp(
      _tooltipThemeData,
      _tooltipThemeDataDark,
      1,
    );

    expect(actual, _tooltipThemeDataDark);
  });

  test('lerps from dark to light', () {
    final actual = MacosTooltipThemeData.lerp(
      _tooltipThemeDataDark,
      _tooltipThemeData,
      1,
    );

    expect(actual, _tooltipThemeData);
  });

  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const MacosTooltipThemeData().debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'height: null',
        'verticalOffset: null',
        'padding: null',
        'margin: null',
        'decoration: null',
        'waitDuration: null',
        'showDuration: null',
        'textStyle: null',
      ],
    );
  });
}

const _tooltipThemeData = MacosTooltipThemeData(
  decoration: BoxDecoration(
    color: Colors.red,
  ),
  margin: EdgeInsets.all(6),
  padding: EdgeInsets.all(6),
  textStyle: TextStyle(
    color: Colors.black,
  ),
);

const _tooltipThemeDataDark = MacosTooltipThemeData(
  decoration: BoxDecoration(
    color: Colors.blue,
  ),
  margin: EdgeInsets.all(8),
  padding: EdgeInsets.all(8),
  textStyle: TextStyle(
    color: Colors.white,
  ),
);
