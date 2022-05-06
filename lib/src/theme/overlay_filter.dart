import 'dart:ui';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// {@template macosOverlayFilter}
/// Applies a blur filter to its child to create a macOS-style "frosted glass"
/// effect.
/// {@endtemplate}
class MacosOverlayFilter extends StatelessWidget {
  /// Applies a blur filter to its child to create a macOS-style "frosted glass"
  /// effect.
  ///
  /// Used mainly for the overlays that appear from various macOS-style widgets,
  /// like the pull-down and pop-up buttons, or the search field.
  const MacosOverlayFilter({
    Key? key,
    required this.child,
    required this.borderRadius,
    this.height,
    this.color,
  }) : super(key: key);

  final Widget child;

  final BorderRadius borderRadius;

  final double? height;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color ??
            (brightness.isDark
                ? const Color.fromRGBO(30, 30, 30, 1)
                : const Color.fromRGBO(242, 242, 247, 1)),
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
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 20.0,
            sigmaY: 20.0,
          ),
          child: child,
        ),
      ),
    );
  }
}
