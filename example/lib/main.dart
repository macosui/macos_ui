import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'macos_ui example',
      debugShowCheckedModeBanner: false, //yay!
      home: Scaffold(),//fixme: replace with actual screen
    );
  }
}