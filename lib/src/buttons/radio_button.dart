import 'package:macos_ui/macos_ui.dart';

/// A radio button is a small, circular button followed by a
/// title. Typically presented in groups of two to five, radio
/// buttons provide the user a set of related but mutually exclusive
/// choices. A radio button’s state is either on (a filled circle)
/// or off (an empty circle).
///
/// ![RadioButton example](https://developer.apple.com/design/human-interface-guidelines/macos/images/radioButtons.png)
class RadioButton extends StatelessWidget {
  /// Creates a radio button.
  ///
  /// [size] must be non-negative
  const RadioButton({
    Key? key,
    required this.value,
    required this.onChanged,
    this.size = 16,
    this.onColor,
    this.offColor = CupertinoColors.tertiaryLabel,
    this.innerColor,
  })  : assert(size >= 0),
        super(key: key);

  /// Whether the button is checked or not
  final bool value;

  /// Called when [value] changes. If null, the button will be
  /// considered disabled.
  final ValueChanged<bool>? onChanged;

  /// The size of the button. Defaults to 16px
  final double size;

  /// The color of the border when [value] is true. If null,
  /// [Style.primaryColor] is used
  final Color? onColor;

  /// The color of the border when [value] is false.
  /// [CupertinoColors.tertiaryLabel] is used by default
  final Color offColor;

  /// The color in the middle. If null, the following colors are
  /// used when:
  ///
  ///   - Disabled: [CupertinoColors.quaternarySystemFill]
  ///   - On: [CupertinoColors.white]
  ///   - Off: [CupertinoColors.tertiarySystemFill]
  final Color? innerColor;

  /// Whether the button is disabled or not
  bool get isDisabled => onChanged == null;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final isLight = context.macosTheme.brightness != Brightness.dark;
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          border: Border.all(
            style: isDisabled ? BorderStyle.none : BorderStyle.solid,
            width: value ? size / 4.0 : 1,
            color: DynamicColorX.macosResolve(
              value
                  ? onColor ??
                      context.macosTheme.primaryColor ??
                      CupertinoColors.activeBlue
                  : offColor,
              context,
            ),
          ),
          shape: BoxShape.circle,
        ),
        // The inner color is inside another container because it sometimes
        // overlap the border when used together
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: DynamicColorX.macosResolve(
              innerColor ??
                  (isDisabled
                      ? CupertinoColors.quaternarySystemFill
                      : value || isLight
                          ? CupertinoColors.white
                          : CupertinoColors.tertiarySystemFill),
              context,
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                offset: Offset(-0.05, -0.05),
              ),
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                offset: Offset(0.05, 0.05),
              ),
              BoxShadow(
                color: CupertinoColors.tertiarySystemFill,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
