import 'package:macos_ui/macos_ui.dart';
// ignore: implementation_imports
import 'package:macos_ui/src/library.dart';

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
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  PushButton(
                    buttonSize: ButtonSize.large,
                    child: const Text('Show Alert Dialog 1'),
                    onPressed: () => showMacosAlertDialog(
                      context: context,
                      builder: (context) => MacosAlertDialog(
                        appIcon: const FlutterLogo(
                          size: 56,
                        ),
                        title: const Text(
                          'Alert Dialog with Primary Action',
                        ),
                        message: const Text(
                          'This is an alert dialog with a primary action and no secondary action',
                        ),
                        //horizontalActions: false,
                        primaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          onPressed: Navigator.of(context).pop,
                          child: const Text('Primary'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PushButton(
                    buttonSize: ButtonSize.large,
                    child: const Text('Show Alert Dialog 2'),
                    onPressed: () => showMacosAlertDialog(
                      context: context,
                      builder: (context) => MacosAlertDialog(
                        appIcon: const FlutterLogo(
                          size: 56,
                        ),
                        title: const Text(
                          'Alert Dialog with Secondary Action',
                        ),
                        message: const Text(
                          'This is an alert dialog with primary action and secondary action laid out horizontally',
                          textAlign: TextAlign.center,
                        ),
                        //horizontalActions: false,
                        primaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          onPressed: Navigator.of(context).pop,
                          child: const Text('Primary'),
                        ),
                        secondaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          isSecondary: true,
                          onPressed: Navigator.of(context).pop,
                          child: const Text('Secondary'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PushButton(
                    buttonSize: ButtonSize.large,
                    child: const Text('Show Alert Dialog 3'),
                    onPressed: () => showMacosAlertDialog(
                      context: context,
                      builder: (context) => MacosAlertDialog(
                        appIcon: const FlutterLogo(
                          size: 56,
                        ),
                        title: const Text(
                          'Alert Dialog with Secondary Action',
                        ),
                        message: const Text(
                          'This is an alert dialog with primary action and secondary action laid out vertically',
                          textAlign: TextAlign.center,
                        ),
                        horizontalActions: false,
                        primaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          onPressed: Navigator.of(context).pop,
                          child: const Text('Primary'),
                        ),
                        secondaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          isSecondary: true,
                          onPressed: Navigator.of(context).pop,
                          child: const Text('Secondary'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PushButton(
                    buttonSize: ButtonSize.large,
                    child: const Text('Show Alert Dialog 4'),
                    onPressed: () => showMacosAlertDialog(
                      context: context,
                      builder: (context) => MacosAlertDialog(
                        appIcon: const FlutterLogo(
                          size: 56,
                        ),
                        title: const Text(
                          'Alert Dialog with Secondary Action',
                        ),
                        message: const Text(
                          'This is an alert dialog with primary action and secondary '
                          'action laid out vertically. It also contains a "suppress" option.',
                          textAlign: TextAlign.center,
                        ),
                        horizontalActions: false,
                        primaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          onPressed: Navigator.of(context).pop,
                          child: const Text('Primary'),
                        ),
                        secondaryButton: PushButton(
                          buttonSize: ButtonSize.large,
                          isSecondary: true,
                          onPressed: Navigator.of(context).pop,
                          child: const Text('Secondary'),
                        ),
                        suppress: const DoNotNotifyRow(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PushButton(
                    buttonSize: ButtonSize.large,
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
        }),
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
              buttonSize: ButtonSize.large,
              child: const Text('Get started'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
