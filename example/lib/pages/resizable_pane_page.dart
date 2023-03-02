import 'package:macos_ui/macos_ui.dart';
import 'package:flutter/cupertino.dart';

class ResizablePanePage extends StatefulWidget {
  const ResizablePanePage({super.key});

  @override
  State<ResizablePanePage> createState() => _ResizablePanePageState();
}

class _ResizablePanePageState extends State<ResizablePanePage> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Resizable Pane'),
        leading: MacosTooltip(
          message: 'Toggle Sidebar',
          useMousePosition: false,
          child: MacosIconButton(
            icon: MacosIcon(
              CupertinoIcons.sidebar_left,
              color: MacosTheme.brightnessOf(context).resolve(
                const Color.fromRGBO(0, 0, 0, 0.5),
                const Color.fromRGBO(255, 255, 255, 0.5),
              ),
              size: 20.0,
            ),
            boxConstraints: const BoxConstraints(
              minHeight: 20,
              minWidth: 20,
              maxWidth: 48,
              maxHeight: 38,
            ),
            onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
          ),
        ),
      ),
      children: [
        ResizablePane(
          minSize: 180,
          startSize: 200,
          windowBreakpoint: 700,
          resizableSide: ResizableSide.right,
          builder: (_, __) {
            return const Center(
              child: Text('ResizableSide.right'),
            );
          },
        ),
        ContentArea(builder: (context, scrollController) {
          return Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return MacosListTile(title: Text('Item $index'));
                  },
                ),
              ),
              ResizablePane(
                minSize: 50,
                startSize: 200,
                //windowBreakpoint: 600,
                builder: (_, __) {
                  return const Center(
                    child: Text('ResizableSize.top'),
                  );
                },
                resizableSide: ResizableSide.top,
              )
            ],
          );
        }),
        ResizablePane(
          minSize: 180,
          startSize: 200,
          windowBreakpoint: 800,
          resizableSide: ResizableSide.left,
          builder: (_, __) {
            return const Center(
              child: Text('ResizableSide.left'),
            );
          },
        ),
      ],
    );
  }
}
