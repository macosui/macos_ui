import 'dart:ui';

import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/layout/wallpaper_tinting_settings/wallpaper_tinting_override.dart';
import 'package:macos_ui/src/library.dart';

/// {@template macosOverlayFilter}
/// Applies a blur filter to its child to create a macOS-style "frosted glass"
/// effect.
/// {@endtemplate}
class MacosOverlayFilter extends StatelessWidget {
  /// {@macro macosOverlayFilter}
  ///
  /// Used mainly for the overlays that appear from various macOS-style widgets,
  /// like the pull-down and pop-up buttons, or the search field.
  const MacosOverlayFilter({
    super.key,
    required this.child,
    required this.borderRadius,
    this.color,
  });

  /// The widget to apply the blur filter to.
  final Widget child;

  /// The border radius to use when applying the effect to the
  /// child widget.
  final BorderRadius borderRadius;

  /// The color to use as the filter's background.
  ///
  /// If it is null, the macOS default surface background
  /// colors will be used.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);

    return WallpaperTintingOverride(
      child: Container(
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
                  .withValues(alpha: 0.25),
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
      ),
    );
  }
}
