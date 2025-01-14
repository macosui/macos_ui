// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const _methodChannel = MethodChannel('dev.groovinchip.macos_ui');
const _eventChannel = EventChannel('dev.groovinchip.macos_ui/color_panel');

/// Describes the possible modes for an `NSColorPanel`.
///
/// Source documentation: https://developer.apple.com/documentation/appkit/nscolorpanel/mode
enum ColorPickerMode {
  /// No color panel mode.
  none,

  /// The grayscale-alpha color mode.
  gray,

  /// The red-green-blue color mode.
  RBG,

  /// The cyan-magenta-yellow-black color mode.
  CMYK,

  /// The hue-saturation-brightness color mode.
  HSB,

  /// The custom palette color mode.
  customPalette,

  /// The custom color list mode.
  colorList,

  /// The color wheel mode.
  wheel,

  /// The crayon picker mode.
  crayon,
}

/// {@template onColorSelected}
/// The action to perform when a color is selected from the color well.
/// {@endtemplate}
typedef OnColorSelected = void Function(Color color);

/// {@template macosColorWell}
/// A control that displays a color value and lets the user change that color
/// value.
///
/// When a `MacosColorWell` is clicked, it opens the native macOS color panel,
/// which is an `NSColorPanel` from the Swift Cocoa library.
///
/// Use a [MacosColorWell] when you want the user to be able to select a color.
/// {@endtemplate}
class MacosColorWell extends StatefulWidget {
  /// {@macro macosColorWell}
  const MacosColorWell({
    super.key,
    required this.onColorSelected,
    this.defaultMode = ColorPickerMode.wheel,
  });

  /// {@macro onColorSelected}
  final OnColorSelected onColorSelected;

  /// The default [ColorPickerMode] to open the `NSColorPanel` with.
  ///
  /// Defaults to [ColorPickerMode.wheel].
  final ColorPickerMode defaultMode;

  @override
  State<MacosColorWell> createState() => _MacosColorWellState();
}

class _MacosColorWellState extends State<MacosColorWell> {
  Color? _selectedColor;

  Stream<Color>? _onColorChanged;
  Stream<Color> get onColorChanged {
    _onColorChanged ??= _eventChannel
        .receiveBroadcastStream()
        .map((event) => Color(int.parse(event)));
    return _onColorChanged!;
  }

  late StreamSubscription<Color> _colorSubscription;

  @override
  void initState() {
    super.initState();
    _colorSubscription = onColorChanged.listen((color) {
      setState(() => _selectedColor = color);
    });
  }

  @override
  void dispose() {
    _colorSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = MacosTheme.of(context);
    final outerColor = theme.brightness.isDark
        ? MacosColors.systemGrayColor.withValues(alpha: 0.5)
        : MacosColors.white;
    return GestureDetector(
      onTap: () async {
        try {
          await _methodChannel.invokeMethod('color_panel', {
            'mode': '${widget.defaultMode}',
          });
        } on MissingPluginException {
          throw MissingPluginException(
            'Cannot open NSColorPanel on platforms other than macOS.',
          );
        } catch (e) {
          debugPrint('Failed to open color panel: $e');
        }
      },
      child: SizedBox(
        height: 23.0,
        width: 44.0,
        child: Container(
          decoration: !theme.brightness.isDark
              ? BoxDecoration(
                  border: Border.all(
                    color: const MacosColor(0xFFAFAEAE),
                    width: 1.5,
                  ),
                )
              : null,
          child: ColoredBox(
            color: outerColor,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                height: 17.0,
                width: 38.0,
                child: ColoredBox(
                  color: _selectedColor ?? MacosColors.systemBlueColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
