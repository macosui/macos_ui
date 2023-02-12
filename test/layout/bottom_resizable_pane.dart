import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  group('BottomResizablePane', () {
    const double maxHeight = 300;
    const double minHeight = 100;
    const double startHeight = 200;

    final bottomResizablePane = BottomResizablePane(
      builder: (context, scrollController) => const Text('Hello there'),
      minSize: minHeight,
      startSize: startHeight,
      maxSize: maxHeight,
    );

    final view = MacosApp(
      home: MacosWindow(
        child: MacosScaffold(
          children: [
            ContentArea(
              builder: (context) {
                return Column(
                  children: [
                    const Flexible(
                      fit: FlexFit.loose,
                      child: Center(
                        child: Text('Hello there'),
                      ),
                    ),
                    bottomResizablePane,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );

    final resizablePaneFinder = find.byWidget(bottomResizablePane);
    final dragFinder = find.descendant(
      of: resizablePaneFinder,
      matching: find.byType(GestureDetector),
    );

    const directionModifier = -1;
    const double safeDelta = 50.0 * directionModifier;
    const double overflowDelta = 500.0 * directionModifier;

    testWidgets('initial height equals startHeight', (tester) async {
      await tester.pumpWidget(view);

      var resizablePaneRenderObject =
          tester.renderObject<RenderBox>(resizablePaneFinder);
      expect(resizablePaneRenderObject.size.height, startHeight);
    });

    testWidgets('dragging wider works', (tester) async {
      await tester.pumpWidget(view);

      await tester.drag(
        dragFinder,
        const Offset(0, safeDelta),
      );
      await tester.pump();

      var resizablePaneRenderObject =
          tester.renderObject<RenderBox>(resizablePaneFinder);
      expect(
        resizablePaneRenderObject.size.height,
        startHeight + safeDelta * directionModifier,
      );
    });

    testWidgets('dragging wider respects maxHeight', (tester) async {
      await tester.pumpWidget(view);

      await tester.drag(
        dragFinder,
        const Offset(0, overflowDelta),
      );
      await tester.pump();

      var resizablePaneRenderObject =
          tester.renderObject<RenderBox>(resizablePaneFinder);
      expect(resizablePaneRenderObject.size.height, maxHeight);
    });

    testWidgets(
      'drag events past maxHeight have no effect',
      (tester) async {
        await tester.pumpWidget(view);

        final dragStartLocation = tester.getCenter(dragFinder);
        final drag = await tester.startGesture(dragStartLocation);
        await drag.moveBy(const Offset(0, overflowDelta));
        await drag.moveBy(const Offset(0, -10.0 * directionModifier));
        await drag.up();
        await tester.pump();

        var resizablePaneRenderObject =
            tester.renderObject<RenderBox>(resizablePaneFinder);
        expect(resizablePaneRenderObject.size.height, maxHeight);
      },
    );

    testWidgets('dragging narrower works', (tester) async {
      await tester.pumpWidget(view);

      await tester.drag(
        dragFinder,
        const Offset(0, -safeDelta),
      );
      await tester.pump();

      var resizablePaneRenderObject =
          tester.renderObject<RenderBox>(resizablePaneFinder);
      expect(
        resizablePaneRenderObject.size.height,
        startHeight - safeDelta * directionModifier,
      );
    });

    testWidgets('dragging narrower respects minHeight', (tester) async {
      await tester.pumpWidget(view);

      await tester.drag(
        dragFinder,
        const Offset(0, -overflowDelta),
      );
      await tester.pump();

      var resizablePaneRenderObject =
          tester.renderObject<RenderBox>(resizablePaneFinder);
      expect(resizablePaneRenderObject.size.height, minHeight);
    });

    testWidgets(
      'drag events past minHeight have no effect',
      (tester) async {
        await tester.pumpWidget(view);

        final dragStartLocation = tester.getCenter(dragFinder);
        final drag = await tester.startGesture(dragStartLocation);
        await drag.moveBy(const Offset(0, -overflowDelta));
        await drag.moveBy(const Offset(0, 10.0 * directionModifier));
        await drag.up();
        await tester.pump();

        var resizablePaneRenderObject =
            tester.renderObject<RenderBox>(resizablePaneFinder);
        expect(resizablePaneRenderObject.size.height, minHeight);
      },
    );
  });
}
