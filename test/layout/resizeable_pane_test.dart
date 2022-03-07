import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  group('ResizablePane', () {
    final resizablePane = ResizablePane(
      builder: (context, scrollController) => const Text('Hello there'),
      minWidth: 100,
      startWidth: 150,
      maxWidth: 300,
      resizableSide: ResizableSide.right,
    );
    final view = MacosApp(
      home: MacosWindow(
        child: MacosScaffold(
          children: [
            resizablePane,
            ContentArea(
              builder: (context, scrollController) => const Text('Hello there'),
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

    testWidgets('initialization', (tester) async {
      await tester.pumpWidget(view);

      var resizablePaneRenderObject =
          tester.renderObject<RenderBox>(resizablePaneFinder);
      expect(resizablePaneRenderObject.size.width, 150);
    });

    testWidgets('drag wider', (tester) async {
      await tester.pumpWidget(view);

      await tester.drag(
        dragFinder,
        const Offset(50, 0),
      );
      await tester.pump();

      var resizablePaneRenderObject =
          tester.renderObject<RenderBox>(resizablePaneFinder);
      expect(resizablePaneRenderObject.size.width, 200);
    });

    testWidgets('drag wider past maxWidth', (tester) async {
      await tester.pumpWidget(view);

      await tester.drag(
        dragFinder,
        const Offset(500, 0),
      );
      await tester.pump();

      var resizablePaneRenderObject =
          tester.renderObject<RenderBox>(resizablePaneFinder);
      expect(resizablePaneRenderObject.size.width, 300);
    });

    testWidgets('drag wider past maxWidth and then back', (tester) async {
      await tester.pumpWidget(view);

      final dragStartLocation = tester.getCenter(dragFinder);
      final drag = await tester.startGesture(dragStartLocation);
      await drag.moveBy(const Offset(500, 0));
      await drag.moveBy(const Offset(-50, 0));
      await drag.up();
      await tester.pump();

      var resizablePaneRenderObject =
          tester.renderObject<RenderBox>(resizablePaneFinder);
      expect(resizablePaneRenderObject.size.width, 300);
    });

    testWidgets('drag narrower', (tester) async {
      await tester.pumpWidget(view);

      await tester.drag(
        dragFinder,
        const Offset(-20, 0),
      );
      await tester.pump();

      var resizablePaneRenderObject =
          tester.renderObject<RenderBox>(resizablePaneFinder);
      expect(resizablePaneRenderObject.size.width, 130);
    });

    testWidgets('drag narrower past minWidth', (tester) async {
      await tester.pumpWidget(view);

      await tester.drag(
        dragFinder,
        const Offset(-500, 0),
      );
      await tester.pump();

      var resizablePaneRenderObject =
          tester.renderObject<RenderBox>(resizablePaneFinder);
      expect(resizablePaneRenderObject.size.width, 100);
    });

    testWidgets('drag narrower past minWidth and then back', (tester) async {
      await tester.pumpWidget(view);

      final dragStartLocation = tester.getCenter(dragFinder);
      final drag = await tester.startGesture(dragStartLocation);
      await drag.moveBy(const Offset(-500, 0));
      await drag.moveBy(const Offset(50, 0));
      await drag.up();
      await tester.pump();

      var resizablePaneRenderObject =
          tester.renderObject<RenderBox>(resizablePaneFinder);
      expect(resizablePaneRenderObject.size.width, 100);
    });

  });
}
