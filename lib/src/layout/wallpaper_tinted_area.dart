import 'package:flutter/cupertino.dart';
import 'package:macos_ui/src/layout/wallpaper_tinting_settings/global_wallpaper_tinting_settings.dart';
import 'package:macos_ui/src/layout/wallpaper_tinting_settings/wallpaper_tinting_settings_builder.dart';
import 'package:macos_window_utils/macos/ns_visual_effect_view_material.dart';
import 'package:macos_window_utils/widgets/visual_effect_subview_container/visual_effect_subview_container.dart';

/// A widget that applies a wallpaper tint to its child widget.
///
/// This widget only works on macOS.
///
/// The [backgroundColor] is the color to apply to the background when wallpaper
/// tinting is disabled. If [insertRepaintBoundary] is true, a [RepaintBoundary]
/// is inserted above this widget in the widget tree. In some instances, it may
/// be necessary to insert a [RepaintBoundary] to ensure proper rendering.
/// The [child] is the widget below this widget in the tree.
///
/// Example:
///
/// ```dart
/// WallpaperTintedArea(
///   backgroundColor: MacosColors.white,
///   child: Text('Hello World'),
/// )
/// ```
class WallpaperTintedArea extends StatelessWidget {
  /// Creates a [WallpaperTintedArea].
  ///
  /// Widgets wrapped in this widget will have a wallpaper tint applied to them.
  ///
  /// **Note:** This widget only works on macOS.
  const WallpaperTintedArea({
    super.key,
    required this.backgroundColor,
    this.insertRepaintBoundary = false,
    this.child,
  });

  /// The color to apply to the background when wallpaper tinting is disabled.
  final Color backgroundColor;

  /// Whether to insert a [RepaintBoundary] above this widget in the widget
  /// tree.
  ///
  /// In some instances, it may be necessary to insert a [RepaintBoundary] above
  /// this widget into the widget tree to ensure that this widget is rendered
  /// properly.
  final bool insertRepaintBoundary;

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (insertRepaintBoundary) {
      return RepaintBoundary(
        child: _WallpaperTintedAreaLayoutBuilder(
          backgroundColor: backgroundColor,
          child: child,
        ),
      );
    }

    return _WallpaperTintedAreaLayoutBuilder(
      backgroundColor: backgroundColor,
      child: child,
    );
  }
}

class _WallpaperTintedAreaLayoutBuilder extends StatelessWidget {
  const _WallpaperTintedAreaLayoutBuilder({
    required this.backgroundColor,
    required this.child,
  });

  /// The color to apply to the background when wallpaper tinting is disabled.
  final Color backgroundColor;

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (GlobalWallpaperTintingSettings
        .data.isWallpaperTintingDisabledByWindow) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: child,
      );
    }

    // This LayoutBuilder forces the widget to be rebuilt when a layout change
    // is detected. This is necessary for the VisualEffectSubviewContainer to
    // be updated.
    return LayoutBuilder(
      builder: (context, _) {
        return VisualEffectSubviewContainer(
          material: NSVisualEffectViewMaterial.windowBackground,
          child: WallpaperTintingSettingsBuilder(
            builder: (context, data) {
              final isWallpaperTintingEnabled = data.isWallpaperTintingEnabled;

              return _WallpaperTintedAreaTweenAnimationBuilder(
                isWallpaperTintingEnabled: isWallpaperTintingEnabled,
                backgroundColor: backgroundColor,
                child: child,
              );
            },
          ),
        );
      },
    );
  }
}

class _WallpaperTintedAreaTweenAnimationBuilder extends StatelessWidget {
  const _WallpaperTintedAreaTweenAnimationBuilder({
    required this.isWallpaperTintingEnabled,
    required this.backgroundColor,
    required this.child,
  });

  /// Whether wallpaper tinting is enabled.
  final bool isWallpaperTintingEnabled;

  /// The color to apply to the background when wallpaper tinting is disabled.
  final Color backgroundColor;

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 100),
      tween: Tween<double>(
        begin: isWallpaperTintingEnabled ? 0.0 : 1.0,
        end: isWallpaperTintingEnabled ? 0.0 : 1.0,
      ),
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor.withValues(alpha: value),
            backgroundBlendMode: BlendMode.src,
          ),
          child: child,
        );
      },
      child: RepaintBoundary(
        child: child,
      ),
    );
  }
}
