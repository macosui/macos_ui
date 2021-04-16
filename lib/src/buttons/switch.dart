import 'package:flutter/gestures.dart';
import 'package:macos_ui/macos_ui.dart';

import 'package:flutter/cupertino.dart' as c;

/// A switch is a visual toggle between two mutually exclusive
/// states — on and off. A switch shows that it's on when the
/// accent color is visible and off when the switch appears colorless.
class Switch extends StatelessWidget {
  const Switch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.activeColor,
    this.trackColor,
  }) : super(key: key);

  /// Whether this switch is on or off.
  ///
  /// Must not be null.
  final bool value;

  /// Called when the user toggles with switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// value.
  ///
  /// If null, the switch will be displayed as disabled, which has a reduced opacity.
  ///
  /// The callback provided to onChanged should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// Switch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool>? onChanged;

  /// {@macro flutter.cupertino.CupertinoSwitch.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// The color to use when this switch is on.
  ///
  /// Defaults to [MacosThemeData.primaryColor] when null.
  final Color? activeColor;

  /// The color to use for the background when the switch is off.
  ///
  /// Defaults to [CupertinoColors.secondarySystemFill] when null.
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    return c.CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      dragStartBehavior: dragStartBehavior,
      activeColor: activeColor ??
          context.macosTheme.primaryColor ??
          CupertinoColors.activeBlue,
      trackColor: trackColor,
    );
  }
}
