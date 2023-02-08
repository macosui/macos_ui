/// TODO: document this
class WallpaperTintingSettingsData {
  factory WallpaperTintingSettingsData({
    required bool isWallpaperTintingInitiallyEnabled,
  }) {
    final initialNumberOfOverrides = isWallpaperTintingInitiallyEnabled ? 0 : 1;

    return WallpaperTintingSettingsData.withData(
      numberOfWallpaperTintingOverrides: initialNumberOfOverrides,
    );
  }

  const WallpaperTintingSettingsData.withData({
    required this.numberOfWallpaperTintingOverrides,
  }) : assert(numberOfWallpaperTintingOverrides >= 0);

  final int numberOfWallpaperTintingOverrides;

  bool get isWallpaperTintingEnabled => numberOfWallpaperTintingOverrides == 0;

  WallpaperTintingSettingsData addOverride() =>
      WallpaperTintingSettingsData.withData(
        numberOfWallpaperTintingOverrides:
            numberOfWallpaperTintingOverrides + 1,
      );

  WallpaperTintingSettingsData removeOverride() =>
      WallpaperTintingSettingsData.withData(
        numberOfWallpaperTintingOverrides:
            numberOfWallpaperTintingOverrides - 1,
      );
}
