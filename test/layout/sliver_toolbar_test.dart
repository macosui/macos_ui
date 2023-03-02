import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  Future<void> pumpScrollableWithSliverToolbar(
    WidgetTester tester,
    ScrollController controller, {
    bool pinned = true,
    bool floating = false,
    double opacity = 0.9,
  }) async {
    await tester.pumpWidget(
      MacosApp(
        home: MacosScaffold(
          children: [
            ContentArea(
              builder: (context, _) {
                return CustomScrollView(
                  controller: controller,
                  slivers: [
                    SliverToolBar(
                      title: const Text('Title'),
                      pinned: pinned,
                      floating: floating,
                      toolbarOpacity: 0.9,
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 1200),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  testWidgets(
    'MediaQuery bottom padding is removed as expected',
    (tester) async {
      final Key leadingKey = GlobalKey();
      final Key titleKey = GlobalKey();
      await tester.pumpWidget(
        MacosApp(
          home: MediaQuery(
            data: const MediaQueryData(
              padding: EdgeInsets.only(
                bottom: 30.0,
              ),
            ),
            child: MacosScaffold(
              children: [
                ContentArea(
                  builder: (context, scrollController) {
                    return CustomScrollView(
                      controller: scrollController,
                      slivers: <Widget>[
                        SliverToolBar(
                          leading: Placeholder(key: leadingKey),
                          title: Text('Title', key: titleKey),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 1200),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      // location of bottomLeft is unchanged by applying padding
      expect(
        tester.getBottomLeft(find.byKey(leadingKey)),
        const Offset(8.0, 47.0),
      );

      await tester.pump(Duration.zero);
    },
  );

  testWidgets(
    'Y-Offsets and sizes are correct',
    (tester) async {
      final ScrollController controller = ScrollController();
      await pumpScrollableWithSliverToolbar(tester, controller);

      final toolbar = find.byType(ToolBar);
      final navToolbar = find.byType(NavigationToolbar);

      expect(tester.getTopLeft(toolbar).dy, 0.0);
      expect(tester.getTopLeft(navToolbar).dy, 4.0);
      expect(tester.getSize(toolbar).height, 52.0);
      expect(tester.getSize(navToolbar).height, 43.0);

      await tester.pump(Duration.zero);
    },
  );

  testWidgets(
    'Scrolling down while pinned=true keeps the toolbar in view',
    (tester) async {
      final ScrollController controller = ScrollController();
      await pumpScrollableWithSliverToolbar(tester, controller);

      final toolbar = find.byType(ToolBar);
      final navToolbar = find.byType(NavigationToolbar);

      expect(controller.offset, 0.0);

      controller.jumpTo(600.0);
      await tester.pump();

      expect(tester.getTopLeft(toolbar).dy, 0.0);
      expect(tester.getTopLeft(navToolbar).dy, 4.0);

      await tester.pump(Duration.zero);
    },
  );

  testWidgets(
    'Scrolling down while pinned=false does not keep the toolbar in view',
    (tester) async {
      final ScrollController controller = ScrollController();
      await pumpScrollableWithSliverToolbar(tester, controller, pinned: false);

      final toolbar = find.byType(ToolBar);
      final navToolbar = find.byType(NavigationToolbar);

      expect(controller.offset, 0.0);
      expect(tester.getTopLeft(toolbar).dy, 0.0);
      expect(tester.getTopLeft(navToolbar).dy, 4.0);

      controller.jumpTo(600.0);
      await tester.pump();

      expect(toolbar, findsNothing);
      expect(navToolbar, findsNothing);

      await tester.pump(Duration.zero);
    },
  );

  testWidgets(
    'Scrolling down and back up while pinned=false and floating=true brings the toolbar back into view',
    (tester) async {
      final ScrollController controller = ScrollController();
      await pumpScrollableWithSliverToolbar(
        tester,
        controller,
        pinned: false,
        floating: true,
      );

      final toolbar = find.byType(ToolBar);
      final navToolbar = find.byType(NavigationToolbar);

      expect(controller.offset, 0.0);
      expect(tester.getTopLeft(toolbar).dy, 0.0);
      expect(tester.getTopLeft(navToolbar).dy, 4.0);

      controller.jumpTo(600.0);
      await tester.pump();

      expect(toolbar, findsNothing);
      expect(navToolbar, findsNothing);

      final Offset scrollEventLocation =
          tester.getCenter(find.byType(CustomScrollView));
      final TestPointer testPointer = TestPointer(1, PointerDeviceKind.mouse);
      testPointer.hover(scrollEventLocation);
      await tester
          .sendEventToBinding(testPointer.scroll(const Offset(0.0, -52.0)));
      await tester.pumpAndSettle();

      expect(controller.offset, 548.0);
      expect(toolbar, findsOneWidget);
      expect(tester.getTopLeft(toolbar).dy, 0.0);
      expect(navToolbar, findsOneWidget);
      expect(tester.getTopLeft(navToolbar).dy, 4.0);

      await tester.pump(Duration.zero);
    },
  );
}
