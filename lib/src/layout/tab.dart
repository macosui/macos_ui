import '../../macos_ui.dart';
import '../library.dart';

/// {template macosTab}
/// An item in a [MacosTabView].
/// {endtemplate}
class MacosTab extends StatelessWidget {
  /// {macro macosTab}
  const MacosTab({
    Key? key,
    required this.label,
    required this.onTap,
    this.active = false,
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.elliptical(6, 6)),
          color: active
              ? brightness.resolve(
                  Colors.white,
                  const Color.fromRGBO(95, 96, 97, 1.0),
                )
              : Colors.transparent,
        ),
        child: Text(label),
      ),
    );
  }
}
