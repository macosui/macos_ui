import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  final matrix = ResizableSide.values;

  group('ResizablePane', () {
    for (var side in matrix) {
      group('${side == ResizableSide.left ? "left" : "right"}', () {
        const double maxWidth = 300;
        const double minWidth = 100;
        const double startWidth = 200;

        final resizablePane = ResizablePane(
          builder: (context, scrollController) => const Text('Hello there'),
          minWidth: minWidth,
          startWidth: startWidth,
          maxWidth: maxWidth,
          resizableSide: side,
        );

        final view = MacosApp(
          home: MacosWindow(
            child: MacosScaffold(
              children: [
                resizablePane,
                ContentArea(
                  builder: (context, scrollController) =>
                      const Text('Hello there'),
                ),
              ],
            ),
          ),
        );

        final resizablePaneFinder = find.byWidget(resizablePane);
        final dragFinder = find.descendant(
          of: resizablePaneFinder,
          matching: find.byType(GestureDetector),
        );

        final directionModifier = side == ResizableSide.right ? 1 : -1;
        final double safeDelta = 50.0 * directionModifier;
        final double overflowDelta = 500.0 * directionModifier;

        testWidgets('initial width equals startWidth', (tester) async {
          await tester.pumpWidget(view);

          var resizablePaneRenderObject =
              tester.renderObject<RenderBox>(resizablePaneFinder);
          expect(resizablePaneRenderObject.size.width, startWidth);
        });

        testWidgets('dragging wider works', (tester) async {
          await tester.pumpWidget(view);

          await tester.drag(
            dragFinder,
            Offset(safeDelta, 0),
          );
          await tester.pump();

          var resizablePaneRenderObject =
              tester.renderObject<RenderBox>(resizablePaneFinder);
          expect(
            resizablePaneRenderObject.size.width,
            startWidth + safeDelta * directionModifier,
          );
        });

        testWidgets('dragging wider respects maxWidth', (tester) async {
          await tester.pumpWidget(view);

          await tester.drag(
            dragFinder,
            Offset(overflowDelta, 0),
          );
          await tester.pump();

          var resizablePaneRenderObject =
              tester.renderObject<RenderBox>(resizablePaneFinder);
          expect(resizablePaneRenderObject.size.width, maxWidth);
        });

        testWidgets(
          'drag events past maxWidth have no effect',
          (tester) async {
            await tester.pumpWidget(view);

            final dragStartLocation = tester.getCenter(dragFinder);
            final drag = await tester.startGesture(dragStartLocation);
            await drag.moveBy(Offset(overflowDelta, 0));
            await drag.moveBy(Offset(-10.0 * directionModifier, 0));
            await drag.up();
            await tester.pump();

            var resizablePaneRenderObject =
                tester.renderObject<RenderBox>(resizablePaneFinder);
            expect(resizablePaneRenderObject.size.width, maxWidth);
          },
        );

        testWidgets('dragging narrower works', (tester) async {
          await tester.pumpWidget(view);

          await tester.drag(
            dragFinder,
            Offset(-safeDelta, 0),
          );
          await tester.pump();

          var resizablePaneRenderObject =
              tester.renderObject<RenderBox>(resizablePaneFinder);
          expect(
            resizablePaneRenderObject.size.width,
            startWidth - safeDelta * directionModifier,
          );
        });

        testWidgets('dragging narrower respects minWidth', (tester) async {
          await tester.pumpWidget(view);

          await tester.drag(
            dragFinder,
            Offset(-overflowDelta, 0),
          );
          await tester.pump();

          var resizablePaneRenderObject =
              tester.renderObject<RenderBox>(resizablePaneFinder);
          expect(resizablePaneRenderObject.size.width, minWidth);
        });

        testWidgets(
          'drag events past minWidth have no effect',
          (tester) async {
            await tester.pumpWidget(view);

            final dragStartLocation = tester.getCenter(dragFinder);
            final drag = await tester.startGesture(dragStartLocation);
            await drag.moveBy(Offset(-overflowDelta, 0));
            await drag.moveBy(Offset(10.0 * directionModifier, 0));
            await drag.up();
            await tester.pump();

            var resizablePaneRenderObject =
                tester.renderObject<RenderBox>(resizablePaneFinder);
            expect(resizablePaneRenderObject.size.width, minWidth);
          },
        );
      });
    }
  });
}
