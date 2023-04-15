import 'package:flutter/widgets.dart';
import 'package:macos_ui/src/layout/wallpaper_tinting_settings/global_wallpaper_tinting_settings.dart';

class WallpaperTintingOverride extends StatefulWidget {
  /// Creates a [WallpaperTintingOverride].
  ///
  /// Including this widget in the widget tree will disable wallpaper tinting
  /// globally. It is intended to be used by [MacosOverlayFilter] to disable
  /// wallpaper tinting when an overlay filter is active, since
  /// [`ImageFilter.blur`](https://api.flutter.dev/flutter/dart-ui/ImageFilter/ImageFilter.blur.html)
  /// does not support transparency.
  const WallpaperTintingOverride({super.key, this.child});

  /// The widget below this widget in the tree.
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
  void dispose() {
    GlobalWallpaperTintingSettings.removeWallpaperTintingOverride();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}
