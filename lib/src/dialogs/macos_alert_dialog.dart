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
        constraints: BoxConstraints(
          maxHeight: 300,
          maxWidth: 260,
        ),
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
          ],
        ),
      ),
    );
  }
}
