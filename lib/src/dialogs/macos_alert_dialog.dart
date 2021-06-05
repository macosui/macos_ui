import 'package:flutter/material.dart';

class MacosAlertDialog extends StatelessWidget {
  const MacosAlertDialog({
    Key? key,
    required this.appIcon,
    required this.title,
    required this.message,
    required this.primaryButton,
    this.secondaryButton,
    this.horizontalActions = true,
  }) : super(key: key);

  final Widget appIcon;
  final Widget title;
  final Widget message;
  final Widget primaryButton;
  final Widget? secondaryButton;
  final bool? horizontalActions;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        /*minWidth: 260,
        minHeight: 238,*/
        maxHeight: 300,
        maxWidth: 260,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 28),
            appIcon,
            const SizedBox(height: 28),
            title,
            const SizedBox(height: 16),
            message,
            const SizedBox(height: 12),
            if (secondaryButton == null) ...[
              Row(
                children: [
                  Expanded(
                    child: primaryButton,
                  ),
                ],
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
