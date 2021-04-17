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
          theme: MacosThemeData.light(),
          darkTheme: MacosThemeData.dark(),
          themeMode: ThemeMode.dark,
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PushButton(
            buttonSize: ButtonSize.small,
            child: Text('Button'),
            onPressed: () {},
          ),
          Checkbox(
            value: value,
            onChanged: (v) => setState(() => value = v),
          ),
        ],
      ),
    );
  }
}
