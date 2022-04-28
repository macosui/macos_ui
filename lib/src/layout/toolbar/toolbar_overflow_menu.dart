import 'dart:ui';

import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/macos_theme.dart';

const BorderRadius _kBorderRadius = BorderRadius.all(Radius.circular(5.0));

/// A menu that includes all overflowed toolbar actions.
class ToolbarOverflowMenu extends StatelessWidget {
  /// Builds a menu that includes all overflowed toolbar actions and appears
  /// as a popup below the [ToolbarOverflowButton].
  ///
  /// Has a similar styling to a pulldown menu.
  const ToolbarOverflowMenu({
    Key? key,
    required this.children,
  }) : super(key: key);

  /// The list of children widgets to lay out vertically inside the menu.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);
    return Container(
      decoration: BoxDecoration(
        color: MacosTheme.of(context)
            .pulldownButtonTheme
            .pulldownColor
            ?.withOpacity(0.25),
        boxShadow: [
          BoxShadow(
            color: brightness
                .resolve(
                  CupertinoColors.systemGrey.color,
                  CupertinoColors.black,
                )
                .withOpacity(0.25),
            offset: const Offset(0, 4),
            spreadRadius: 4.0,
            blurRadius: 8.0,
          ),
        ],
        border: Border.all(
          color: brightness.resolve(
            CupertinoColors.systemGrey3.color,
            CupertinoColors.systemGrey3.darkColor,
          ),
        ),
        borderRadius: _kBorderRadius,
      ),
      child: Semantics(
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        child: IntrinsicWidth(
          // "Frosted glass" effect for the menu's background.
          child: ClipRRect(
            borderRadius: _kBorderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20.0,
                sigmaY: 20.0,
              ),
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
        ),
      ),
    );
  }
}
