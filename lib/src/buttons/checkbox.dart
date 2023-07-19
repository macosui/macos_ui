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
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 14.0,
    this.activeColor,
    this.disabledColor = CupertinoColors.quaternaryLabel,
    this.offBorderColor = CupertinoColors.tertiaryLabel,
    this.semanticLabel,
  }) : assert(size >= 0);

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
    return GestureDetector(
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
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                )
              : isLight
                  ? ShapeDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(0.0, -1.0),
                        end: const Alignment(0, 0),
                        colors: [
                          Colors.white.withOpacity(0.85),
                          Colors.white.withOpacity(1.0),
                        ],
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 1,
                          blurStyle: BlurStyle.inner,
                          offset: Offset(0, 0),
                          spreadRadius: 0.0,
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.25,
                          color: Colors.black.withOpacity(0.35000000596046448),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3.5)),
                      ),
                    )
                  : ShapeDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(0.0, -1.0),
                        end: const Alignment(0, 1),
                        colors: [
                          Colors.white.withOpacity(0.14000000059604645),
                          Colors.white.withOpacity(0.2800000011920929),
                        ],
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 1,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        ),
                      ],
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
    );
  }
}
