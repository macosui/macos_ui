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

    group('a hidden start sidebar is off-screen and out of input', () {
      const probeKey = Key('sidebar probe');
      const probeLabel = 'sidebar probe';
      late FocusNode probeFocus;
      late BuildContext contentContext;

      setUp(() => probeFocus = FocusNode(debugLabel: probeLabel));
      tearDown(() => probeFocus.dispose());

      final sidebarFinder = find.byType(AnimatedPositioned).at(1);
      final resizerFinder = find.byType(AnimatedPositioned).at(3);

      // The content paints nothing, as a ContentArea does, so anything the
      // sidebar leaves beneath it shows through.
      pumpWindow(WidgetTester tester, {double width = 1000}) async {
        tester.view.physicalSize = Size(width, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              disableWallpaperTinting: true,
              sidebar: Sidebar(
                minWidth: 100,
                startWidth: 150,
                maxWidth: 300,
                windowBreakpoint: 700,
                builder: (context, scrollController) => Focus(
                  focusNode: probeFocus,
                  child: Semantics(
                    label: probeLabel,
                    // A ColoredBox takes hits; a childless SizedBox never
                    // does, so it could not show whether the sidebar does.
                    child: const ColoredBox(
                      key: probeKey,
                      color: MacosColors.systemRedColor,
                      child: SizedBox.expand(),
                    ),
                  ),
                ),
              ),
              child: ContentArea(
                builder: (context, scrollController) {
                  contentContext = context;
                  return const SizedBox.expand();
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }

      // find.semantics searches the live tree; find.bySemanticsLabel can
      // still report a node after it has been excluded.
      expectHidden(WidgetTester tester) {
        expect(
          tester.getRect(find.byKey(probeKey)).right,
          lessThanOrEqualTo(0),
        );
        expect(find.byKey(probeKey).hitTestable(), findsNothing);
        expect(probeFocus.canRequestFocus, isFalse);
        expect(find.semantics.byLabel(probeLabel), findsNothing);
      }

      expectShown(WidgetTester tester) {
        expect(
          tester.getRect(sidebarFinder),
          const Rect.fromLTWH(0, 0, 150, 600),
        );
        expect(find.byKey(probeKey).hitTestable(), findsOneWidget);
        expect(probeFocus.canRequestFocus, isTrue);
        expect(find.semantics.byLabel(probeLabel), findsOne);
      }

      testWidgets('a shown sidebar is on-screen and takes input', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        await pumpWindow(tester);

        expectShown(tester);

        semantics.dispose();
        await tester.pump(Duration.zero);
      });

      testWidgets('below windowBreakpoint', (tester) async {
        final semantics = tester.ensureSemantics();
        await pumpWindow(tester, width: 600);

        expectHidden(tester);

        semantics.dispose();
        await tester.pump(Duration.zero);
      });

      testWidgets('toggled off, and shown again when toggled back on', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        await pumpWindow(tester);

        MacosWindowScope.of(contentContext).toggleSidebar();
        await tester.pumpAndSettle();

        expectHidden(tester);

        MacosWindowScope.of(contentContext).toggleSidebar();
        await tester.pumpAndSettle();

        expectShown(tester);

        semantics.dispose();
        await tester.pump(Duration.zero);
      });

      testWidgets('takes no input while it slides away', (tester) async {
        final semantics = tester.ensureSemantics();
        await pumpWindow(tester);

        MacosWindowScope.of(contentContext).toggleSidebar();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        final rect = tester.getRect(find.byKey(probeKey));
        expect(rect.left, lessThan(0));
        expect(rect.left + rect.width * 0.95, greaterThan(0));
        expect(
          find.byKey(probeKey).hitTestable(at: const Alignment(0.9, 0)),
          findsNothing,
        );
        expect(find.semantics.byLabel(probeLabel), findsNothing);

        await tester.pumpAndSettle();
        semantics.dispose();
        await tester.pump(Duration.zero);
      });

      testWidgets('dragged closed', (tester) async {
        final semantics = tester.ensureSemantics();
        await pumpWindow(tester);

        await tester.drag(resizerFinder, const Offset(-500, 0));
        await tester.pumpAndSettle();

        expectHidden(tester);

        semantics.dispose();
        await tester.pump(Duration.zero);
      });
    });

    group('a hidden end sidebar is out of input', () {
      const endSidebarKey = Key('end sidebar');
      const probeKey = Key('end sidebar probe');
      const probeLabel = 'end sidebar probe';
      late FocusNode probeFocus;
      late BuildContext contentContext;

      setUp(() => probeFocus = FocusNode(debugLabel: probeLabel));
      tearDown(() => probeFocus.dispose());

      final endSidebarFinder = find.byKey(endSidebarKey);
      final resizerFinder = find.byType(AnimatedPositioned).last;

      pumpWindow(WidgetTester tester, {double width = 1000}) async {
        tester.view.physicalSize = Size(width, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MacosApp(
            home: MacosWindow(
              disableWallpaperTinting: true,
              endSidebar: Sidebar(
                key: endSidebarKey,
                minWidth: 100,
                startWidth: 150,
                maxWidth: 300,
                windowBreakpoint: 700,
                shownByDefault: true,
                builder: (context, scrollController) => Focus(
                  focusNode: probeFocus,
                  child: Semantics(
                    label: probeLabel,
                    child: const ColoredBox(
                      key: probeKey,
                      color: MacosColors.systemRedColor,
                      child: SizedBox.expand(),
                    ),
                  ),
                ),
              ),
              child: ContentArea(
                builder: (context, scrollController) {
                  contentContext = context;
                  return const SizedBox.expand();
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }

      expectHidden(WidgetTester tester, {double windowWidth = 1000}) {
        expect(
          tester.getRect(find.byKey(probeKey)).left,
          greaterThanOrEqualTo(windowWidth),
        );
        expect(find.byKey(probeKey).hitTestable(), findsNothing);
        expect(probeFocus.canRequestFocus, isFalse);
        expect(find.semantics.byLabel(probeLabel), findsNothing);
      }

      expectShown(WidgetTester tester) {
        expect(
          tester.getRect(endSidebarFinder),
          const Rect.fromLTWH(850, 0, 150, 600),
        );
        expect(find.byKey(probeKey).hitTestable(), findsOneWidget);
        expect(probeFocus.canRequestFocus, isTrue);
        expect(find.semantics.byLabel(probeLabel), findsOne);
      }

      testWidgets('a shown end sidebar is on-screen and takes input', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        await pumpWindow(tester);

        expectShown(tester);

        semantics.dispose();
        await tester.pump(Duration.zero);
      });

      testWidgets('below windowBreakpoint', (tester) async {
        final semantics = tester.ensureSemantics();
        await pumpWindow(tester, width: 600);

        expectHidden(tester, windowWidth: 600);

        semantics.dispose();
        await tester.pump(Duration.zero);
      });

      testWidgets('toggled off, and shown again when toggled back on', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        await pumpWindow(tester);

        MacosWindowScope.of(contentContext).toggleEndSidebar();
        await tester.pumpAndSettle();

        expectHidden(tester);

        MacosWindowScope.of(contentContext).toggleEndSidebar();
        await tester.pumpAndSettle();

        expectShown(tester);

        semantics.dispose();
        await tester.pump(Duration.zero);
      });

      testWidgets('takes no input while it slides away', (tester) async {
        final semantics = tester.ensureSemantics();
        await pumpWindow(tester);

        MacosWindowScope.of(contentContext).toggleEndSidebar();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        final rect = tester.getRect(find.byKey(probeKey));
        expect(rect.right, greaterThan(1000));
        expect(rect.left + rect.width * 0.05, lessThan(1000));
        expect(
          find.byKey(probeKey).hitTestable(at: const Alignment(-0.9, 0)),
          findsNothing,
        );
        expect(find.semantics.byLabel(probeLabel), findsNothing);

        await tester.pumpAndSettle();
        semantics.dispose();
        await tester.pump(Duration.zero);
      });

      testWidgets('dragged closed', (tester) async {
        final semantics = tester.ensureSemantics();
        await pumpWindow(tester);

        await tester.drag(resizerFinder, const Offset(500, 0));
        await tester.pumpAndSettle();

        expectHidden(tester);

        semantics.dispose();
        await tester.pump(Duration.zero);
      });
    });
  });
}
