/// Holds data related to wallpaper tinting.
class WallpaperTintingSettingsData {
  /// The number of wallpaper tinting overrides that are currently active.
  ///
  /// A wallpaper tinting override causes wallpaper tinting to be disabled.
  int numberOfWallpaperTintingOverrides = 0;

  /// Gets whether wallpaper tinting should be enabled.
  bool get isWallpaperTintingEnabled => numberOfWallpaperTintingOverrides == 0;

  /// Increment the number of active overrides.
  void addOverride() => numberOfWallpaperTintingOverrides += 1;

  /// Decrements the number of active overrides.
  void removeOverride() {
    numberOfWallpaperTintingOverrides -= 1;
    assert(numberOfWallpaperTintingOverrides >= 0);
  }
}
