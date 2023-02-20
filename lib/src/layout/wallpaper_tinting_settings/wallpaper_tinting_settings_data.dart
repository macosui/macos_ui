/// Holds data related to wallpaper tinting.
class WallpaperTintingSettingsData {
  /// The number of wallpaper tinting overrides that are currently active.
  ///
  /// A wallpaper tinting override causes wallpaper tinting to be disabled.
  int _numberOfWallpaperTintingOverrides = 0;

  /// Gets whether wallpaper tinting should be enabled.
  bool get isWallpaperTintingEnabled => _numberOfWallpaperTintingOverrides == 0;

  /// Increments the number of active overrides.
  void addOverride() => _numberOfWallpaperTintingOverrides += 1;

  /// Decrements the number of active overrides.
  void removeOverride() {
    _numberOfWallpaperTintingOverrides -= 1;
    assert(_numberOfWallpaperTintingOverrides >= 0);
  }
}
