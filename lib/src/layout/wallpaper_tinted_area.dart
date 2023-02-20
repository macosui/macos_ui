import 'package:flutter/cupertino.dart';
import 'package:macos_ui/src/layout/wallpaper_tinting_settings/wallpaper_tinting_settings_builder.dart';
import 'package:macos_window_utils/macos/ns_visual_effect_view_material.dart';
import 'package:macos_window_utils/widgets/visual_effect_subview_container/visual_effect_subview_container.dart';

class WallpaperTintedArea extends StatelessWidget {
  /// Creates a [WallpaperTintedArea].
  ///
  /// Widgets wrapped in this widget will have a wallpaper tint applied to them.
  ///
  /// **Note:** This widget only works on macOS.
  const WallpaperTintedArea({
    super.key,
    required this.backgroundColor,
    this.child,
  });

  /// The color to apply to the background when wallpaper tinting is disabled.
  final Color backgroundColor;

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, _) {
        return VisualEffectSubviewContainer(
          material: NSVisualEffectViewMaterial.windowBackground,
          child: WallpaperTintingSettingsBuilder(
            builder: (context, data) {
              final isWallpaperTintingEnabled = data.isWallpaperTintingEnabled;

              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 100),
                tween: Tween<double>(
                  begin: isWallpaperTintingEnabled ? 0.0 : 1.0,
                  end: isWallpaperTintingEnabled ? 0.0 : 1.0,
                ),
                builder: (context, value, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: backgroundColor.withOpacity(value),
                      backgroundBlendMode: BlendMode.src,
                    ),
                    child: child,
                  );
                },
                child: Opacity(
                  // For some reason, omitting this Opacity widget causes
                  // a dark background to appear.
                  opacity: 1.0,
                  child: child,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
