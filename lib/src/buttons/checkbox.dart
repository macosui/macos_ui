import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A checkbox is a type of button that lets the user choose between
/// two opposite states, actions, or values. A selected checkbox is
/// considered on when it contains a checkmark and off when it's empty.
/// A checkbox is almost always followed by a title unless it appears in
/// a checklist.
class MacosCheckbox extends StatelessWidget {
  /// Creates a checkbox.
  ///
  /// [size] must be non-negative
  const MacosCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.size = 16.0,
    this.activeColor,
    this.disabledColor = CupertinoColors.quaternaryLabel,
    this.offBorderColor = CupertinoColors.tertiaryLabel,
    this.semanticLabel,
  })  : assert(size >= 0),
        super(key: key);

  /// Whether the checkbox is checked or not. If null, it'll be considered
  /// mixed.
  final bool? value;

  /// Called whenever the state of the checkbox changes. If null, the checkbox
  /// will be considered disabled
  final ValueChanged<bool>? onChanged;

  /// The size of the checkbox. It must be non-negative.
  final double size;

  /// The background color when the checkbox is on or mixed. If null,
  /// [MacosThemeData.accentColor] is used
  final Color? activeColor;

  /// The background color when the checkbox is disabled. [CupertinoColors.quaternaryLabel]
  /// is used by default
  final Color disabledColor;

  /// The color of the border when the checkbox is off. [CupertinoColors.tertiaryLabel]
  /// is used by default
  final Color offBorderColor;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  /// Whether the checkbox is mixed or not.
  bool get isMixed => value == null;

  /// Whether the checkbox is disabled or not.
  bool get isDisabled => onChanged == null;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty(
      'state',
      isMixed
          ? 'mixed'
          : value!
              ? 'checked'
              : 'unchecked',
    ));
    properties.add(FlagProperty(
      'disabled',
      value: isDisabled,
      ifFalse: 'enabled',
    ));
    properties.add(DoubleProperty('size', size));
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('disabledColor', disabledColor));
    properties.add(ColorProperty('offBorderColor', offBorderColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final MacosThemeData theme = MacosTheme.of(context);
    bool isLight = !theme.brightness.isDark;
    return MouseRegion(
      cursor: theme.mouseCursor,
      child: GestureDetector(
        onTap: () {
          if (value == null || value == false) {
            onChanged?.call(true);
          } else {
            onChanged?.call(false);
          }
        },
        child: Semantics(
          // value == true because [value] can be null
          checked: value == true,
          label: semanticLabel,
          child: Container(
            height: size,
            width: size,
            alignment: Alignment.center,
            decoration: isDisabled || value == null || value == true
                ? BoxDecoration(
                    color: MacosDynamicColor.resolve(
                      isDisabled
                          ? disabledColor
                          : activeColor ?? theme.primaryColor,
                      context,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  )
                : BoxDecoration(
                    color: isLight ? null : CupertinoColors.tertiaryLabel,
                    border: Border.all(
                      style: isLight ? BorderStyle.solid : BorderStyle.none,
                      width: 0.5,
                      color: MacosDynamicColor.resolve(
                        offBorderColor,
                        context,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
            child: Icon(
              isDisabled || value == false
                  ? null
                  : isMixed
                      ? CupertinoIcons.minus
                      : CupertinoIcons.check_mark,
              color: CupertinoColors.white,
              size: (size - 3).clamp(0, size),
            ),
          ),
        ),
      ),
    );
  }
}
