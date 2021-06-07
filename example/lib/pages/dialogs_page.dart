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
          onPressed: () => showDialog(
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
          onPressed: () => showDialog(
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
          child: Text('Show Alert Dialog 2'),
          onPressed: () => showDialog(
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
      ],
    );
  }
}
