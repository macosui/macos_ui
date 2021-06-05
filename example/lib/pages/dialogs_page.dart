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
        MacosAlertDialog(
          appIcon: Container(
            height: 50,
            width: 50,
            color: Colors.red,
          ),
          title: Text(
            'Title',
            style: MacosTheme.of(context).typography.headline,
          ),
          message: Text(
            'This is a message to be shown in an alert dialog',
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
            color: MacosColors.controlColor,
            child: Text('Secondary'),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
