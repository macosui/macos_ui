import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/src/layout/wallpaper_tinting_settings/wallpaper_tinting_settings_cubit.dart';
import 'package:macos_ui/src/layout/wallpaper_tinting_settings/wallpaper_tinting_settings_data.dart';
import 'package:macos_window_utils/macos/ns_visual_effect_view_material.dart';
import 'package:macos_window_utils/widgets/visual_effect_subview_container/visual_effect_subview_container.dart';

/// TODO: document this
class WallpaperTintedArea extends StatelessWidget {
  const WallpaperTintedArea({
    super.key,
    required this.backgroundColor,
    this.child,
  });

  final Color backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return VisualEffectSubviewContainer(
      material: NSVisualEffectViewMaterial.windowBackground,
      child: BlocBuilder<WallpaperTintingSettingsCubit,
          WallpaperTintingSettingsData>(
        builder: (context, data) {
          return TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 100),
            tween: Tween<double>(
              begin: data.isWallpaperTintingEnabled ? 0.0 : 1.0,
              end: data.isWallpaperTintingEnabled ? 0.0 : 1.0,
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
  }
}
