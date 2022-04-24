import 'package:macos_ui/macos_ui.dart';

import '../library.dart';

const _kTabViewRadius = BorderRadius.all(Radius.circular(7.0));
const _kContentBackgroundColor = CupertinoDynamicColor.withBrightness(
  color: Color.fromRGBO(230, 230, 230, 1.0),
  darkColor: Color.fromRGBO(36, 38, 40, 1.0),
);

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
      Colors.black.withOpacity(0.23),
      Colors.black.withOpacity(0.76),
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
            color: _kContentBackgroundColor,
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
                  color: Colors.grey,
                  border: Border.all(color: MacosColors.systemGrayColor),
                ),
                child: Row(children: tabs),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
