import 'dart:async';

import 'package:macos_ui/src/layout/wallpaper_tinting_settings/wallpaper_tinting_settings_data.dart';

/// TODO: document this
class GlobalWallpaperTintingSettings {
  static WallpaperTintingSettingsData data = WallpaperTintingSettingsData();
  static final _onDataChangedStreamController =
      StreamController<WallpaperTintingSettingsData>.broadcast();

  static Stream<WallpaperTintingSettingsData> get onDataChangedStream =>
      _onDataChangedStreamController.stream;

  static bool get isWallpaperTintingEnabled => data.isWallpaperTintingEnabled;

  static void addWallpaperTintingOverride() {
    data.addOverride();
    _onDataChangedStreamController.add(data);
  }

  static void removeWallpaperTintingOverride() {
    data.removeOverride();
    _onDataChangedStreamController.add(data);
  }
}
