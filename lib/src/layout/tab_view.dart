import 'package:macos_ui/macos_ui.dart';

import '../library.dart';

const _kTabViewRadius = BorderRadius.all(Radius.elliptical(5, 5));

/// Specifies layout position for [MacosTab] options inside [MacosTabView]
enum MacosTabPosition { left, right, top, bottom }

class MacosTabView extends StatelessWidget {
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

  /// Specifies the tabs to display at any given edge of the tab view content
  final List<Widget> tabs;

  /// Specifies the position of where to place tab view controls
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
      Color.fromRGBO(218, 219, 219, 1.0),
      Color.fromRGBO(63, 64, 66, 1.0),
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
              Color.fromRGBO(230, 231, 235, 1.0),
              Color.fromRGBO(36, 37, 38, 1.0),
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
                    Color.fromRGBO(226, 227, 231, 1.0),
                    Color.fromRGBO(41, 42, 43, 1.0),
                  ),
                  border: Border.all(
                    color: brightness.resolve(
                      Color.fromRGBO(216, 216, 219, 1.0),
                      Color.fromRGBO(87, 89, 90, 1.0),
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
                              Color.fromRGBO(202, 203, 206, 1.0),
                              Color.fromRGBO(34, 36, 37, 1.0),
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
