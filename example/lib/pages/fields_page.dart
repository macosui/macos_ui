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
      toolBar: ToolBar(
        title: const Text('Fields'),
        titleWidth: 150.0,
        actions: [
          ToolBarIconButton(
            label: 'Toggle Sidebar',
            icon: const MacosIcon(
              CupertinoIcons.sidebar_left,
            ),
            onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
            showLabel: false,
          ),
        ],
      ),
      children: [
        ContentArea(builder: (context, scrollController) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: const [
                SizedBox(
                  width: 300.0,
                  child: MacosTextField(
                    placeholder: 'Type some text here',
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300.0,
                  child: MacosTextField(
                    prefix: MacosIcon(CupertinoIcons.money_dollar),
                    placeholder: 'Type some text here',

                    /// If both suffix and clear button mode is provided,
                    /// suffix will override the clear button.
                    // suffix: Text('SUFFIX'),
                    clearButtonMode: OverlayVisibilityMode.always,
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300.0,
                  child: MacosTextField.borderless(
                    prefix: MacosIcon(CupertinoIcons.search),
                    placeholder: 'Type some text here',

                    /// If both suffix and clear button mode is provided,
                    /// suffix will override the clear button.
                    suffix: Text('SUFFIX'),
                    // clearButtonMode: OverlayVisibilityMode.always,
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300.0,
                  child: MacosTextField(
                    enabled: false,
                    prefix: MacosIcon(CupertinoIcons.search),
                    placeholder: 'Disabled field',

                    /// If both suffix and clear button mode is provided,
                    /// suffix will override the clear button.
                    // suffix: Text('SUFFIX'),
                    clearButtonMode: OverlayVisibilityMode.always,
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300.0,
                  child: MacosSearchField(
                    placeholder: 'Search...',
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
