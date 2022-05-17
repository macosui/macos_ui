# 1.2.0
* 🖥 Added multi-window support via the `add_multi_window` option.
* Upgraded the `pre_gen` hook to appropriately handle configuration cases where the user enables multi-window but does
not enable system menus.
* Upgraded the `post_gen` hook to run `flutter format .` after generating the project to ensure the generated code is 
always formatted correctly.

# 1.1.0
* Added the `debug_label_on` option so developers can choose to turn on/off the debug label via configuration.
* Added support for Flutter's new `PlatformMenuBar` system menus via the `custom_system_menu_bar` option.
* Removed an unused import from `main.dart`.

# 1.0.0

* Initial release 🎉
  * Generate a new Flutter application that uses `macos_ui`
  * Optionally use window translucency
  * Optionally hide the native titlebar
