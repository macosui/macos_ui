import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

/// A class for configuring macOS window properties.
///
/// Parameters:
/// - [toolbarStyle]: The style of the window toolbar.
/// - [doEnableFullSizeContentView]: Whether to enable the full-size content
///   view.
/// - [doMakeTitlebarTransparent]: Whether to make the title bar transparent.
/// - [doHideTitle]: Whether to hide the window title.
/// - [doRemoveMenubarInFullScreenMode]: Whether to remove the menubar in
/// full-screen mode.
/// - [doAutoHideToolbarAndMenuBarInFullScreenMode]: Whether to auto-hide the
/// toolbar and menubar in full-screen mode.
///
/// Example:
/// ```dart
/// final config = MacosWindowUtilsConfig(
///   toolbarStyle: NSWindowToolbarStyle.expanded,
/// );
/// await config.apply();
/// ```
class MacosWindowUtilsConfig {
  /// Creates a [MacosWindowUtilsConfig].
  ///
  /// The [toolbarStyle] is [NSWindowToolbarStyle.unified] by default. If the
  /// app will have a title bar, use [NSWindowToolbarStyle.expanded] instead.
  const MacosWindowUtilsConfig({
    this.toolbarStyle = NSWindowToolbarStyle.unified,
    this.doEnableFullSizeContentView = true,
    this.doMakeTitlebarTransparent = true,
    this.doHideTitle = true,
    this.doRemoveMenubarInFullScreenMode = true,
    this.doAutoHideToolbarAndMenuBarInFullScreenMode = true,
  });

  /// The style of the window toolbar.
  ///
  /// Defaults to [NSWindowToolbarStyle.unified]. Use
  /// [NSWindowToolbarStyle.expanded] instead if the app will have a title bar.
  final NSWindowToolbarStyle toolbarStyle;

  /// Whether to enable the full-size content view.
  final bool doEnableFullSizeContentView;

  /// Whether to make the title bar transparent.
  final bool doMakeTitlebarTransparent;

  /// Whether to hide the title.
  final bool doHideTitle;

  /// Whether to remove the menubar in full-screen mode.
  final bool doRemoveMenubarInFullScreenMode;

  /// Whether to automatically hide the toolbar and menubar in full-screen mode.
  final bool doAutoHideToolbarAndMenuBarInFullScreenMode;

  /// Applies the configuration to the macOS window.
  ///
  /// This method:
  ///
  /// - Initializes Flutter bindings
  /// - Sets the window material to
  ///   [NSVisualEffectViewMaterial.windowBackground]
  /// - Enables the full size content view if [doEnableFullSizeContentView] is
  /// `true`
  /// - Makes the title bar transparent if [doMakeTitlebarTransparent] is `true`
  /// - Hides the title if [doHideTitle] is `true`
  /// - Adds a toolbar
  /// - Sets the toolbar style to [toolbarStyle]
  /// - Removes the menubar in full-screen mode if
  /// [doRemoveMenubarInFullScreenMode] is `true`
  /// - Auto-hides the toolbar and menubar in full-screen mode if
  /// [doAutoHideToolbarAndMenuBarInFullScreenMode] is `true`
  Future<void> apply() async {
    WidgetsFlutterBinding.ensureInitialized();
    await WindowManipulator.initialize(enableWindowDelegate: true);
    await WindowManipulator.setMaterial(
      NSVisualEffectViewMaterial.windowBackground,
    );
    if (doEnableFullSizeContentView) {
      await WindowManipulator.enableFullSizeContentView();
    }
    if (doMakeTitlebarTransparent) {
      await WindowManipulator.makeTitlebarTransparent();
    }
    if (doHideTitle) {
      await WindowManipulator.hideTitle();
    }
    await WindowManipulator.addToolbar();

    await WindowManipulator.setToolbarStyle(
      toolbarStyle: toolbarStyle,
    );

    if (doRemoveMenubarInFullScreenMode) {
      final delegate = _FlutterWindowDelegate();
      WindowManipulator.addNSWindowDelegate(delegate);
    }

    if (doAutoHideToolbarAndMenuBarInFullScreenMode) {
      final options = NSAppPresentationOptions.from({
        NSAppPresentationOption.fullScreen,
        NSAppPresentationOption.autoHideToolbar,
        NSAppPresentationOption.autoHideMenuBar,
        NSAppPresentationOption.autoHideDock,
      });
      options.applyAsFullScreenPresentationOptions();
    }
  }
}

/// This delegate removes the toolbar in full-screen mode.
class _FlutterWindowDelegate extends NSWindowDelegate {
  @override
  void windowWillEnterFullScreen() {
    WindowManipulator.removeToolbar();
    super.windowWillEnterFullScreen();
  }

  @override
  void windowDidExitFullScreen() {
    WindowManipulator.addToolbar();
    super.windowDidExitFullScreen();
  }
}
