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
            accentColor: CupertinoColors.systemIndigo,
          ),
          darkStyle: Style(
            brightness: Brightness.dark,
            accentColor: CupertinoColors.systemIndigo,
          ),
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false, //yay!
          home: Demo(),
        );
      },
    );
  }
}

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      titleBar: TitleBar(
        child: Text("Titlebar"),
      ),
      sidebar: Sidebar(
        minWidth: 200,
        builder: (context, _) {
          return Center(
            child: Text("Sidebar"),
          );
        },
      ),
      children: <Widget>[
        ContentArea(
          builder: (context, _) {
            return Center(
              child: Text("ContentArea"),
            );
          },
        ),
        ResizablePane(
          minWidth: 200,
          resizableSide: ResizableSide.left,
          builder: (context, _) {
            return Center(
              child: Text("ResizablePane"),
            );
          },
        ),
      ],
    );
  }
}
