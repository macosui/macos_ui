import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:macos_ui/macos_ui.dart';

// TODO(): Remove once mock_canvas in flutter_test reaches stable.
import '../mock_canvas.dart';

void main() {
  testWidgets('debugFillProperties', (tester) async {
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

    expect(
      description,
      [
        'value: 50.0',
        'splits: 20',
        'color: systemGreen(*color = Color(0xff34c759)*, darkColor = Color(0xff30d158), highContrastColor = Color(0xff248a3d), darkHighContrastColor = Color(0xff30db5b), resolved by: UNRESOLVED)',
        'backgroundColor: tertiarySystemGroupedBackground(*color = Color(0xfff2f2f7)*, darkColor = Color(0xff2c2c2e), highContrastColor = Color(0xffebebf0), darkHighContrastColor = Color(0xff363638), *elevatedColor = Color(0xfff2f2f7)*, darkElevatedColor = Color(0xff3a3a3c), highContrastElevatedColor = Color(0xffebebf0), darkHighContrastElevatedColor = Color(0xff444446), resolved by: UNRESOLVED)',
        'borderColor: tertiaryLabel(*color = Color(0x4c3c3c43)*, darkColor = Color(0x4cebebf5), highContrastColor = Color(0x603c3c43), darkHighContrastColor = Color(0x60ebebf5), resolved by: UNRESOLVED)',
        'semanticLabel: null',
      ],
    );
  });

  testWidgets(
    'CapacityIndicator paints the correct number of segments',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 200.0,
              child: CapacityIndicator(
                value: 50,
                splits: 20,
                discrete: true,
              ),
            ),
          ),
        ),
      );

      expect(
        find.byType(CapacityIndicator),
        // each discrete segment is drawn 3 times, two times with fill, last time with stroke
        paintedExactlyCountTimes(#drawRRect, 20 * 3),
      );
    },
  );

  testWidgets(
    'CapacityIndicator paints two filled segments for value=10 and 20 segments',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 200.0,
              child: CapacityIndicator(
                value: 10,
                splits: 20,
                discrete: true,
              ),
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
