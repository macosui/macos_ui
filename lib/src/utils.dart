import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// Asserts that the given context has a [MacosTheme] ancestor.
///
/// To call this function, use the following pattern, typically in the
/// relevant Widget's build method:
///
/// ```dart
/// assert(debugCheckHasMacosTheme(context));
/// ```
///
/// Does nothing if asserts are disabled. Always returns true.
bool debugCheckHasMacosTheme(BuildContext context, [bool check = true]) {
  assert(() {
    if (MacosTheme.maybeOf(context) == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('A MacosTheme widget is necessary to draw this layout.'),
        ErrorHint(
          'To introduce a MacosTheme widget, you can either directly '
          'include one, or use a widget that contains MacosTheme itself, '
          'such as MacosApp',
        ),
        ...context.describeMissingAncestor(expectedAncestorType: MacosTheme),
      ]);
    }
    return true;
  }());
  return true;
}

Color textLuminance(Color backgroundColor) {
  return backgroundColor.computeLuminance() >= 0.5
      ? CupertinoColors.black
      : CupertinoColors.white;
}

Color helpIconLuminance(Color backgroundColor, bool isDark) {
  return !isDark
      ? backgroundColor.computeLuminance() > 0.5
          ? CupertinoColors.black
          : CupertinoColors.white
      : backgroundColor.computeLuminance() < 0.5
          ? CupertinoColors.black
          : CupertinoColors.white;
}

Color iconLuminance(Color backgroundColor, bool isDark) {
  if (isDark) {
    return backgroundColor.computeLuminance() > 0.5
        ? CupertinoColors.black
        : CupertinoColors.white;
  } else {
    return backgroundColor.computeLuminance() > 0.5
        ? CupertinoColors.black
        : CupertinoColors.white;
  }
}

class Unsupported {
  const Unsupported(this.message);

  final String message;
}

/// A class that ensures that the application's macOS window's brightness
/// matches the given brightness.
class MacOSBrightnessOverrideHandler {
  static Brightness? _lastBrightness;

  /// Ensures that the application's macOS window's brightness matches
  /// [currentBrightness].
  ///
  /// For performance reasons, the brightness setting will only be overridden if
  /// [currentBrightness] differs from the value it had when this method was
  /// previously called. Therefore, it is safe to call this method frequently.
  static void ensureMatchingBrightness(Brightness currentBrightness) {
    if (kIsWeb) return;
    if (!Platform.isMacOS) return;
    if (currentBrightness == _lastBrightness) return;

    WindowManipulator.overrideMacOSBrightness(dark: currentBrightness.isDark);
    _lastBrightness = currentBrightness;
  }
}

/// A class that listens for changes to the application's window being the main
/// window, and notifies listeners.
class WindowMainStateListener {
  /// A shared instance of [WindowMainStateListener].
  static final instance = WindowMainStateListener();

  /// A [NSWindowDelegateHandle], to be used when deiniting the listener.
  NSWindowDelegateHandle? handle;

  /// Whether the window is currently the main window.
  bool _isWindowMain =
      true; // TODO: Initialize properly once macos_window_utils supports that,
  // see https://github.com/macosui/macos_window_utils.dart/issues/31.

  /// Whether the window is currently the main window.
  bool get isWindowMain => _isWindowMain;

  /// Notifies listeners when the window’s main state changes.
  final _windowMainStateStreamController = StreamController<bool>.broadcast();

  /// A stream of the window’s main state. Emits a new value whenever the state
  /// changes.
  Stream<bool> get onChangedStream => _windowMainStateStreamController.stream;

  /// Initializes the listener. This should only be called once.
  void _init() {
    final delegate = _WindowMainStateListenerDelegate(
      onWindowDidBecomeMain: () {
        _isWindowMain = true;
        _windowMainStateStreamController.add(true);
      },
      onWindowDidResignMain: () {
        _isWindowMain = false;
        _windowMainStateStreamController.add(false);
      },
    );
    handle = WindowManipulator.addNSWindowDelegate(delegate);
  }

  /// Deinitializes the listener.
  void deinit() {
    handle?.removeFromHandler();
  }

  /// A class that listens for changes to the application's window being the
  /// main window, and notifies listeners.
  WindowMainStateListener() {
    _init();
  }
}

/// The [NSWindowDelegate] used by [WindowMainStateListener].
class _WindowMainStateListenerDelegate extends NSWindowDelegate {
  _WindowMainStateListenerDelegate({
    required this.onWindowDidBecomeMain,
    required this.onWindowDidResignMain,
  });

  /// Called when the window becomes the main window.
  final void Function() onWindowDidBecomeMain;

  /// Called when the window resigns as the main window.
  final void Function() onWindowDidResignMain;

  @override
  void windowDidBecomeMain() => onWindowDidBecomeMain();

  @override
  void windowDidResignMain() => onWindowDidResignMain();
}
