import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:macos_ui/macos_ui.dart';

class FieldsPage extends StatefulWidget {
  const FieldsPage({Key? key}) : super(key: key);

  @override
  _FieldsPageState createState() => _FieldsPageState();
}

class _FieldsPageState extends State<FieldsPage> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      titleBar: const TitleBar(
        title: Text('macOS UI Fields'),
      ),
      children: [
        ContentArea(builder: (context, scrollController) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: MacosTextField(
                    prefix: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 2.0,
                      ),
                      child: MacosIcon(CupertinoIcons.search),
                    ),
                    placeholder: 'Type some text here',

                    /// If both suffix and clear button mode is provided,
                    /// suffix will override the clear button.
                    // suffix: Text('SUFFIX'),
                    clearButtonMode: OverlayVisibilityMode.always,
                    maxLines: 2,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: MacosTextField.borderless(
                    prefix: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: MacosIcon(CupertinoIcons.search),
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
        }),
        ResizablePane(
          minWidth: 180,
          startWidth: 200,
          windowBreakpoint: 800,
          resizableSide: ResizableSide.left,
          builder: (_, __) {
            return const Center(
              child: Text('Resizable Pane'),
            );
          },
        ),
      ],
    );
  }
}
