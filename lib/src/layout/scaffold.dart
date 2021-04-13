import 'package:macos_ui/macos_ui.dart';
import 'package:split_view/split_view.dart'; //todo: fork and migrate to nnbd

/// A basic screen-layout widget.
///
/// Provides a [body] for main content and a [sidebar] for secondary content
/// (like navigation buttons). If no [sidebar] is specified, only the [body]
/// will be shown.
class Scaffold extends StatelessWidget {
  const Scaffold({
    Key? key,
    required this.body,
    this.sidebar,
    this.backgroundColor,
    this.sidebarBackgroundColor,
    this.sidebarGripColor,
    this.splitOffset = 0.25,
    this.sidebarGripSize = 0.80,
    this.resizeBoundary = 20.0,
    this.sidebarBreakpoint = 0.0,
  })  : assert(splitOffset > 0.0 && splitOffset < 1.0),
        super(key: key);

  /// Background color for the [body].
  final Color? backgroundColor;

  /// Main content area.
  final Widget body;

  /// Defines an area to which [sidebar] cannot be expanded or shrunk past on
  /// the left and right.
  final double resizeBoundary;

  /// Secondary content area.
  final Widget? sidebar;

  /// Background color for the [sidebar]
  final Color? sidebarBackgroundColor;

  /// Defines a breakpoint for showing and hiding the [sidebar].
  ///
  /// If the window is resized along its width to a value below this one, the
  /// sidebar will be hidden. If resized back above this value, the sidebar
  /// will be shown again.
  ///
  /// Defaults to `0.0`, which means the sidebar will always be shown.
  final double sidebarBreakpoint;

  /// The color of the body/sidebar splitter
  final Color? sidebarGripColor;

  /// The width of the split between [body] and [sidebar].
  ///
  /// Defaults to 0.80, which seems to be the default in Apple's macOS apps
  /// (I eyeballed this so it's not perfect but it's very close).
  final double sidebarGripSize;

  /// Determines where the split between [body] and [sidebar] occurs.
  ///
  /// If specified, it must be a value greater than 0.0 and less than 1.0.
  ///
  /// Defaults to `0.25`, which is 1/4 of the available space from the left.
  final double splitOffset;

  @override
  Widget build(BuildContext context) {
    debugCheckHasMacosTheme(context);

    final style = context.style;
    late Color bodyColor;
    late Color sidebarColor;
    late Color gripColor;

    if (style.brightness == Brightness.light) {
      bodyColor = backgroundColor ?? CupertinoColors.systemBackground.color;
      sidebarColor =
          sidebarBackgroundColor ?? CupertinoColors.tertiarySystemBackground;
      gripColor = sidebarGripColor ?? CupertinoColors.systemFill;
    } else {
      bodyColor =
          backgroundColor ?? CupertinoColors.systemBackground.darkElevatedColor;
      sidebarColor = sidebarBackgroundColor ??
          CupertinoColors.tertiarySystemBackground.darkColor;
      gripColor = sidebarGripColor ?? CupertinoColors.black;
    }

    return AnimatedContainer(
      duration: style.mediumAnimationDuration ?? Duration.zero,
      curve: style.animationCurve ?? Curves.linear,
      color: bodyColor,
      child: sidebar != null
          ? LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > sidebarBreakpoint) {
                  return SplitView(
                    positionLimit: resizeBoundary,
                    initialWeight: splitOffset,
                    gripSize: sidebarGripSize,
                    gripColor: gripColor,
                    view1: AnimatedContainer(
                      duration: style.mediumAnimationDuration ?? Duration.zero,
                      curve: style.animationCurve ?? Curves.linear,
                      color: sidebarColor,
                      child: sidebar,
                    ),
                    view2: body,
                    viewMode: SplitViewMode.Horizontal,
                  );
                } else {
                  return body;
                }
              },
            )
          : body,
    );
  }
}
