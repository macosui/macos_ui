import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return MacosApp(
          title: 'macos_ui example',
          style: Style(
            brightness: Brightness.light,
            //primaryColor: CupertinoColors.systemIndigo,
          ),
          darkStyle: Style(
            brightness: Brightness.dark,
            //primaryColor: CupertinoColors.systemIndigo,
          ),
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          home: Demo(),
        );
      },
    );
  }
}

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {

  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      sidebar: Center(
        child: Text('Sidebar'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PushButton(
            child: Text('Button'),
            onPressed: () => print('click'),
          ),
          Switch(
            value: value,
            onChanged: (v) => setState(() => value = v),
          ),
        ],
      ),
    );
  }
}
