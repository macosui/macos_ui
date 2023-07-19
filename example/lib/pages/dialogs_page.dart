import 'package:macos_ui/macos_ui.dart';
// ignore: implementation_imports
import 'package:macos_ui/src/library.dart';

const dialogMessage =
    'Description text about this alert is shown here, explaining to users what the options underneath are about and what to do.';

class DialogsPage extends StatefulWidget {
  const DialogsPage({super.key});

  @override
  State<DialogsPage> createState() => _DialogsPageState();
}

class _DialogsPageState extends State<DialogsPage> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Dialogs and Sheets'),
        titleWidth: 150.0,
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
        ContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    PushButton(
                      controlSize: ControlSize.regular,
                      child: const Text('Show Alert Dialog 1'),
                      onPressed: () => showMacosAlertDialog(
                        context: context,
                        builder: (context) => MacosAlertDialog(
                          appIcon: const FlutterLogo(size: 64),
                          title: const Text('Title'),
                          message: const Text(dialogMessage),
                          //horizontalActions: false,
                          primaryButton: PushButton(
                            controlSize: ControlSize.large,
                            onPressed: Navigator.of(context).pop,
                            child: const Text('Label'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    PushButton(
                      controlSize: ControlSize.regular,
                      child: const Text('Show Alert Dialog 2'),
                      onPressed: () => showMacosAlertDialog(
                        context: context,
                        builder: (context) => MacosAlertDialog(
                          appIcon: const FlutterLogo(size: 64),
                          title: const Text('Title'),
                          message: const Text(
                            dialogMessage,
                            textAlign: TextAlign.center,
                          ),
                          //horizontalActions: false,
                          primaryButton: PushButton(
                            controlSize: ControlSize.large,
                            onPressed: Navigator.of(context).pop,
                            child: const Text('Label'),
                          ),
                          secondaryButton: PushButton(
                            controlSize: ControlSize.large,
                            secondary: true,
                            onPressed: Navigator.of(context).pop,
                            child: const Text('Label'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    PushButton(
                      controlSize: ControlSize.regular,
                      child: const Text('Show Alert Dialog 3'),
                      onPressed: () => showMacosAlertDialog(
                        context: context,
                        builder: (context) => MacosAlertDialog(
                          appIcon: const FlutterLogo(size: 64),
                          title: const Text('Title'),
                          message: const Text(
                            dialogMessage,
                            textAlign: TextAlign.center,
                          ),
                          horizontalActions: false,
                          primaryButton: PushButton(
                            controlSize: ControlSize.large,
                            onPressed: Navigator.of(context).pop,
                            child: const Text('Label'),
                          ),
                          secondaryButton: PushButton(
                            controlSize: ControlSize.large,
                            secondary: true,
                            onPressed: Navigator.of(context).pop,
                            child: const Text('Label'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    PushButton(
                      controlSize: ControlSize.regular,
                      child: const Text('Show Alert Dialog 4'),
                      onPressed: () => showMacosAlertDialog(
                        context: context,
                        builder: (context) => MacosAlertDialog(
                          appIcon: const FlutterLogo(size: 64),
                          title: const Text('Title'),
                          message: const Text(
                            dialogMessage,
                            textAlign: TextAlign.center,
                          ),
                          horizontalActions: false,
                          primaryButton: PushButton(
                            controlSize: ControlSize.large,
                            onPressed: Navigator.of(context).pop,
                            child: const Text('Primary'),
                          ),
                          secondaryButton: PushButton(
                            controlSize: ControlSize.large,
                            secondary: true,
                            onPressed: Navigator.of(context).pop,
                            child: const Text('Secondary'),
                          ),
                          suppress: const DoNotNotifyRow(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    PushButton(
                      controlSize: ControlSize.regular,
                      child: const Text('Show sheet'),
                      onPressed: () {
                        showMacosSheet(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => const DemoSheet(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class DoNotNotifyRow extends StatefulWidget {
  const DoNotNotifyRow({super.key});

  @override
  State<DoNotNotifyRow> createState() => _DoNotNotifyRowState();
}

class _DoNotNotifyRowState extends State<DoNotNotifyRow> {
  bool suppress = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MacosCheckbox(
          value: suppress,
          onChanged: (value) {
            setState(() => suppress = value);
          },
        ),
        const SizedBox(width: 8),
        const Text('Don\'t ask again'),
      ],
    );
  }
}

class DemoSheet extends StatelessWidget {
  const DemoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosSheet(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const FlutterLogo(
                size: 56,
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to macos_ui',
                style: MacosTheme.of(context).typography.largeTitle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              const MacosListTile(
                leading: MacosIcon(CupertinoIcons.lightbulb),
                title: Text(
                  'A robust library of Flutter components for macOS',
                  //style: MacosTheme.of(context).typography.headline,
                ),
                subtitle: Text(
                  'Create native looking macOS applications using Flutter',
                ),
              ),
              const SizedBox(height: 16),
              const MacosListTile(
                leading: MacosIcon(CupertinoIcons.bolt),
                title: Text(
                  'Create beautiful macOS applications in minutes',
                  //style: MacosTheme.of(context).typography.headline,
                ),
              ),
              const Spacer(),
              PushButton(
                controlSize: ControlSize.regular,
                child: const Text('Get started'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
