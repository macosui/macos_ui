import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const _kTabViewRadius = BorderRadius.all(
  Radius.circular(5.0),
);

/// Specifies layout position for [MacosTab] options inside [MacosTabView].
enum MacosTabPosition {
  left,
  right,
  top,
  bottom,
}

/// {@template macosTabView}
/// Presents multiple mutually exclusive panes of content in the same area.
///
/// Includes a tabbed control (which is similar in appearance to a
/// [segmented control](https://developer.apple.com/design/human-interface-guidelines/macos/selectors/segmented-controls/))
/// and a content area.
///
/// Each segment of a tabbed control is known as a tab, and clicking a tab
/// displays its corresponding pane in the content area. Although the amount
/// of content can vary from pane to pane, switching tabs doesn't change the
/// overall size of the tab view or its parent window.
///
/// You can position the tabbed control on any side of the content area —
/// top, bottom, left, or right.
///
/// **Use a tab view to present closely related peer areas of content.**
/// The typical appearance of a tab view provides a strong visual indication
/// of enclosure. People expect each tab to display content that is in some
/// way similar or related to the content in the other tabs.
///
/// **Make sure the controls within a pane only affect content in the same pane.**
/// Panes are mutually exclusive and should be fully self-contained.
///
/// In general, inset a tab view by leaving a margin of window-body area on
/// all sides of a tab view. This layout looks clean and leaves room for
/// additional controls that can affect the window itself (or other tabs).
/// For example, the lock button in the macOD Date & Time preferences is
/// outside of the tab view because it applies to all tabs.
///
/// **Provide a label for each tab that describes the contents of its pane.**
/// A good label helps the user predict the contents of a pane before clicking
/// its tab. In general, use nouns or very short noun phrases for tab labels.
/// A verb or short verb phrase may make sense in some contexts. Tab labels
/// should use title-style capitalization.
/// {@endTemplate}
class MacosTabView extends StatelessWidget {
  /// {@macro macosTabView}
  const MacosTabView({
    Key? key,
    required this.tabs,
    required this.body,
    required this.currentIndex,
    this.position = MacosTabPosition.top,
    this.width,
    this.height,
    this.constraints,
  })  : assert(tabs.length > 0 && tabs.length <= 6),
        super(key: key);

  /// Specifies the tabs to display at any given edge of the tab view content.
  final List<MacosTab> tabs;

  /// Specifies the position of where to place tab view controls.
  ///
  /// Defaults to [MacosTabPosition.top].
  final MacosTabPosition position;

  final int currentIndex;

  /// The content of the tab view.
  final Widget body;

  /// Specifies the width of the tab view.
  final double? width;

  /// Specifies the height of the tab view.
  final double? height;

  /// Specifies the constraints of the tab view.
  final BoxConstraints? constraints;

  int get _tabRotation {
    switch (position) {
      case MacosTabPosition.left:
        return 3;
      case MacosTabPosition.right:
        return 1;
      case MacosTabPosition.top:
        return 0;
      case MacosTabPosition.bottom:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final brightness = MacosTheme.brightnessOf(context);

    final outerBorderColor = brightness.resolve(
      const Color(0xFFDED9E3),
      const Color(0xFF3F3E45),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        // Content area
        Container(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          constraints: constraints,
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: brightness.resolve(
              const Color(0xFFE9E4EB),
              const Color(0xFF29242F),
            ),
            border: Border.all(
              color: outerBorderColor,
              width: 1.0,
            ),
            borderRadius: _kTabViewRadius,
          ),
          child: body,
        ),
        // TabBar
        Positioned(
          top: position == MacosTabPosition.top ? 0 : null,
          bottom: position == MacosTabPosition.bottom ? 0 : null,
          left: position == MacosTabPosition.left ? 0 : null,
          right: position == MacosTabPosition.right ? 0 : null,
          child: RotatedBox(
            quarterTurns: _tabRotation,
            child: DecoratedBox(
              decoration: BoxDecoration(
                // Background color
                color: brightness.resolve(
                  const Color(0xFFE3DEE8),
                  const Color(0xFF2D2934),
                ),
                borderRadius: _kTabViewRadius,
                // Outer border
                border: Border.all(
                  color: brightness.resolve(
                    const Color(0xFFD8D3DC),
                    const Color(0xFF37333D),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: IntrinsicHeight(
                  child: Row(
                    children: tabs.map((t) {
                      Row row = Row(children: [t]);
                      bool showDividerColor = true;
                      bool last = tabs.indexOf(t) == tabs.length - 1;
                      if ((currentIndex - 1 == tabs.indexOf(t)) ||
                          (currentIndex + 1 == tabs.indexOf(t) + 1) ||
                          last) {
                        showDividerColor = false;
                      }

                      if (!last) {
                        row.children.add(
                          VerticalDivider(
                            color: showDividerColor
                                ? brightness.resolve(
                                    const Color(0xFFC9C9C9),
                                    const Color(0xFF26222C),
                                  )
                                : MacosColors.transparent,
                            width: 2.0,
                            indent: 5.0,
                            endIndent: 5.0,
                          ),
                        );
                      }

                      return row;
                    }).toList(growable: false),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
