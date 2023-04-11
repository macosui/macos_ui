import 'dart:async';

import 'package:macos_ui/src/layout/wallpaper_tinting_settings/wallpaper_tinting_settings_data.dart';

/// A class that provides a global instance of [WallpaperTintingSettingsData].
class GlobalWallpaperTintingSettings {
  /// The [WallpaperTintingSettingsData] instance.
  static final WallpaperTintingSettingsData data =
      WallpaperTintingSettingsData();

  /// The [StreamController] for an event stream that is triggered when [data]
  /// changes.
  static final _onDataChangedStreamController =
      StreamController<WallpaperTintingSettingsData>.broadcast();

  /// A stream that can be used to listen to [data] changes.
  static Stream<WallpaperTintingSettingsData> get onDataChangedStream =>
      _onDataChangedStreamController.stream;

  /// Gets whether wallpaper tinting should be enabled.
  static bool get isWallpaperTintingEnabled => data.isWallpaperTintingEnabled;

  /// Increments the number of active overrides.
  static void addWallpaperTintingOverride() {
    data.addOverride();
    _onDataChangedStreamController.add(data);
  }

  /// Decrements the number of active overrides.
  static void removeWallpaperTintingOverride() {
    data.removeOverride();
    _onDataChangedStreamController.add(data);
  }

  /// Disables wallpaper tinting altogether.
  static void disableWallpaperTinting() {
    data.disableWallpaperTinting();
    _onDataChangedStreamController.add(data);
  }

  /// Allows wallpaper tinting, unless overridden.
  static void allowWallpaperTinting() {
    data.allowWallpaperTinting();
    _onDataChangedStreamController.add(data);
  }
}
