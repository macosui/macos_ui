import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

class DialogsPage extends StatefulWidget {
  const DialogsPage({Key? key}) : super(key: key);

  @override
  _DialogsPageState createState() => _DialogsPageState();
}

class _DialogsPageState extends State<DialogsPage> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      titleBar: const TitleBar(
        title: const Text('macOS UI Dialogs & Sheets'),
      ),
      children: [
        ContentArea(builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  PushButton(
                    buttonSize: ButtonSize.large,
                    child: const Text('Show Alert Dialog 1'),
                    onPressed: () => showMacosAlertDialog(
                      context: context,
                      builder: (context) => MacosAlertDialog(
                        appIcon: const FlutterLogo(
                          size: 56,
                        ),
                        title: const Text(
                          'Alert Dialog with Primary Action',
                        ),
                        message: const Text(
                          'This is an alert dialog with a primary action and no secondary action',
                        ),
                        //horizontalActions: false,
                        primaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          child: const Text('Primary'),
                          onPressed: Navigator.of(context).pop,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PushButton(
                    buttonSize: ButtonSize.large,
                    child: const Text('Show Alert Dialog 2'),
                    onPressed: () => showMacosAlertDialog(
                      context: context,
                      builder: (context) => MacosAlertDialog(
                        appIcon: const FlutterLogo(
                          size: 56,
                        ),
                        title: const Text(
                          'Alert Dialog with Secondary Action',
                        ),
                        message: const Text(
                          'This is an alert dialog with primary action and secondary action laid out horizontally',
                          textAlign: TextAlign.center,
                        ),
                        //horizontalActions: false,
                        primaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          child: const Text('Primary'),
                          onPressed: Navigator.of(context).pop,
                        ),
                        secondaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          color: MacosTheme.brightnessOf(context).isDark
                              ? MacosColors.controlColor.darkColor
                              : MacosColors.controlColor,
                          child: Text(
                            'Secondary',
                            style: TextStyle(
                              color: MacosTheme.brightnessOf(context).isDark
                                  ? MacosColors.controlTextColor.darkColor
                                  : MacosColors.controlTextColor,
                            ),
                          ),
                          onPressed: Navigator.of(context).pop,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PushButton(
                    buttonSize: ButtonSize.large,
                    child: const Text('Show Alert Dialog 3'),
                    onPressed: () => showMacosAlertDialog(
                      context: context,
                      builder: (context) => MacosAlertDialog(
                        appIcon: const FlutterLogo(
                          size: 56,
                        ),
                        title: const Text(
                          'Alert Dialog with Secondary Action',
                        ),
                        message: const Text(
                          'This is an alert dialog with primary action and secondary action laid out vertically',
                          textAlign: TextAlign.center,
                        ),
                        horizontalActions: false,
                        primaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          child: const Text('Primary'),
                          onPressed: Navigator.of(context).pop,
                        ),
                        secondaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          color: MacosTheme.brightnessOf(context).isDark
                              ? MacosColors.controlColor.darkColor
                              : MacosColors.controlColor,
                          child: Text(
                            'Secondary',
                            style: TextStyle(
                              color: MacosTheme.brightnessOf(context).isDark
                                  ? MacosColors.controlTextColor.darkColor
                                  : MacosColors.controlTextColor,
                            ),
                          ),
                          onPressed: Navigator.of(context).pop,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PushButton(
                    buttonSize: ButtonSize.large,
                    child: const Text('Show Alert Dialog 4'),
                    onPressed: () => showMacosAlertDialog(
                      context: context,
                      builder: (context) => MacosAlertDialog(
                        appIcon: const FlutterLogo(
                          size: 56,
                        ),
                        title: const Text(
                          'Alert Dialog with Secondary Action',
                        ),
                        message: const Text(
                          'This is an alert dialog with primary action and secondary '
                          'action laid out vertically. It also contains a "suppress" option.',
                          textAlign: TextAlign.center,
                        ),
                        horizontalActions: false,
                        primaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          child: const Text('Primary'),
                          onPressed: Navigator.of(context).pop,
                        ),
                        secondaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          color: MacosDynamicColor.resolve(
                            MacosColors.controlColor,
                            context,
                          ),
                          child: Text(
                            'Secondary',
                            style: TextStyle(
                              color: MacosDynamicColor.resolve(
                                MacosColors.controlColor,
                                context,
                              ),
                            ),
                          ),
                          onPressed: Navigator.of(context).pop,
                        ),
                        suppress: const DoNotNotifyRow(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PushButton(
                    buttonSize: ButtonSize.large,
                    child: const Text('Show sheet'),
                    onPressed: () {
                      showMacosSheet(
                        context: context,
                        builder: (_) => const MacosuiSheet(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class DoNotNotifyRow extends StatefulWidget {
  const DoNotNotifyRow({Key? key}) : super(key: key);

  @override
  _DoNotNotifyRowState createState() => _DoNotNotifyRowState();
}

class _DoNotNotifyRowState extends State<DoNotNotifyRow> {
  bool suppress = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MacosCheckbox(
          value: suppress,
          onChanged: (value) {
            setState(() => suppress = value);
          },
        ),
        const SizedBox(width: 8),
        const Text('Don\'t ask again'),
      ],
    );
  }
}

class MacosuiSheet extends StatelessWidget {
  const MacosuiSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MacosSheet(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const FlutterLogo(
              size: 56,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to macos_ui',
              style: MacosTheme.of(context).typography.largeTitle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MacosListTile(
                  leading: const Icon(CupertinoIcons.lightbulb),
                  title: Text(
                    'A robust library of Flutter components for macOS',
                    style: MacosTheme.of(context).typography.headline,
                  ),
                  subtitle: Text(
                    'Create native looking macOS applications using Flutter',
                    style:
                        MacosTheme.of(context).typography.subheadline.copyWith(
                              color: MacosColors.systemGrayColor,
                            ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            PushButton(
              buttonSize: ButtonSize.large,
              child: const Text('Dismiss'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
