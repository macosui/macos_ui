import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// An Icon widget that respects a macOS icon theme.
class MacosIcon extends StatelessWidget {
  /// Creates an icon.
  ///
  /// The [size] and [color] default to the value given by the current
  /// [MacosIconTheme].
  const MacosIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
    this.textDirection,
  });

  /// The icon to display. The available icons are described in [Icons]
  /// and [CupertinoIcons].
  ///
  /// The icon can be null, in which case the widget will render as an empty
  /// space of the specified [size].
  final IconData? icon;

  /// The size of the icon in logical pixels.
  ///
  /// Icons occupy a square with width and height equal to size.
  ///
  /// Defaults to the current [MacosIconTheme] size, if any. If there is no
  /// [MacosIconTheme], or it does not specify an explicit size, then it
  /// defaults to 24.0.
  final double? size;

  /// The color to use when drawing the icon.
  ///
  /// Defaults to the current [MacosIconTheme] color, if any.
  ///
  /// The color (whether specified explicitly here or obtained from the
  /// [MacosIconTheme]) will be further adjusted by the opacity of the current
  /// [MacosIconTheme], if any.
  ///
  /// If no [MacosIconTheme] and no [MacosTheme] is specified, icons will
  /// default to the color value of [CupertinoColors.activeBlue.color].
  ///
  /// See [MacosTheme] to set the current theme and [MacosThemeData.brightness]
  /// for setting the current theme's brightness.
  final Color? color;

  /// Semantic label for the icon.
  ///
  /// Announced in accessibility modes (e.g TalkBack/VoiceOver).
  /// This label does not show in the UI.
  ///
  ///  * [SemanticsProperties.label], which is set to [semanticLabel] in the
  ///    underlying	 [Semantics] widget.
  final String? semanticLabel;

  /// The text direction to use for rendering the icon.
  ///
  /// If this is null, the ambient [Directionality] is used instead.
  ///
  /// Some icons follow the reading direction. For example, "back" buttons point
  /// left in left-to-right environments and right in right-to-left
  /// environments. Such icons have their [IconData.matchTextDirection] field
  /// set to true, and the [MacosIcon] widget uses the [textDirection] to
  /// determine the orientation in which to draw the icon.
  ///
  /// This property has no effect if the [icon]'s [IconData.matchTextDirection]
  /// field is false, but for consistency a text direction value must always be
  /// specified, either directly using this property or using [Directionality].
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    assert(this.textDirection != null || debugCheckHasDirectionality(context));
    final TextDirection textDirection =
        this.textDirection ?? Directionality.of(context);

    final iconTheme = MacosIconTheme.of(context);

    final iconSize = size ?? iconTheme.size;

    if (icon == null) {
      return Semantics(
        label: semanticLabel,
        child: SizedBox(
          width: iconSize,
          height: iconSize,
        ),
      );
    }

    final iconOpacity = iconTheme.opacity ?? 1.0;
    Color iconColor = color ?? iconTheme.color!;
    if (iconOpacity != 1.0) {
      iconColor = iconColor.withValues(alpha: iconColor.a * iconOpacity);
    }

    Widget iconWidget = RichText(
      overflow: TextOverflow.visible,
      textDirection: textDirection,
      text: TextSpan(
        text: String.fromCharCode(icon!.codePoint),
        style: TextStyle(
          inherit: false,
          color: iconColor,
          fontSize: iconSize,
          fontFamily: icon!.fontFamily,
          package: icon!.fontPackage,
        ),
      ),
    );

    if (icon!.matchTextDirection) {
      switch (textDirection) {
        case TextDirection.rtl:
          iconWidget = Transform(
            transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
            alignment: Alignment.center,
            transformHitTests: false,
            child: iconWidget,
          );
          break;
        case TextDirection.ltr:
          break;
      }
    }

    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: Center(
            child: iconWidget,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IconDataProperty(
      'icon',
      icon,
      ifNull: '<empty>',
      showName: false,
    ));
    properties.add(DoubleProperty('size', size, defaultValue: null));
    properties.add(ColorProperty('color', color, defaultValue: null));
  }
}
