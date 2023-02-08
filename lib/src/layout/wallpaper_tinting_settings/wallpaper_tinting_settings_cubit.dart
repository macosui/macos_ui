import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/src/layout/wallpaper_tinting_settings/wallpaper_tinting_settings_data.dart';

class WallpaperTintingSettingsCubit
    extends Cubit<WallpaperTintingSettingsData> {
  WallpaperTintingSettingsCubit(super.initialState);

  void addWallpaperTintingOverride() => emit(state.addOverride());

  void removeWallpaperTintingOverride() => emit(state.removeOverride());
}
