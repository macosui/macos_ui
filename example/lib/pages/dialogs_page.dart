import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class DialogsPage extends StatefulWidget {
  DialogsPage({Key? key}) : super(key: key);

  @override
  _DialogsPageState createState() => _DialogsPageState();
}

class _DialogsPageState extends State<DialogsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PushButton(
          buttonSize: ButtonSize.large,
          child: Text('Show Alert Dialog 1'),
          onPressed: () => showMacosAlertDialog(
            context: context,
            builder: (_) => MacosAlertDialog(
              appIcon: FlutterLogo(
                size: 56,
              ),
              title: Text(
                'Alert Dialog with Primary Action',
              ),
              message: Text(
                'This is an alert dialog with a primary action and no secondary action',
              ),
              //horizontalActions: false,
              primaryButton: PushButton(
                buttonSize: ButtonSize.large,
                child: Text('Primary'),
                onPressed: () {},
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        PushButton(
          buttonSize: ButtonSize.large,
          child: Text('Show Alert Dialog 2'),
          onPressed: () => showMacosAlertDialog(
            context: context,
            builder: (_) => MacosAlertDialog(
              appIcon: FlutterLogo(
                size: 56,
              ),
              title: Text(
                'Alert Dialog with Secondary Action',
              ),
              message: Text(
                'This is an alert dialog with primary action and secondary action laid out horizontally',
                textAlign: TextAlign.center,
              ),
              //horizontalActions: false,
              primaryButton: PushButton(
                buttonSize: ButtonSize.large,
                child: Text('Primary'),
                onPressed: () {},
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
                onPressed: () {},
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        PushButton(
          buttonSize: ButtonSize.large,
          child: Text('Show Alert Dialog 3'),
          onPressed: () => showMacosAlertDialog(
            context: context,
            builder: (_) => MacosAlertDialog(
              appIcon: FlutterLogo(
                size: 56,
              ),
              title: Text(
                'Alert Dialog with Secondary Action',
              ),
              message: Text(
                'This is an alert dialog with primary action and secondary action laid out vertically',
                textAlign: TextAlign.center,
              ),
              horizontalActions: false,
              primaryButton: PushButton(
                buttonSize: ButtonSize.large,
                child: Text('Primary'),
                onPressed: () {},
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
                onPressed: () {},
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        PushButton(
          buttonSize: ButtonSize.large,
          child: Text('Show Alert Dialog 4'),
          onPressed: () => showMacosAlertDialog(
            context: context,
            builder: (_) => MacosAlertDialog(
              appIcon: FlutterLogo(
                size: 56,
              ),
              title: Text(
                'Alert Dialog with Secondary Action',
              ),
              message: Text(
                'This is an alert dialog with primary action and secondary '
                'action laid out vertically. It also contains a "suppress" option.',
                textAlign: TextAlign.center,
              ),
              horizontalActions: false,
              primaryButton: PushButton(
                buttonSize: ButtonSize.large,
                child: Text('Primary'),
                onPressed: () {},
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
                onPressed: () {},
              ),
              suppress: DoNotNotifyRow(),
            ),
          ),
        ),
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
        Text('Don\'t ask again'),
      ],
    );
  }
}
