import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';
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
  double ratingValue = 0;
  double sliderValue = 0;
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      titleBar: TitleBar(child: Text("Titlebar")),
      sidebar: Sidebar(
        minWidth: 200,
        builder: (context, _) => Center(child: Text("Sidebar")),
      ),
      children: <Widget>[
        ContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  PushButton(
                    buttonSize: ButtonSize.small,
                    child: Text('Button'),
                    onPressed: () => ScaffoldScope.of(context).toggleSidebar(),
                  ),
                  SizedBox(height: 20),
                  RadioButton(
                    value: value,
                    onChanged: (v) => setState(() => value = v),
                  ),
                  SizedBox(height: 20),
                  Checkbox(
                    value: value,
                    onChanged: (v) => setState(() => value = v),
                  ),
                  SizedBox(height: 20),
                  Tooltip(
                    message: 'This button shows help',
                    child: HelpButton(
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(height: 20),
                  CapacityIndicator(
                    value: sliderValue,
                    onChanged: (v) => setState(() => sliderValue = v),
                    discrete: true,
                  ),
                  SizedBox(height: 20),
                  CapacityIndicator(
                    value: sliderValue,
                    onChanged: (v) => setState(() => sliderValue = v),
                  ),
                  SizedBox(height: 20),
                  RatingIndicator(
                    value: ratingValue,
                    onChanged: (v) => setState(() => ratingValue = v),
                  ),
                  SizedBox(height: 20),
                  RelevanceIndicator(value: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      prefix: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(CupertinoIcons.search),
                      ),
                      placeholder: 'Type some text here',

                      /// If both suffix and clear button mode is provided,
                      /// suffix will override the clear button.
                      // suffix: Text('SUFFIX'),
                      clearButtonMode: OverlayVisibilityMode.always,
                      maxLines: null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField.borderless(
                      prefix: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(CupertinoIcons.search),
                      ),
                      placeholder: 'Type some text here',

                      /// If both suffix and clear button mode is provided,
                      /// suffix will override the clear button.
                      suffix: Text('SUFFIX'),
                      // clearButtonMode: OverlayVisibilityMode.always,
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        ResizablePane(
          minWidth: 300,
          scaffoldBreakpoint: 400,
          resizableSide: ResizableSide.left,
          builder: (_, __) {
            return Center(child: Text("Resizable Pane"));
          },
        ),
      ],
    );
  }
}
