import 'package:macos_ui/macos_ui.dart';

import '../library.dart';

const _kTabViewRadius = BorderRadius.all(Radius.elliptical(5, 5));

/// Specifies layout position for [MacosTab] options inside [MacosTabView]
enum MacosTabPosition { 
  left, 
  right, 
  top, 
  bottom, 
}

/// {template macosTabView}
/// Presents multiple mutually exclusive panes of content in the same area. 
///
/// Includes a tabbed control (which is similar in appearance to a 
/// [segmented control](https://developer.apple.com/design/human-interface-guidelines/macos/selectors/segmented-controls/)) 
/// and a content area.
///
/// Each segment of a tabbed control is known as a tab, and clicking a tab displays its corresponding pane 
/// in the content area. Although the amount of content can vary from pane to pane, switching tabs doesn’t 
/// change the overall size of the tab view or its parent window. 
/// 
/// You can position the tabbed control on any side of the content area—top, bottom, left, or right.
///
/// **Use a tab view to present closely related peer areas of content.** The typical appearance of a tab view 
/// provides a strong visual indication of enclosure. People expect each tab to display content that is in 
/// some way similar or related to the content in the other tabs.
///
/// **Make sure the controls within a pane only affect content in the same pane.** Panes are mutually 
/// exclusive and should be fully self-contained.
///
/// In general, inset a tab view by leaving a margin of window-body area on all sides of a tab view. 
/// This layout looks clean and leaves room for additional controls that can affect the window itself 
/// (or other tabs). For example, the lock button in the macOD Date & Time preferences is outside of 
/// the tab view because it applies to all tabs.
///
/// **Provide a label for each tab that describes the contents of its pane.** A good label helps the 
/// user predict the contents of a pane before clicking its tab. In general, use nouns or very short 
/// noun phrases for tab labels. A verb or short verb phrase may make sense in some contexts. 
/// Tab labels should use title-style capitalization.
/// {endTemplate}
class MacosTabView extends StatelessWidget {
  /// {macro macosTabView}
  const MacosTabView({
    Key? key,
    required this.tabs,
    required this.body,
    this.position = MacosTabPosition.top,
    this.width,
    this.height,
    this.constraints,
  })  : assert(tabs.length > 0),
        super(key: key);

  /// Specifies the tabs to display at any given edge of the tab view content.
  final List<Widget> tabs;

  /// Specifies the position of the tab view controls.
  ///
  /// Defaults to [MacosTabPosition.top]
  final MacosTabPosition position;

  /// Content displayed inside of the tab view
  final Widget body;

  final double? width;
  final double? height;
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
      const Color.fromRGBO(218, 219, 219, 1.0),
      const Color.fromRGBO(63, 64, 66, 1.0),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          constraints: constraints,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: brightness.resolve(
              const Color.fromRGBO(230, 231, 235, 1.0),
              const Color.fromRGBO(36, 37, 38, 1.0),
            ),
            border: Border.all(color: outerBorderColor, width: 1),
            borderRadius: _kTabViewRadius,
          ),
          child: body,
        ),
        Positioned(
          top: position == MacosTabPosition.top ? 0 : null,
          bottom: position == MacosTabPosition.bottom ? 0 : null,
          left: position == MacosTabPosition.left ? 0 : null,
          right: position == MacosTabPosition.right ? 0 : null,
          child: RotatedBox(
            quarterTurns: _tabRotation,
            child: ClipRRect(
              borderRadius: _kTabViewRadius,
              child: Container(
                decoration: BoxDecoration(
                  color: brightness.resolve(
                    const Color.fromRGBO(226, 227, 231, 1.0),
                    const Color.fromRGBO(41, 42, 43, 1.0),
                  ),
                  border: Border.all(
                    color: brightness.resolve(
                      const Color.fromRGBO(216, 216, 219, 1.0),
                      const Color.fromRGBO(87, 89, 90, 1.0),
                    ),
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: tabs.map((t) {
                      Row row = Row(children: [t]);
                      bool last = tabs.indexOf(t) == tabs.length - 1;
                      if (!last) {
                        row.children.add(
                          VerticalDivider(
                            color: brightness.resolve(
                              const Color.fromRGBO(202, 203, 206, 1.0),
                              const Color.fromRGBO(34, 36, 37, 1.0),
                            ),
                            width: 0,
                            indent: 5,
                            endIndent: 5,
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
