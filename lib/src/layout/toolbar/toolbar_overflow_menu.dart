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
              // BP CHANGE THIS
              // REPLACE
              // ?.withValues(alpha: 0.25),            
              // WITH
              ?.withValues(alpha: 0.85),
              // REASON: lightening default dark color at MacosThemeData.pulldownColor init 
              // makes lightening here via super-low alpha unnecessary, thereby eliminating
              // the non-macOS-15.x severe transparency effect.
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
