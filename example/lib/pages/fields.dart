import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:flutter/widgets.dart';

class FieldsPage extends StatefulWidget {
  @override
  _FieldsPageState createState() => _FieldsPageState();
}

class _FieldsPageState extends State<FieldsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MacosTextField(
              prefix: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 2.0,
                ),
                child: Icon(CupertinoIcons.search),
              ),
              placeholder: 'Type some text here',

              /// If both suffix and clear button mode is provided,
              /// suffix will override the clear button.
              // suffix: Text('SUFFIX'),
              clearButtonMode: OverlayVisibilityMode.always,
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MacosTextField.borderless(
              prefix: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(CupertinoIcons.search),
              ),
              placeholder: 'Type some text here',

              /// If both suffix and clear button mode is provided,
              /// suffix will override the clear button.
              suffix: Text('SUFFIX'),
              // clearButtonMode: OverlayVisibilityMode.always,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
