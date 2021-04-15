import 'package:macos_ui/macos_ui.dart';

/// A checkbox is a type of button that lets the user choose between
/// two opposite states, actions, or values. A selected checkbox is
/// considered on when it contains a checkmark and off when it's empty.
/// A checkbox is almost always followed by a title unless it appears in
/// a checklist.
class Checkbox extends StatelessWidget {
  /// Creates a checkbox.
  ///
  /// [size] must be non-negative
  const Checkbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.size = 16.0,
    this.activeColor,
    this.disabledColor = CupertinoColors.quaternaryLabel,
    this.offBorderColor = CupertinoColors.tertiaryLabel,
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
  /// [Style.activeColor] is used
  final Color? activeColor;

  /// The background color when the checkbox is disabled. [CupertinoColors.quaternaryLabel]
  /// is used by default
  final Color disabledColor;

  /// The color of the border when the checkbox is off. [CupertinoColors.tertiaryLabel]
  /// is used by default
  final Color offBorderColor;

  /// Whether the checkbox is mixed or not.
  bool get isMixed => value == null;

  /// Whether the checkbox is disabled or not.
  bool get isDisabled => onChanged == null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (value == null || value == false) {
          onChanged?.call(true);
        } else {
          onChanged?.call(false);
        }
      },
      child: Container(
        height: size,
        width: size,
        alignment: Alignment.center,
        decoration: isDisabled || value == null || value == true
            ? BoxDecoration(
                color: CupertinoDynamicColor.resolve(
                  isDisabled
                      ? disabledColor
                      : activeColor ??
                          context.maybeStyle?.accentColor ??
                          CupertinoColors.activeBlue,
                  context,
                ),
                borderRadius: BorderRadius.circular(4.0),
              )
            : BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: CupertinoDynamicColor.resolve(
                    offBorderColor,
                    context,
                  ),
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
        child: Icon(
          isDisabled
              ? null
              : isMixed
                  ? CupertinoIcons.minus
                  : value == false
                      ? null
                      : CupertinoIcons.check_mark,
          color: CupertinoColors.white,
          size: (size - 3).clamp(0, size),
        ),
      ),
    );
  }
}
