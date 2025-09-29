import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:macos_ui/macos_ui.dart';

// TODO(): Remove once mock_canvas in flutter_test reaches stable.
import '../mock_canvas.dart';

void main() {
  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const CapacityIndicator(value: 50).debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(description, [
      'value: 50.0',
      'continuous',
      'splits: 10',
      'color: systemGreen(*color = Color(alpha: 1.0000, red: 0.2039, green: 0.7804, blue: 0.3490, colorSpace: ColorSpace.sRGB)*, darkColor = Color(alpha: 1.0000, red: 0.1882, green: 0.8196, blue: 0.3451, colorSpace: ColorSpace.sRGB), highContrastColor = Color(alpha: 1.0000, red: 0.1412, green: 0.5412, blue: 0.2392, colorSpace: ColorSpace.sRGB), darkHighContrastColor = Color(alpha: 1.0000, red: 0.1882, green: 0.8588, blue: 0.3569, colorSpace: ColorSpace.sRGB), resolved by: UNRESOLVED)',
      'backgroundColor: tertiarySystemGroupedBackground(*color = Color(alpha: 1.0000, red: 0.9490, green: 0.9490, blue: 0.9686, colorSpace: ColorSpace.sRGB)*, darkColor = Color(alpha: 1.0000, red: 0.1725, green: 0.1725, blue: 0.1804, colorSpace: ColorSpace.sRGB), highContrastColor = Color(alpha: 1.0000, red: 0.9216, green: 0.9216, blue: 0.9412, colorSpace: ColorSpace.sRGB), darkHighContrastColor = Color(alpha: 1.0000, red: 0.2118, green: 0.2118, blue: 0.2196, colorSpace: ColorSpace.sRGB), *elevatedColor = Color(alpha: 1.0000, red: 0.9490, green: 0.9490, blue: 0.9686, colorSpace: ColorSpace.sRGB)*, darkElevatedColor = Color(alpha: 1.0000, red: 0.2275, green: 0.2275, blue: 0.2353, colorSpace: ColorSpace.sRGB), highContrastElevatedColor = Color(alpha: 1.0000, red: 0.9216, green: 0.9216, blue: 0.9412, colorSpace: ColorSpace.sRGB), darkHighContrastElevatedColor = Color(alpha: 1.0000, red: 0.2667, green: 0.2667, blue: 0.2745, colorSpace: ColorSpace.sRGB), resolved by: UNRESOLVED)',
      'borderColor: tertiaryLabel(*color = Color(alpha: 0.2980, red: 0.2353, green: 0.2353, blue: 0.2627, colorSpace: ColorSpace.sRGB)*, darkColor = Color(alpha: 0.2980, red: 0.9216, green: 0.9216, blue: 0.9608, colorSpace: ColorSpace.sRGB), highContrastColor = Color(alpha: 0.3765, red: 0.2353, green: 0.2353, blue: 0.2627, colorSpace: ColorSpace.sRGB), darkHighContrastColor = Color(alpha: 0.3765, red: 0.9216, green: 0.9216, blue: 0.9608, colorSpace: ColorSpace.sRGB), resolved by: UNRESOLVED)',
      'semanticLabel: null',
    ]);
  });

  testWidgets('debugFillProperties with discrete splits = 20', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const CapacityIndicator(
      value: 50,
      splits: 20,
      discrete: true,
    ).debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(description, [
      'value: 50.0',
      'splits: 20',
      'color: systemGreen(*color = Color(alpha: 1.0000, red: 0.2039, green: 0.7804, blue: 0.3490, colorSpace: ColorSpace.sRGB)*, darkColor = Color(alpha: 1.0000, red: 0.1882, green: 0.8196, blue: 0.3451, colorSpace: ColorSpace.sRGB), highContrastColor = Color(alpha: 1.0000, red: 0.1412, green: 0.5412, blue: 0.2392, colorSpace: ColorSpace.sRGB), darkHighContrastColor = Color(alpha: 1.0000, red: 0.1882, green: 0.8588, blue: 0.3569, colorSpace: ColorSpace.sRGB), resolved by: UNRESOLVED)',
      'backgroundColor: tertiarySystemGroupedBackground(*color = Color(alpha: 1.0000, red: 0.9490, green: 0.9490, blue: 0.9686, colorSpace: ColorSpace.sRGB)*, darkColor = Color(alpha: 1.0000, red: 0.1725, green: 0.1725, blue: 0.1804, colorSpace: ColorSpace.sRGB), highContrastColor = Color(alpha: 1.0000, red: 0.9216, green: 0.9216, blue: 0.9412, colorSpace: ColorSpace.sRGB), darkHighContrastColor = Color(alpha: 1.0000, red: 0.2118, green: 0.2118, blue: 0.2196, colorSpace: ColorSpace.sRGB), *elevatedColor = Color(alpha: 1.0000, red: 0.9490, green: 0.9490, blue: 0.9686, colorSpace: ColorSpace.sRGB)*, darkElevatedColor = Color(alpha: 1.0000, red: 0.2275, green: 0.2275, blue: 0.2353, colorSpace: ColorSpace.sRGB), highContrastElevatedColor = Color(alpha: 1.0000, red: 0.9216, green: 0.9216, blue: 0.9412, colorSpace: ColorSpace.sRGB), darkHighContrastElevatedColor = Color(alpha: 1.0000, red: 0.2667, green: 0.2667, blue: 0.2745, colorSpace: ColorSpace.sRGB), resolved by: UNRESOLVED)',
      'borderColor: tertiaryLabel(*color = Color(alpha: 0.2980, red: 0.2353, green: 0.2353, blue: 0.2627, colorSpace: ColorSpace.sRGB)*, darkColor = Color(alpha: 0.2980, red: 0.9216, green: 0.9216, blue: 0.9608, colorSpace: ColorSpace.sRGB), highContrastColor = Color(alpha: 0.3765, red: 0.2353, green: 0.2353, blue: 0.2627, colorSpace: ColorSpace.sRGB), darkHighContrastColor = Color(alpha: 0.3765, red: 0.9216, green: 0.9216, blue: 0.9608, colorSpace: ColorSpace.sRGB), resolved by: UNRESOLVED)',
      'semanticLabel: null',
    ]);
  });

  testWidgets('CapacityIndicator paints the correct number of segments', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 200.0,
            child: CapacityIndicator(value: 50, splits: 20, discrete: true),
          ),
        ),
      ),
    );

    expect(
      find.byType(CapacityIndicator),
      // each discrete segment is drawn 3 times, two times with fill, last time with stroke
      paintedExactlyCountTimes(#drawRRect, 20 * 3),
    );
  });

  testWidgets(
    'CapacityIndicator paints two filled segments for value=10 and 20 segments',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 200.0,
              child: CapacityIndicator(value: 10, splits: 20, discrete: true),
            ),
          ),
        ),
      );

      expect(
        find.byType(CapacityIndicator),
        // each discrete segment is drawn 3 times, background - fill - stroke
        // a filled segment is drawn by fromLTRBR  with LTRB=0,0,8,16
        // an empty segment is drawnby fromLTRBAndCorners with LTRB=0,0,0,16
        painted
          ..rrect(
            rrect: RRect.fromLTRBR(
              0.0,
              0.0,
              8.0,
              16.0,
              const Radius.circular(2.0),
            ),
          )
          ..rrect(
            rrect: RRect.fromLTRBR(
              0.0,
              0.0,
              8.0,
              16.0,
              const Radius.circular(2.0),
            ),
          )
          ..rrect(
            rrect: RRect.fromLTRBR(
              0.0,
              0.0,
              8.0,
              16.0,
              const Radius.circular(2.0),
            ),
          )
          ..translate(x: 10.0, y: 0.0)
          ..rrect(
            rrect: RRect.fromLTRBR(
              0.0,
              0.0,
              8.0,
              16.0,
              const Radius.circular(2.0),
            ),
          )
          ..rrect(
            rrect: RRect.fromLTRBR(
              0.0,
              0.0,
              8.0,
              16.0,
              const Radius.circular(2.0),
            ),
          )
          ..rrect(
            rrect: RRect.fromLTRBR(
              0.0,
              0.0,
              8.0,
              16.0,
              const Radius.circular(2.0),
            ),
          )
          ..translate(x: 20.0, y: 0.0)
          ..rrect(
            rrect: RRect.fromLTRBR(
              0.0,
              0.0,
              8.0,
              16.0,
              const Radius.circular(2.0),
            ),
          )
          ..rrect(
            rrect: RRect.fromLTRBAndCorners(
              0.0,
              0.0,
              0.0,
              16.0,
              topLeft: const Radius.circular(2.0),
              topRight: const Radius.circular(0.0),
              bottomRight: const Radius.circular(0.0),
              bottomLeft: const Radius.circular(2.0),
            ),
          ),
      );
    },
  );
}
