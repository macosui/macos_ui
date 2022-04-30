import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const _kTabBorderRadius = BorderRadius.all(
  Radius.circular(5.0),
);

/// {@template macosTab}
/// An item in a [MacosTabView].
/// {@endtemplate}
class MacosTab extends StatelessWidget {
  /// {@macro macosTab}
  const MacosTab({
    Key? key,
    required this.label,
    required this.onClick,
    this.active = false,
  }) : super(key: key);

  /// Describes the content of the [MacosTabView] pane it represents.
  final String label;

  /// The action to perform when the user selects the tab.
  final VoidCallback onClick;

  /// Whether this tab is currently selected.
  final bool active;

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);

    return GestureDetector(
      onTap: onClick,
      child: PhysicalModel(
        color: active ? const Color(0xFF625E66) : MacosColors.transparent,
        borderRadius: _kTabBorderRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: _kTabBorderRadius,
            color: active
                ? brightness.resolve(
                    MacosColors.white,
                    const Color(0xFF625E66),
                  )
                : MacosColors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
