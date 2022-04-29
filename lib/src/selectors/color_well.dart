import 'dart:async';

import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const _methodChannel = MethodChannel('dev.groovinchip.macos_ui');
const _eventChannel = EventChannel('dev.groovinchip.macos_ui/color_panel');

/// {@template onColorSelected}
/// The action to perform when a color is selected from the color well.
/// {@endtemplate}
typedef OnColorSelected = void Function(Color color);

/// A control that displays a color value and lets the user change that color
/// value.
///
/// Use a color well when you want the user to be able to select a color.
class MacosColorWell extends StatefulWidget {
  const MacosColorWell({
    Key? key,
    required this.onColorSelected,
  }) : super(key: key);

  /// {@macro onColorSelected}
  final OnColorSelected onColorSelected;

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
      debugPrint('color changed: $color');
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
    final _outerColor = MacosTheme.of(context).brightness.isDark
        ? MacosColors.systemGrayColor.withOpacity(0.50)
        : MacosColors.white;
    return GestureDetector(
      onTap: () async {
        try {
          await _methodChannel.invokeMethod('color_panel');
        } catch (e) {
          debugPrint('$e');
        }
      },
      child: SizedBox(
        height: 23.0,
        width: 44.0,
        child: Container(
          decoration: !MacosTheme.of(context).brightness.isDark
              ? BoxDecoration(
                  border: Border.all(
                    color: const MacosColor(0xFFAFAEAE),
                    width: 1.5,
                  ),
                )
              : null,
          child: ColoredBox(
            color: _outerColor,
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
