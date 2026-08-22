import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_window_utils/widgets/transparent_macos_sidebar.dart';

void main() {
  group('MacosWindow', () {
    group('Sidebar', () {
      const minWidth = 100.0;
      const maxWidth = 300.0;
      const startWidth = 150.0;
      const safeDelta = 20.0;
      const overflowDelta = 500.0;

      sidebarBuilder({
        bool dragClosed = true,
        double? dragClosedBuffer,
        double? snapToStartBuffer,
        BoxDecoration? decoration,
      }) {
        return Sidebar(
          builder: (context, scrollController) => const Text('Hello there'),
          minWidth: minWidth,
          startWidth: startWidth,
          maxWidth: maxWidth,
          dragClosed: dragClosed,
          dragClosedBuffer: dragClosedBuffer,
          snapToStartBuffer: snapToStartBuffer,
          decoration: decoration,
        );
      }

      viewBuilder(Sidebar sidebar) {
        return MacosApp(
          home: MacosWindow(
            disableWallpaperTinting: true,
            sidebar: sidebar,
            child: const MacosScaffold(children: []),
          ),
        );
      }

      final sidebarFinder = find.byType(AnimatedPositioned).at(1);
      final resizerFinder = find.byType(AnimatedPositioned).at(3);
      final backgroundFinder = find.byType(AnimatedPositioned).at(0);

      expectSidebarOpen(tester, {required double width}) {
        expect(tester.widget<AnimatedPositioned>(sidebarFinder).width, width);
        expect(tester.widget<AnimatedPositioned>(backgroundFinder).left, width);
      }

      expectSidebarClosed(tester) {
        expect(
          tester.widget<AnimatedPositioned>(sidebarFinder).width,
          minWidth,
        );
        expect(tester.widget<AnimatedPositioned>(backgroundFinder).left, 0);
      }

      // The sidebar background is painted by the DecoratedBox inside the
      // TransparentMacOSSidebar. Grabbing its decoration lets us assert what
      // color (if any) is painted for the sidebar.
      BoxDecoration sidebarDecoration(WidgetTester tester) {
        final decoratedBox = tester.widget<DecoratedBox>(
          find
              .descendant(
                of: find.byType(TransparentMacOSSidebar),
                matching: find.byType(DecoratedBox),
              )
              .first,
        );
        return decoratedBox.decoration as BoxDecoration;
      }

      group('background', () {
        testWidgets(
          'stays transparent when no decoration color is provided, so the '
          'native sidebar material shows through',
          (tester) async {
            await tester.pumpWidget(viewBuilder(sidebarBuilder()));

            expect(sidebarDecoration(tester).color, isNull);

            await tester.pump(Duration.zero);
          },
        );

        testWidgets('is painted with the provided Sidebar.decoration color', (
          tester,
        ) async {
          const color = MacosColors.systemBlueColor;
          await tester.pumpWidget(
            viewBuilder(
              sidebarBuilder(decoration: const BoxDecoration(color: color)),
            ),
          );

          expect(sidebarDecoration(tester).color, color);

          await tester.pump(Duration.zero);
        });
      });

      testWidgets('initial width equals startWidth', (tester) async {
        final sidebar = sidebarBuilder();
        final view = viewBuilder(sidebar);
        await tester.pumpWidget(view);

        expectSidebarOpen(tester, width: startWidth);

        await tester.pump(Duration.zero);
      });

      test('dragClosedBuffer defaults to half minWidth', () {
        final sidebar = sidebarBuilder();
        expect(sidebar.dragClosedBuffer, minWidth / 2);
      });

      testWidgets('dragging wider works', (tester) async {
        final view = viewBuilder(sidebarBuilder());
        await tester.pumpWidget(view);
        await tester.drag(resizerFinder, const Offset(safeDelta, 0));
        await tester.pump();

        expectSidebarOpen(tester, width: startWidth + safeDelta);

        await tester.pump(Duration.zero);
      });

      testWidgets('dragging wider respects maxWidth', (tester) async {
        final view = viewBuilder(sidebarBuilder());
        await tester.pumpWidget(view);
        await tester.drag(resizerFinder, const Offset(overflowDelta, 0));
        await tester.pump();

        expectSidebarOpen(tester, width: maxWidth);

        await tester.pump(Duration.zero);
      });

      testWidgets('drag events past maxWidth have no effect', (tester) async {
        final view = viewBuilder(sidebarBuilder());
        await tester.pumpWidget(view);
        final gesture = await tester.startGesture(
          tester.getCenter(resizerFinder),
        );
        await gesture.moveBy(const Offset(overflowDelta, 0));
        await gesture.moveBy(const Offset(-safeDelta, 0));
        await gesture.up();
        await tester.pump();

        expectSidebarOpen(tester, width: maxWidth);

        await tester.pump(Duration.zero);
      });

      testWidgets('dragging narrower works', (tester) async {
        final view = viewBuilder(sidebarBuilder());
        await tester.pumpWidget(view);
        await tester.drag(resizerFinder, const Offset(-safeDelta, 0));
        await tester.pump();

        expectSidebarOpen(tester, width: startWidth - safeDelta);

        await tester.pump(Duration.zero);
      });

      group('when dragClosed is true', () {
        testWidgets(
          'dragging narrower past minWidth but before minWidth - dragClosedBuffer does not close the sidebar',
          (tester) async {
            const dragClosedBuffer = 20.0;
            final view = viewBuilder(
              sidebarBuilder(dragClosedBuffer: dragClosedBuffer),
            );
            await tester.pumpWidget(view);
            await tester.drag(
              resizerFinder,
              const Offset(
                -((startWidth - minWidth) + dragClosedBuffer / 2),
                0,
              ),
            );
            await tester.pump();

            expectSidebarOpen(tester, width: minWidth);

            await tester.pump(Duration.zero);
          },
        );
        testWidgets('dragging narrower past minWidth closes the sidebar', (
          tester,
        ) async {
          final view = viewBuilder(sidebarBuilder());
          await tester.pumpWidget(view);
          await tester.drag(resizerFinder, const Offset(-overflowDelta, 0));
          await tester.pump();

          expectSidebarClosed(tester);

          await tester.pump(Duration.zero);
        });

        testWidgets(
          'dragging narrower past minWidth and then back reopens the sidebar',
          (tester) async {
            final view = viewBuilder(sidebarBuilder());
            await tester.pumpWidget(view);
            final gesture = await tester.startGesture(
              tester.getCenter(resizerFinder),
            );
            for (var moved = 0; moved < overflowDelta; moved += 10) {
              await gesture.moveBy(const Offset(-10, 0));
            }
            await tester.pump();

            expectSidebarClosed(tester);

            for (
              var moved = 0;
              moved < overflowDelta - safeDelta;
              moved += 10
            ) {
              await gesture.moveBy(const Offset(10, 0));
            }
            await gesture.up();
            await tester.pump();

            expectSidebarOpen(tester, width: startWidth - safeDelta);

            await tester.pump(Duration.zero);
          },
        );

        testWidgets('drag events past minWidth have no effect', (tester) async {
          final view = viewBuilder(sidebarBuilder());
          await tester.pumpWidget(view);
          final gesture = await tester.startGesture(
            tester.getCenter(resizerFinder),
          );
          await gesture.moveBy(const Offset(-overflowDelta, 0));
          await gesture.moveBy(const Offset(safeDelta, 0));
          await gesture.up();
          await tester.pump();

          expectSidebarClosed(tester);

          await tester.pump(Duration.zero);
        });
      });

      group('when dragClosed is false', () {
        testWidgets(
          'dragging narrower past minWidth does not close the sidebar',
          (tester) async {
            final view = viewBuilder(sidebarBuilder(dragClosed: false));
            await tester.pumpWidget(view);
            await tester.drag(resizerFinder, const Offset(-overflowDelta, 0));
            await tester.pump();

            expectSidebarOpen(tester, width: minWidth);

            await tester.pump(Duration.zero);
          },
        );

        testWidgets('drag events past minWidth have no effect', (tester) async {
          final view = viewBuilder(sidebarBuilder(dragClosed: false));
          await tester.pumpWidget(view);
          final gesture = await tester.startGesture(
            tester.getCenter(resizerFinder),
          );
          await gesture.moveBy(const Offset(-overflowDelta, 0));
          await gesture.moveBy(const Offset(safeDelta, 0));
          await gesture.up();
          await tester.pump();

          expectSidebarOpen(tester, width: minWidth);

          await tester.pump(Duration.zero);
        });
      });

      group('when snapToStartBuffer is set', () {
        const snapToStartBuffer = 20.0;

        testWidgets(
          'dragging from startWidth has no effect until it passes snapToStartBuffer',
          (tester) async {
            final view = viewBuilder(
              sidebarBuilder(snapToStartBuffer: snapToStartBuffer),
            );
            await tester.pumpWidget(view);

            final gesture = await tester.startGesture(
              tester.getCenter(resizerFinder),
            );
            await gesture.moveBy(const Offset(snapToStartBuffer, 0));
            await tester.pump();

            expectSidebarOpen(tester, width: startWidth);

            await gesture.moveBy(const Offset(snapToStartBuffer, 0));
            await tester.pump();

            expectSidebarOpen(
              tester,
              width: startWidth + snapToStartBuffer * 2,
            );

            await tester.pump(Duration.zero);
          },
        );

        testWidgets(
          'dragging from outside to within startWidth +/- snapToStartBuffer sets width to startWidth',
          (tester) async {
            final view = viewBuilder(
              sidebarBuilder(snapToStartBuffer: snapToStartBuffer),
            );
            await tester.pumpWidget(view);

            await tester.drag(
              resizerFinder,
              const Offset(snapToStartBuffer * 2, 0),
            );
            await tester.pump();

            expectSidebarOpen(
              tester,
              width: startWidth + snapToStartBuffer * 2,
            );

            await tester.drag(
              resizerFinder,
              const Offset(snapToStartBuffer * -1.5, 0),
            );
            await tester.pump();
            expectSidebarOpen(tester, width: startWidth);

            await tester.pump(Duration.zero);
          },
        );
      });
    });
  });
}
