import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/macos_colors.dart';
import 'package:macos_ui/src/theme/macos_theme.dart';

const _kTabBorderRadius = BorderRadius.all(
  Radius.circular(4.0),
);

/// {@template macosTab}
/// A macOS-style navigational button used to move between the views of a
/// [MacosTabView].
/// {@endtemplate}
class MacosTab extends StatelessWidget {
  /// {@macro macosTab}
  const MacosTab({
    super.key,
    required this.label,
    this.active = false,
  });

  /// The display label for this tab.
  final String label;

  /// Whether this [MacosTab] is currently selected. Handled internally by
  /// [MacosSegmentedControl]'s build function.
  final bool active;

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);
    return PhysicalModel(
      color: active ? const Color(0xFF2B2E33) : MacosColors.transparent,
      borderRadius: _kTabBorderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: _kTabBorderRadius,
          color: active
              ? brightness.resolve(
                  MacosColors.white,
                  const Color(0xFF646669),
                )
              : MacosColors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Text(label),
        ),
      ),
    );
  }

  /// Copies this [MacosTab] into another.
  MacosTab copyWith({
    String? label,
    bool? active,
  }) {
    return MacosTab(
      label: label ?? this.label,
      active: active ?? this.active,
    );
  }
}
