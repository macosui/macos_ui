import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/enums/accent_color.dart';
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
  bool _isMainWindow = true;

  /// Whether the window is currently the main window.
  bool get isMainWindow => _isMainWindow;

  /// Notifies listeners when the window’s main state changes.
  final _windowMainStateStreamController = StreamController<bool>.broadcast();

  /// A stream of the window’s main state. Emits a new value whenever the state
  /// changes.
  Stream<bool> get onChangedStream => _windowMainStateStreamController.stream;

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

/// A class that listens to accent color changes.
class AccentColorListener {
  /// A shared instance of [AccentColorListener].
  static final instance = AccentColorListener();

  /// A map which maps hue components of the [UiElementColor.controlAccentColor]
  /// color captured with the [NSAppearanceName.aqua] appearance in the
  /// [NSColorSpace.genericRGB] color space to the corresponding [AccentColor].
  static final hueComponentToAccentColor = <double, AccentColor>{
    0.6085324903200698: AccentColor.blue,
    0.8285987697113538: AccentColor.purple,
    0.9209523937489168: AccentColor.pink,
    0.9861913496946438: AccentColor.red,
    0.06543037411201169: AccentColor.orange,
    0.11813830353929083: AccentColor.yellow,
    0.29428158007138466: AccentColor.green,
    0.0: AccentColor.graphite,
  };

  /// The currently active accent color.
  AccentColor? _currentAccentColor;

  /// The currently active accent color.
  AccentColor? get currentAccentColor => _currentAccentColor;

  /// Notifies listeners when the accent color changes.
  final _accentColorStreamController = StreamController<void>.broadcast();

  /// An accent color stream. Emits a new value whenever the accent color
  /// changes.
  Stream<void> get onChangedStream => _accentColorStreamController.stream;

  /// A stream subcription for the [SystemColorObserver] stream.
  StreamSubscription<void>? _systemColorObserverStreamSubscription;

  /// Initializes this class.
  void _init() {
    if (kIsWeb) return;
    if (!Platform.isMacOS) return;

    _initCurrentAccentColor();
    _initSystemColorObserver();
  }

  /// Deinitializes this class.
  void deinit() {
    _systemColorObserverStreamSubscription?.cancel();
  }

  /// Initializes the current accent color. This method is to be called whenever
  /// a change is detected.
  Future<void> _initCurrentAccentColor() async {
    final hueComponent = await _getHueComponent();
    _currentAccentColor = _resolveAccentColorFromHueComponent(hueComponent);
    _accentColorStreamController.add(null);
  }

  /// Initializes the current system color observer. This method may only be
  /// called once.
  void _initSystemColorObserver() {
    assert(_systemColorObserverStreamSubscription == null);

    _systemColorObserverStreamSubscription =
        AppkitUiElementColors.systemColorObserver.stream.listen((_) {
      _initCurrentAccentColor();
      _accentColorStreamController.add(null);
    });
  }

  /// Returns the hue component of the currently active accent color on macOS.
  Future<double> _getHueComponent() async {
    final color = await AppkitUiElementColors.getColorComponents(
      uiElementColor: UiElementColor.controlAccentColor,
      components: const {
        NSColorComponent.hueComponent,
      },
      colorSpace: NSColorSpace.genericRGB,
      appearance: NSAppearanceName.aqua,
    );

    assert(color.containsKey("hueComponent"));

    return color["hueComponent"]!;
  }

  /// Returns the [AccentColor] which corresponds to the provided
  /// [hueComponent].
  AccentColor _resolveAccentColorFromHueComponent(double hueComponent) {
    if (hueComponentToAccentColor.containsKey(hueComponent)) {
      return hueComponentToAccentColor[hueComponent]!;
    }

    // ignore: avoid_print
    print(
      'Warning: Falling back on slow accent color resolution. It’s possible '
      'that the accent colors have changed in a recent version of macOS, thus '
      'invalidating macos_ui’s accent colors, which were captured in macOS '
      'Ventura. If you see this message, please notify a maintainer of the '
      'macos_ui package.',
    );

    return _slowlyResolveAccentColorFromHueComponent(hueComponent);
  }

  /// This is a fallback method in case the above method fails.
  AccentColor _slowlyResolveAccentColorFromHueComponent(double hueComponent) {
    final entries = hueComponentToAccentColor.entries;
    var lowestDistance = double.maxFinite;
    var toBeReturnedAccentColor = AccentColor.values.first;

    for (var entry in entries) {
      final distance = _distanceBetweenHueComponents(hueComponent, entry.key);
      if (distance < lowestDistance) {
        lowestDistance = distance;
        toBeReturnedAccentColor = entry.value;
      }
    }

    return toBeReturnedAccentColor;
  }

  /// Returns the distance between two hue components.
  double _distanceBetweenHueComponents(double component1, double component2) {
    final rawDifference = (component1 - component2).abs();
    return sin(rawDifference * pi);
  }

  /// A class that listens to accent color changes.
  AccentColorListener() {
    _init();
  }
}
