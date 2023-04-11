import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

/// A class for configuring macOS window properties.
///
/// [toolbarStyle] is the style of the window toolbar. It should be
/// [NSWindowToolbarStyle.expanded] if the app will have a title bar and
/// [NSWindowToolbarStyle.unified] otherwise.
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
    this.enableFullSizeContentView = true,
    this.makeTitlebarTransparent = true,
    this.hideTitle = true,
    this.removeMenubarInFullScreenMode = true,
    this.autoHideToolbarAndMenuBarInFullScreenMode = true,
  });

  /// The style of the window toolbar.
  ///
  /// Defaults to [NSWindowToolbarStyle.unified]. Use
  /// [NSWindowToolbarStyle.expanded] instead if the app will have a title bar.
  final NSWindowToolbarStyle toolbarStyle;

  /// Whether to enable the full-size content view.
  final bool enableFullSizeContentView;

  /// Whether to make the title bar transparent.
  final bool makeTitlebarTransparent;

  /// Whether to hide the title.
  final bool hideTitle;

  /// Whether to remove the menubar in full-screen mode.
  final bool removeMenubarInFullScreenMode;

  /// Whether to automatically hide the toolbar and menubar in full-screen mode.
  final bool autoHideToolbarAndMenuBarInFullScreenMode;

  /// Applies the configuration to the macOS window.
  ///
  /// This method:
  ///
  /// - Initializes Flutter bindings
  /// - Sets the window material to
  ///   [NSVisualEffectViewMaterial.windowBackground]
  /// - Enables the full size content view if [enableFullSizeContentView] is
  /// `true`
  /// - Makes the title bar transparent if [makeTitlebarTransparent] is `true`
  /// - Hides the title if [hideTitle] is `true`
  /// - Adds a toolbar
  /// - Sets the toolbar style to [toolbarStyle]
  /// - Removes the menubar in full-screen mode if
  /// [removeMenubarInFullScreenMode] is `true`
  /// - Auto-hides the toolbar and menubar in full-screen mode if
  /// [autoHideToolbarAndMenuBarInFullScreenMode] is `true`
  Future<void> apply() async {
    WidgetsFlutterBinding.ensureInitialized();
    await WindowManipulator.initialize(enableWindowDelegate: true);
    await WindowManipulator.setMaterial(
      NSVisualEffectViewMaterial.windowBackground,
    );
    if (enableFullSizeContentView) {
      await WindowManipulator.enableFullSizeContentView();
    }
    if (makeTitlebarTransparent) {
      await WindowManipulator.makeTitlebarTransparent();
    }
    if (hideTitle) {
      await WindowManipulator.hideTitle();
    }
    await WindowManipulator.addToolbar();

    await WindowManipulator.setToolbarStyle(
      toolbarStyle: toolbarStyle,
    );

    if (removeMenubarInFullScreenMode) {
      final delegate = _FlutterWindowDelegate();
      WindowManipulator.addNSWindowDelegate(delegate);
    }

    if (autoHideToolbarAndMenuBarInFullScreenMode) {
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
