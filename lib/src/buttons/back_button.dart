import 'package:macos_ui/macos_ui.dart';
import 'package:flutter/material.dart' show Material, NoSplash, InkWell;
import 'package:macos_ui/src/library.dart';

/// A macOS style back button.
class BackButton extends StatelessWidget {
  /// Creates a `BackButton` with the appropriate icon/background colors based
  /// on light/dark themes.
  const BackButton({
    Key? key,
    this.onPressed,
    this.fillColor,
  }) : super(key: key);

  /// An override callback to perform instead of the default behavior which is
  /// to pop the [Navigator].
  final VoidCallback? onPressed;

  /// The color to fill the space around the icon with.
  final Color? fillColor;

  //TODO: custom animation like PushButton - this animates in the wrong way
  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.of(context).brightness;
    final iconColor = brightness == Brightness.dark
        ? CupertinoColors.white
        : CupertinoColors.black;
    final backgroundColor =
        brightness == Brightness.dark ? Color(0xff323232) : Color(0xffF4F5F5);
    final splashColor =
        brightness == Brightness.dark ? Color(0xff565B71) : Color(0xffE5E5E5);
    return Material(
      color: fillColor ?? backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        borderRadius: BorderRadius.circular(7),
        splashFactory: NoSplash.splashFactory,
        splashColor: splashColor,
        onTap: onPressed,
        child: Container(
          width: 20, // eyeballed
          height: 20, // eyeballed
          child: Icon(
            CupertinoIcons.back,
            size: 18, // eyeballed
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
