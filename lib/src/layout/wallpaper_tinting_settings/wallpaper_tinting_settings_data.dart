/// TODO: document this
class WallpaperTintingSettingsData {
  int numberOfWallpaperTintingOverrides = 0;

  bool get isWallpaperTintingEnabled => numberOfWallpaperTintingOverrides == 0;

  void addOverride() => numberOfWallpaperTintingOverrides += 1;

  void removeOverride() {
    numberOfWallpaperTintingOverrides -= 1;
    assert(numberOfWallpaperTintingOverrides >= 0);
  }
}
