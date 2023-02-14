import 'package:flutter/widgets.dart';
import 'package:macos_ui/src/layout/wallpaper_tinting_settings/global_wallpaper_tinting_settings.dart';

/// TODO: document this
class WallpaperTintingOverride extends StatefulWidget {
  const WallpaperTintingOverride({super.key, this.child});

  final Widget? child;

  @override
  State<WallpaperTintingOverride> createState() =>
      _WallpaperTintingOverrideState();
}

class _WallpaperTintingOverrideState extends State<WallpaperTintingOverride> {
  @override
  void initState() {
    super.initState();

    GlobalWallpaperTintingSettings.addWallpaperTintingOverride();
  }

  @override
  void deactivate() {
    GlobalWallpaperTintingSettings.removeWallpaperTintingOverride();

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}
