import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

/// A macOS-style AlertDialog.
///
/// A [MacosAlertDialog] must display an [appIcon], [title], [message],
/// and [primaryButton].
class MacosAlertDialog extends StatelessWidget {
  /// Builds a macOS-style Alert Dialog
  const MacosAlertDialog({
    Key? key,
    required this.appIcon,
    required this.title,
    required this.message,
    required this.primaryButton,
    this.secondaryButton,
    this.horizontalActions = true,
    this.suppress,
  }) : super(key: key);

  /// This should be your application's icon.
  ///
  /// The size of this widget should be 56x56.
  final Widget appIcon;

  /// The title for the dialog.
  ///
  /// Typically a Text widget.
  final Widget title;

  /// The content to display in the dialog.
  ///
  /// Typically a Text widget.
  final Widget message;

  /// The primary action a user can take.
  ///
  /// Typically a [PushButton].
  final Widget primaryButton;

  /// The secondary action a user can take.
  ///
  /// Typically a [PushButton].
  final Widget? secondaryButton;

  /// Determines whether to lay out [primaryButton] and [secondaryButton]
  /// horizontally or vertically.
  ///
  /// Defaults to `true`.
  final bool? horizontalActions;

  /// A widget to allow users to suppress alerts of this type.
  ///
  /// The logic for this should be user-implemented. Here is a sample of a
  /// widget that can be passed in for this parameter:
  /// ```dart
  /// class DoNotNotifyRow extends StatefulWidget {
  ///   const DoNotNotifyRow({Key? key}) : super(key: key);
  ///
  ///   @override
  ///   _DoNotNotifyRowState createState() => _DoNotNotifyRowState();
  /// }
  ///
  /// class _DoNotNotifyRowState extends State<DoNotNotifyRow> {
  ///   bool suppress = false;
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Row(
  ///       mainAxisAlignment: MainAxisAlignment.center,
  ///       children: [
  ///         MacosCheckbox(
  ///           value: suppress,
  ///           onChanged: (value) {
  ///             setState(() => suppress = value);
  ///           },
  ///         ),
  ///         const SizedBox(width: 8),
  ///         Text('Don\'t ask again'),
  ///       ],
  ///     );
  ///   }
  /// }
  /// ```
  ///
  /// Notable, the above widget is a `StatefulWidget`. Your widget must be
  /// stateful or your checkbox will not update as you expect.
  final Widget? suppress;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: MacosTheme.brightnessOf(context).isDark
          ? MacosColors.controlBackgroundColor.darkColor
          : MacosColors.controlBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 260),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 28),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 56,
                maxWidth: 56,
              ),
              child: appIcon,
            ),
            const SizedBox(height: 28),
            DefaultTextStyle(
              style: MacosTheme.of(context).typography.headline,
              child: title,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DefaultTextStyle(
                textAlign: TextAlign.center,
                style: MacosTheme.of(context).typography.headline,
                child: message,
              ),
            ),
            const SizedBox(height: 12),
            if (secondaryButton == null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: primaryButton,
                    ),
                  ],
                ),
              ),
            ] else ...[
              if (horizontalActions!) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      if (secondaryButton != null) ...[
                        Expanded(
                          child: secondaryButton!,
                        ),
                        const SizedBox(width: 8.0),
                      ],
                      Expanded(
                        child: primaryButton,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(child: primaryButton),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      if (secondaryButton != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: secondaryButton!,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
            const SizedBox(height: 16),
            if (suppress != null)
              DefaultTextStyle(
                style: MacosTheme.of(context).typography.headline,
                child: suppress!,
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
