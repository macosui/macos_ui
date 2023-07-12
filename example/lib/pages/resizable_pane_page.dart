import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

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
              child: Text('Left Resizable Pane'),
            );
          },
        ),
        ContentArea(
          builder: (_, __) {
            return Column(
              children: [
                const Flexible(
                  fit: FlexFit.loose,
                  child: Center(
                    child: Text('Content Area'),
                  ),
                ),
                ResizablePane(
                  minSize: 50,
                  startSize: 200,
                  //windowBreakpoint: 600,
                  builder: (_, __) {
                    return const Center(
                      child: Text('Bottom Resizable Pane'),
                    );
                  },
                  resizableSide: ResizableSide.top,
                ),
              ],
            );
          },
        ),
        const ResizablePane.noScrollBar(
          minSize: 180,
          startSize: 200,
          windowBreakpoint: 700,
          resizableSide: ResizableSide.right,
          child: Center(child: Text('Right non-scrollable Resizable Pane')),
        ),
      ],
    );
  }
}
