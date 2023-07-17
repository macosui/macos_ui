import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  const matrix = ResizableSide.values;

  group('ResizablePane', () {
    const double maxSize = 300;
    const double minSize = 100;
    const double startSize = 200;

    for (var side in matrix) {
      bool verticallyResizable = side == ResizableSide.top;

      group(
        side == ResizableSide.top
            ? 'top'
            : (side == ResizableSide.left ? 'left' : 'right'),
        () {
          final resizablePane = ResizablePane(
            builder: (context, scrollController) => const Text('Hello there'),
            minSize: minSize,
            startSize: startSize,
            maxSize: maxSize,
            resizableSide: side,
          );

          final view = side == ResizableSide.top
              ? MacosApp(
                  home: MacosWindow(
                    disableWallpaperTinting: true,
                    child: MacosScaffold(
                      children: [
                        ContentArea(
                          builder: (context, scrollController) {
                            return Column(
                              children: [
                                const Flexible(
                                  fit: FlexFit.loose,
                                  child: Center(
                                    child: Text('Hello there'),
                                  ),
                                ),
                                resizablePane,
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : MacosApp(
                  home: MacosWindow(
                    disableWallpaperTinting: true,
                    child: MacosScaffold(
                      children: [
                        resizablePane,
                        ContentArea(
                          builder: (context, scrollController) {
                            return const Text('Hello there');
                          },
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

          // No need to check if the resizable side is top because directionModifier
          // would take -1 if it is the case
          final directionModifier = side == ResizableSide.right ? 1 : -1;
          final double safeDelta = 50.0 * directionModifier;
          final double overflowDelta = 500.0 * directionModifier;

          testWidgets(
            'Default ResizablePane Constructor comes with an internal MacosScrollBar',
            (WidgetTester tester) async {
              await tester.pumpWidget(view);
              expect(find.byType(MacosScrollbar), findsOneWidget);
            },
          );

          testWidgets('initial size equals startSize', (tester) async {
            await tester.pumpWidget(view);

            var resizablePaneRenderObject =
                tester.renderObject<RenderBox>(resizablePaneFinder);
            var initialSize = verticallyResizable
                ? resizablePaneRenderObject.size.height
                : resizablePaneRenderObject.size.width;

            expect(initialSize, startSize);
          });

          testWidgets('dragging wider works $side', (tester) async {
            await tester.pumpWidget(view);

            await tester.drag(
              dragFinder,
              verticallyResizable ? Offset(0, safeDelta) : Offset(safeDelta, 0),
            );
            await tester.pump();

            var resizablePaneRenderObject =
                tester.renderObject<RenderBox>(resizablePaneFinder);
            expect(
              verticallyResizable
                  ? resizablePaneRenderObject.size.height
                  : resizablePaneRenderObject.size.width,
              startSize + safeDelta * directionModifier,
            );
          });

          testWidgets('dragging wider respects maxSize', (tester) async {
            await tester.pumpWidget(view);

            await tester.drag(
              dragFinder,
              verticallyResizable
                  ? Offset(0, overflowDelta)
                  : Offset(overflowDelta, 0),
            );
            await tester.pump();

            var resizablePaneRenderObject =
                tester.renderObject<RenderBox>(resizablePaneFinder);
            var currentSize = verticallyResizable
                ? resizablePaneRenderObject.size.height
                : resizablePaneRenderObject.size.width;
            expect(currentSize, maxSize);
          });

          testWidgets(
            'drag events past maxSize have no effect $side',
            (tester) async {
              await tester.pumpWidget(view);

              final dragStartLocation = tester.getCenter(dragFinder);
              final drag = await tester.startGesture(dragStartLocation);
              await drag.moveBy(
                verticallyResizable
                    ? Offset(0, overflowDelta)
                    : Offset(overflowDelta, 0),
              );
              await drag.moveBy(
                verticallyResizable
                    ? Offset(0, -10.0 * directionModifier)
                    : Offset(-10.0 * directionModifier, 0),
              );
              await drag.up();
              await tester.pump();

              var resizablePaneRenderObject =
                  tester.renderObject<RenderBox>(resizablePaneFinder);
              var currentSize = verticallyResizable
                  ? resizablePaneRenderObject.size.height
                  : resizablePaneRenderObject.size.width;
              expect(currentSize, maxSize);
            },
          );

          testWidgets('dragging narrower works', (tester) async {
            await tester.pumpWidget(view);

            await tester.drag(
              dragFinder,
              verticallyResizable
                  ? Offset(0, -safeDelta)
                  : Offset(-safeDelta, 0),
            );
            await tester.pump();

            var resizablePaneRenderObject =
                tester.renderObject<RenderBox>(resizablePaneFinder);
            var currentSize = verticallyResizable
                ? resizablePaneRenderObject.size.height
                : resizablePaneRenderObject.size.width;
            expect(
              currentSize,
              startSize - safeDelta * directionModifier,
            );
          });

          testWidgets('dragging narrower respects minSize', (tester) async {
            await tester.pumpWidget(view);

            await tester.drag(
              dragFinder,
              verticallyResizable
                  ? Offset(0, -overflowDelta)
                  : Offset(-overflowDelta, 0),
            );
            await tester.pump();

            var resizablePaneRenderObject =
                tester.renderObject<RenderBox>(resizablePaneFinder);
            var currentSize = verticallyResizable
                ? resizablePaneRenderObject.size.height
                : resizablePaneRenderObject.size.width;
            expect(currentSize, minSize);
          });

          testWidgets(
            'drag events past minSize have no effect',
            (tester) async {
              await tester.pumpWidget(view);

              final dragStartLocation = tester.getCenter(dragFinder);
              final drag = await tester.startGesture(dragStartLocation);
              await drag.moveBy(
                verticallyResizable
                    ? Offset(0, -overflowDelta)
                    : Offset(-overflowDelta, 0),
              );
              await drag.moveBy(
                verticallyResizable
                    ? Offset(0, 10.0 * directionModifier)
                    : Offset(10.0 * directionModifier, 0),
              );
              await drag.up();
              await tester.pump();

              var resizablePaneRenderObject =
                  tester.renderObject<RenderBox>(resizablePaneFinder);
              var currentSize = verticallyResizable
                  ? resizablePaneRenderObject.size.height
                  : resizablePaneRenderObject.size.width;
              expect(currentSize, minSize);
            },
          );
        },
      );
      group(
        side == ResizableSide.top
            ? 'top'
            : (side == ResizableSide.left ? 'left' : 'right'),
        () {
          final resizablePane = ResizablePane.noScrollBar(
            minSize: minSize,
            startSize: startSize,
            maxSize: maxSize,
            resizableSide: side,
            child: const Text('Hello there'),
          );

          final view = side == ResizableSide.top
              ? MacosApp(
                  home: MacosWindow(
                    disableWallpaperTinting: true,
                    child: MacosScaffold(
                      children: [
                        ContentArea(
                          builder: (context, scrollController) {
                            return Column(
                              children: [
                                const Flexible(
                                  fit: FlexFit.loose,
                                  child: Center(
                                    child: Text('Hello there'),
                                  ),
                                ),
                                resizablePane,
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : MacosApp(
                  home: MacosWindow(
                    disableWallpaperTinting: true,
                    child: MacosScaffold(
                      children: [
                        resizablePane,
                        ContentArea(
                          builder: (context, scrollController) {
                            return const Text('Hello there');
                          },
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

          // No need to check if the resizable side is top because directionModifier
          // would take -1 if it is the case
          final directionModifier = side == ResizableSide.right ? 1 : -1;
          final double safeDelta = 50.0 * directionModifier;
          final double overflowDelta = 500.0 * directionModifier;

          testWidgets(
            'ResizablePane.noScrollBar Constructor does not come with an internal MacosScrollBar',
            (WidgetTester tester) async {
              await tester.pumpWidget(view);
              expect(find.byType(MacosScrollbar), findsNothing);
            },
          );

          testWidgets('initial size equals startSize', (tester) async {
            await tester.pumpWidget(view);

            var resizablePaneRenderObject =
                tester.renderObject<RenderBox>(resizablePaneFinder);
            var initialSize = verticallyResizable
                ? resizablePaneRenderObject.size.height
                : resizablePaneRenderObject.size.width;

            expect(initialSize, startSize);
          });

          testWidgets('dragging wider works $side', (tester) async {
            await tester.pumpWidget(view);

            await tester.drag(
              dragFinder,
              verticallyResizable ? Offset(0, safeDelta) : Offset(safeDelta, 0),
            );
            await tester.pump();

            var resizablePaneRenderObject =
                tester.renderObject<RenderBox>(resizablePaneFinder);
            expect(
              verticallyResizable
                  ? resizablePaneRenderObject.size.height
                  : resizablePaneRenderObject.size.width,
              startSize + safeDelta * directionModifier,
            );
          });

          testWidgets('dragging wider respects maxSize', (tester) async {
            await tester.pumpWidget(view);

            await tester.drag(
              dragFinder,
              verticallyResizable
                  ? Offset(0, overflowDelta)
                  : Offset(overflowDelta, 0),
            );
            await tester.pump();

            var resizablePaneRenderObject =
                tester.renderObject<RenderBox>(resizablePaneFinder);
            var currentSize = verticallyResizable
                ? resizablePaneRenderObject.size.height
                : resizablePaneRenderObject.size.width;
            expect(currentSize, maxSize);
          });

          testWidgets(
            'drag events past maxSize have no effect $side',
            (tester) async {
              await tester.pumpWidget(view);

              final dragStartLocation = tester.getCenter(dragFinder);
              final drag = await tester.startGesture(dragStartLocation);
              await drag.moveBy(
                verticallyResizable
                    ? Offset(0, overflowDelta)
                    : Offset(overflowDelta, 0),
              );
              await drag.moveBy(
                verticallyResizable
                    ? Offset(0, -10.0 * directionModifier)
                    : Offset(-10.0 * directionModifier, 0),
              );
              await drag.up();
              await tester.pump();

              var resizablePaneRenderObject =
                  tester.renderObject<RenderBox>(resizablePaneFinder);
              var currentSize = verticallyResizable
                  ? resizablePaneRenderObject.size.height
                  : resizablePaneRenderObject.size.width;
              expect(currentSize, maxSize);
            },
          );

          testWidgets('dragging narrower works', (tester) async {
            await tester.pumpWidget(view);

            await tester.drag(
              dragFinder,
              verticallyResizable
                  ? Offset(0, -safeDelta)
                  : Offset(-safeDelta, 0),
            );
            await tester.pump();

            var resizablePaneRenderObject =
                tester.renderObject<RenderBox>(resizablePaneFinder);
            var currentSize = verticallyResizable
                ? resizablePaneRenderObject.size.height
                : resizablePaneRenderObject.size.width;
            expect(
              currentSize,
              startSize - safeDelta * directionModifier,
            );
          });

          testWidgets('dragging narrower respects minSize', (tester) async {
            await tester.pumpWidget(view);

            await tester.drag(
              dragFinder,
              verticallyResizable
                  ? Offset(0, -overflowDelta)
                  : Offset(-overflowDelta, 0),
            );
            await tester.pump();

            var resizablePaneRenderObject =
                tester.renderObject<RenderBox>(resizablePaneFinder);
            var currentSize = verticallyResizable
                ? resizablePaneRenderObject.size.height
                : resizablePaneRenderObject.size.width;
            expect(currentSize, minSize);
          });

          testWidgets(
            'drag events past minSize have no effect',
            (tester) async {
              await tester.pumpWidget(view);

              final dragStartLocation = tester.getCenter(dragFinder);
              final drag = await tester.startGesture(dragStartLocation);
              await drag.moveBy(
                verticallyResizable
                    ? Offset(0, -overflowDelta)
                    : Offset(-overflowDelta, 0),
              );
              await drag.moveBy(
                verticallyResizable
                    ? Offset(0, 10.0 * directionModifier)
                    : Offset(10.0 * directionModifier, 0),
              );
              await drag.up();
              await tester.pump();

              var resizablePaneRenderObject =
                  tester.renderObject<RenderBox>(resizablePaneFinder);
              var currentSize = verticallyResizable
                  ? resizablePaneRenderObject.size.height
                  : resizablePaneRenderObject.size.width;
              expect(currentSize, minSize);
            },
          );
        },
      );
    }
  });
}
