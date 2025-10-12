import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';

/// A class that listens for changes to the application’s main window.
///
/// A common use-case for responding to such changes would be to mute the colors
/// of certain primary UI elements when the window is no longer in focus, which
/// is something native macOS applications do out of the box.
///
/// Example using [StreamBuilder]:
///
/// ```dart
/// StreamBuilder(
///   stream: WindowMainStateListener.instance.onChanged,
///     builder: (context, _) {
///       final bool isMainWindow
///           = WindowMainStateListener.instance.isMainWindow;
///
///       return SomeWidget(
///         isMainWindow: isMainWindow,
///         child: …
///       );
///     },
///  );
/// ```
class WindowMainStateListener {
  /// A class that listens for changes to the application’s window being the
  /// main window, and notifies listeners.
  WindowMainStateListener() {
    _init();
  }

  /// A shared instance of [WindowMainStateListener].
  static final instance = WindowMainStateListener();

  /// A [NSWindowDelegateHandle], to be used when disposing the listener.
  NSWindowDelegateHandle? handle;

  /// Whether the window is currently the main window.
  bool _isMainWindow = true;

  /// Overrides the value of [_isMainWindow].
  bool? _isMainWindowOverride;

  /// Whether the window is currently the main window.
  bool get isMainWindow => _isMainWindowOverride ?? _isMainWindow;

  /// Notifies listeners when the window’s main state changes.
  final _windowMainStateStreamController = StreamController<bool>.broadcast();

  /// Overrides the value of [isMainWindow].
  ///
  /// Passing `null` will remove the override.
  void overrideIsMainWindow(bool? value) {
    _isMainWindowOverride = value;
    _windowMainStateStreamController.add(isMainWindow);
  }

  /// A stream of the window’s main state. Emits a new value whenever the state
  /// changes.
  Stream<bool> get onChanged => _windowMainStateStreamController.stream;

  /// Initializes the listener. This should only be called once.
  void _init() {
    if (kIsWeb) return;
    if (!Platform.isMacOS) return;

    _initDelegate();
    _initIsWindowMain();
  }

  /// Initializes the [NSWindowDelegate] to listen for main window changes.
  void _initDelegate() {
    final delegate = _WindowMainStateListenerDelegate(
      onWindowDidBecomeMain: () {
        _isMainWindow = true;
        _windowMainStateStreamController.add(true);
      },
      onWindowDidResignMain: () {
        _isMainWindow = false;
        _windowMainStateStreamController.add(false);
      },
    );
    handle = WindowManipulator.addNSWindowDelegate(delegate);
  }

  /// Initializes the [_isMainWindow] variable.
  Future<void> _initIsWindowMain() async {
    _isMainWindow = await WindowManipulator.isMainWindow();
    _windowMainStateStreamController.add(_isMainWindow);
  }

  /// Disposes this listener.
  void dispose() {
    handle?.removeFromHandler();
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
