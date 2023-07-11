import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

// TODO: Test trackpad scroll
// TODO: Test trackpad fling
// TODO: Test scrollbar track UI when hovering over the scrollbar and dragging to scroll

void main() {
  const double thickness = 6;
  const double thicknessWhenDragging = 9;
  const double scaleFactor = 2;
  final ScrollController scrollController = ScrollController();

  testWidgets(
    'Scrollbar changes position when scrolled with the mouse wheel',
    (tester) async {
      final Size screenSize =
          tester.view.physicalSize / tester.view.devicePixelRatio;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: PrimaryScrollController(
              controller: scrollController,
              child: MacosTheme(
                data: MacosThemeData.light(),
                child: MacosScrollbar(
                  thickness: thickness,
                  thicknessWhileHovering: thicknessWhenDragging,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: screenSize.width * scaleFactor,
                      height: screenSize.height * scaleFactor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      const Offset scrollAmount = Offset(0.0, 5.0);
      const Offset reverseScrollAmount = Offset(0.0, -5.0);
      Offset finalPosition = Offset.zero;
      final Offset scrollEventLocation =
          tester.getCenter(find.byType(SingleChildScrollView));
      final TestPointer testPointer = TestPointer(1, PointerDeviceKind.mouse);

      testPointer.hover(scrollEventLocation);

      // Scroll down
      await tester.sendEventToBinding(testPointer.scroll(scrollAmount));
      await tester.pumpAndSettle();
      expect(scrollController.offset, scrollAmount.dy);
      // Scroll back up
      await tester.sendEventToBinding(testPointer.scroll(reverseScrollAmount));
      await tester.pumpAndSettle();
      expect(scrollController.offset, finalPosition.dy);
    },
  );
}
