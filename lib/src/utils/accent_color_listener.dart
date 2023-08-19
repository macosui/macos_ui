import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:macos_ui/src/enums/accent_color.dart';

/// A class that listens for changes to the user’s selected system accent color.
///
/// Native macOS applications respond to such changes immediately.
///
/// Example using [StreamBuilder]:
///
/// ```dart
/// StreamBuilder(
///   stream: AccentColorListener.instance.onChanged,
///     builder: (context, _) {
///       final AccentColor? accentColor =
///           AccentColorListener.instance.currentAccentColor;
///
///       return SomeWidget(
///         accentColor: accentColor,
///         child: …
///       );
///     },
///  );
/// ```
class AccentColorListener {
  /// A class that listens to accent color changes.
  AccentColorListener() {
    _init();
  }

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

  /// The active accent color selection.
  AccentColor? _currentAccentColor;

  /// The currently active accent color.
  AccentColor? get currentAccentColor => _currentAccentColor;

  /// Notifies listeners when the accent color changes.
  final _accentColorStreamController = StreamController<void>.broadcast();

  /// Streams the user’s system accent color selection.
  ///
  /// Emits a new value whenever the system accent color selection changes.
  Stream<void> get onChanged => _accentColorStreamController.stream;

  /// A stream subscription for the [SystemColorObserver] stream.
  StreamSubscription<void>? _systemColorObserverStreamSubscription;

  /// Initializes this class.
  void _init() {
    if (kIsWeb) return;
    if (!Platform.isMacOS) return;

    _initCurrentAccentColor();
    _initSystemColorObserver();
  }

  /// Disposes this listener.
  void dispose() {
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

  /// Returns the hue component of the active accent color selection on macOS.
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

    debugPrint(
      'Warning: Falling back on slow accent color resolution. It’s possible '
      'that the accent colors have changed in a recent version of macOS, thus '
      'invalidating macos_ui’s accent colors, which were captured on macOS '
      'Ventura. If you see this message, please notify a maintainer of the '
      'macos_ui package.',
    );

    return _slowlyResolveAccentColorFromHueComponent(hueComponent);
  }

  /// This is a fallback method in case [_resolveAccentColorFromHueComponent]
  /// fails.
  AccentColor _slowlyResolveAccentColorFromHueComponent(double hueComponent) {
    final entries = hueComponentToAccentColor.entries;
    var lowestDistance = double.maxFinite;
    var toBeReturnedAccentColor = AccentColor.values.first;

    for (final entry in entries) {
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
}
