import 'package:flutter/widgets.dart';
import 'package:macos_ui/src/layout/wallpaper_tinting_settings/global_wallpaper_tinting_settings.dart';

import 'wallpaper_tinting_settings_data.dart';

/// A widget that listens for changes to [WallpaperTintingSettingsData] and
/// rebuilds with the latest data when a change is detected.
///
/// The [builder] callback is called whenever [WallpaperTintingSettingsData]
/// changes. It should build a widget using the latest
/// [WallpaperTintingSettingsData].
///
/// Example:
///
/// ```dart
/// WallpaperTintingSettingsBuilder(
///   builder: (context, data) {
///     return Text(
///       'isWallpaperTintingEnabled: ${data.isWallpaperTintingEnabled}',
///     );
///   },
/// )
/// ```
class WallpaperTintingSettingsBuilder extends StatelessWidget {
  /// Creates a [WallpaperTintingSettingsBuilder].
  ///
  /// This widget can be used to listen to [WallpaperTintingSettingsData]
  /// changes and rebuild if a change has been detected.
  const WallpaperTintingSettingsBuilder({super.key, required this.builder});

  /// Called when [WallpaperTintingSettingsData] changes.
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
