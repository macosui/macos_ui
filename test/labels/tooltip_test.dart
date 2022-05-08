import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

// https://github.com/flutter/flutter/blob/master/packages/flutter/test/material/tooltip_test.dart

void _ensureTooltipVisible(GlobalKey key) {
  // This function uses "as dynamic"to defeat the static analysis. In general
  // you want to avoid using this style in your code, as it will cause the
  // analyzer to be unable to help you catch errors.
  //
  // In this case, we do it because we are trying to call internal methods of
  // the tooltip code in order to test it. Normally, the state of a tooltip is a
  // private class, but by using a GlobalKey we can get a handle to that object
  // and by using "as dynamic" we can bypass the analyzer's type checks and call
  // methods that we aren't supposed to be able to know about.
  //
  // It's ok to do this in tests, but you really don't want to do it in
  // production code.
  // ignore: avoid_dynamic_calls
  (key.currentState as dynamic).ensureTooltipVisible();
}

const String tooltipText = 'A message for the tooltip';

Finder _findTooltipContainer(String tooltipText) {
  return find.ancestor(
    of: find.text(tooltipText),
    matching: find.byType(Container),
  );
}

void main() {
  testWidgets(
    'Does tooltip end up in the right place - left aligned, below the widget',
    (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MacosTheme(
          data: MacosThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) {
                    return Stack(
                      children: [
                        Positioned(
                          left: 300.0,
                          top: 0.0,
                          child: MacosTooltip(
                            key: key,
                            message: tooltipText,
                            child: const SizedBox(
                              width: 0,
                              height: 0,
                            ),
                          ),
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

      _ensureTooltipVisible(key);
      await tester.pump(const Duration(
        seconds: 2,
      )); // faded in, show timer started (and at 0.0)

      final RenderBox tip = tester.renderObject(
        _findTooltipContainer(tooltipText),
      );
      final tipInGlobal = tip.localToGlobal(tip.size.topLeft(Offset.zero));
      expect(tipInGlobal.dx, 300.0);
      expect(tipInGlobal.dy, 18.0);
    },
  );
}
