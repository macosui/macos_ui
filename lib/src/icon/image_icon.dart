import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';

/// {@template macosImageIcon}
/// An icon that comes from an [ImageProvider], e.g. an [AssetImage].
///
/// The [size] and [color] default to the value given by the current [MacosIconTheme].
///
/// See also:
///  * [MacosIconButton], for interactive icons.
///  * [MacosIconTheme], which provides ambient configuration for icons.
///  * [MacosIcon], for icons based on glyphs from fonts instead of images.
/// {@endtemplate}
class MacosImageIcon extends StatelessWidget {
  /// {@macro macosImageIcon}
  const MacosImageIcon(
    this.image, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  /// The image to display as the icon.
  ///
  /// The icon can be null, in which case the widget will render as an empty
  /// space of the specified [size].
  final ImageProvider? image;

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
  /// Defaults to the current [MacosIconTheme] color, if any. If there is
  /// no [MacosIconTheme], then it defaults to not recolorizing the image.
  ///
  /// The image will be additionally adjusted by the opacity of the current
  /// [MacosIconTheme], if any.
  final Color? color;

  /// Semantic label for the icon.
  ///
  /// Announced in accessibility modes (e.g TalkBack/VoiceOver).
  /// This label does not show in the UI.
  ///
  ///  * [SemanticsProperties.label], which is set to [semanticLabel] in the
  ///    underlying	 [Semantics] widget.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final iconTheme = MacosIconTheme.of(context);
    final iconSize = size ?? iconTheme.size;

    if (image == null) {
      return Semantics(
        label: semanticLabel,
        child: SizedBox(width: iconSize, height: iconSize),
      );
    }

    final iconOpacity = iconTheme.opacity;
    Color iconColor = color ?? iconTheme.color!;

    if (iconOpacity != null && iconOpacity != 1.0) {
      iconColor = iconColor.withValues(alpha: iconColor.a * iconOpacity);
    }

    return Semantics(
      label: semanticLabel,
      child: Image(
        image: image!,
        width: iconSize,
        height: iconSize,
        color: iconColor,
        fit: BoxFit.scaleDown,
        excludeFromSemantics: true,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ImageProvider>(
      'image',
      image,
      ifNull: '<empty>',
      showName: false,
    ));
    properties.add(DoubleProperty('size', size, defaultValue: null));
    properties.add(ColorProperty('color', color, defaultValue: null));
  }
}
