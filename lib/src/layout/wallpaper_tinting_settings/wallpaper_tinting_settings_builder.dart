import 'package:flutter/widgets.dart';
import 'package:macos_ui/src/layout/wallpaper_tinting_settings/global_wallpaper_tinting_settings.dart';

import 'wallpaper_tinting_settings_data.dart';

/// TODO: document this
class WallpaperTintingSettingsBuilder extends StatelessWidget {
  const WallpaperTintingSettingsBuilder({super.key, required this.builder});

  final Widget Function(BuildContext, WallpaperTintingSettingsData) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WallpaperTintingSettingsData>(
      stream: GlobalWallpaperTintingSettings.onDataChangedStream,
      initialData: GlobalWallpaperTintingSettings.data,
      builder: (context, snapshot) {
        final data = snapshot.data ?? GlobalWallpaperTintingSettings.data;

        return builder(context, data);
      },
    );
  }
}
