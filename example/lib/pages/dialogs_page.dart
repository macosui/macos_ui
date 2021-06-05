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
          child: Text('Show Alert Dialog'),
          onPressed: () => showDialog(
            context: context,
            builder: (_) => MacosAlertDialog(
              appIcon: FlutterLogo(
                size: 56,
              ),
              title: Text(
                'Title',
                style: MacosTheme.of(context).typography.headline,
              ),
              message: Text(
                'This is a message to be shown in an alert dialog',
                textAlign: TextAlign.center,
                style: MacosTheme.of(context).typography.headline,
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
      ],
    );
  }
}
