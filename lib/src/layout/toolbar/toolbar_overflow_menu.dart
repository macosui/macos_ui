import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const BorderRadius _kBorderRadius = BorderRadius.all(Radius.circular(5.0));

/// A menu that includes all overflowed toolbar actions.
class ToolbarOverflowMenu extends StatelessWidget {
  /// Builds a menu that includes all overflowed toolbar actions and appears
  /// as a popup below the [ToolbarOverflowButton].
  ///
  /// Has a similar styling to a pulldown menu.
  const ToolbarOverflowMenu({
    super.key,
    required this.children,
  });

  /// The list of children widgets to lay out vertically inside the menu.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      child: IntrinsicWidth(
        child: MacosOverlayFilter(
          color: MacosPulldownButtonTheme.of(context)
              .pulldownColor
              ?.withValues(alpha: 0.25),
          borderRadius: _kBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
