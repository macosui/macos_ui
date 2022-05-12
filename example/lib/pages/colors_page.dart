import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class ColorsPage extends StatefulWidget {
  const ColorsPage({super.key});

  @override
  State<ColorsPage> createState() => _ColorsPageState();
}

class _ColorsPageState extends State<ColorsPage> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Colors'),
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
            child: Column(
              children: [
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    const MacosTooltip(
                      message: 'System Red',
                      child: ColorBox(
                        color: MacosColors.systemRedColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'System Red Dark',
                      child: ColorBox(
                        color: MacosColors.systemRedColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'System Green',
                      child: ColorBox(
                        color: MacosColors.systemGreenColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'System Green Dark',
                      child: ColorBox(
                        color: MacosColors.systemGreenColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'System Blue',
                      child: ColorBox(
                        color: MacosColors.systemBlueColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'System Blue Dark',
                      child: ColorBox(
                        color: MacosColors.systemBlueColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'System Orange',
                      child: ColorBox(
                        color: MacosColors.systemOrangeColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'System Orange Dark',
                      child: ColorBox(
                        color: MacosColors.systemOrangeColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'System Yellow',
                      child: ColorBox(
                        color: MacosColors.systemYellowColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'System Yellow Dark',
                      child: ColorBox(
                        color: MacosColors.systemYellowColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'System Brown',
                      child: ColorBox(
                        color: MacosColors.systemBrownColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'System Brown Dark',
                      child: ColorBox(
                        color: MacosColors.systemBrownColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'System Pink',
                      child: ColorBox(
                        color: MacosColors.systemPinkColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'System Pink Dark',
                      child: ColorBox(
                        color: MacosColors.systemPinkColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'System Purple',
                      child: ColorBox(
                        color: MacosColors.systemPurpleColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'System Purple Dark',
                      child: ColorBox(
                        color: MacosColors.systemPurpleColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'System Teal',
                      child: ColorBox(
                        color: MacosColors.systemTealColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'System Teal Dark',
                      child: ColorBox(
                        color: MacosColors.systemTealColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'System Indigo',
                      child: ColorBox(
                        color: MacosColors.systemIndigoColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'System Indigo Dark',
                      child: ColorBox(
                        color: MacosColors.systemIndigoColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'System Gray',
                      child: ColorBox(
                        color: MacosColors.systemGrayColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'System Gray Dark',
                      child: ColorBox(
                        color: MacosColors.systemGrayColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'Link',
                      child: ColorBox(
                        color: MacosColors.linkColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'Link Dark',
                      child: ColorBox(
                        color: MacosColors.linkColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'Unemphasized Background',
                      child: ColorBox(
                        color:
                            MacosColors.unemphasizedSelectedTextBackgroundColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'Unemphasized Background Dark',
                      child: ColorBox(
                        color: MacosColors
                            .unemphasizedSelectedTextBackgroundColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'Control Background',
                      child: ColorBox(
                        color: MacosColors.controlBackgroundColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'Control Background Dark',
                      child: ColorBox(
                        color: MacosColors.controlBackgroundColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'Control',
                      child: ColorBox(
                        color: MacosColors.controlColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'Control Dark',
                      child: ColorBox(
                        color: MacosColors.controlColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'Control Text',
                      child: ColorBox(
                        color: MacosColors.controlTextColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'Control Text Dark',
                      child: ColorBox(
                        color: MacosColors.controlTextColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'Control Text Disabled',
                      child: ColorBox(
                        color: MacosColors.disabledControlTextColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'Control Text Disabled Dark',
                      child: ColorBox(
                        color: MacosColors.disabledControlTextColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'Selected Control',
                      child: ColorBox(
                        color: MacosColors.selectedControlColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'Selected Control Dark',
                      child: ColorBox(
                        color: MacosColors.selectedControlColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'Selected Control Text',
                      child: ColorBox(
                        color: MacosColors.selectedControlTextColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'Selected Control Text Dark',
                      child: ColorBox(
                        color: MacosColors.selectedControlTextColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'Keyboard Focus Indicator',
                      child: ColorBox(
                        color: MacosColors.keyboardFocusIndicatorColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'Keyboard Focus Indicator',
                      child: ColorBox(
                        color:
                            MacosColors.keyboardFocusIndicatorColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'Label',
                      child: ColorBox(
                        color: MacosColors.labelColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'Label Dark',
                      child: ColorBox(
                        color: MacosColors.labelColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'Secondary Label',
                      child: ColorBox(
                        color: MacosColors.secondaryLabelColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'Secondary Label Dark',
                      child: ColorBox(
                        color: MacosColors.secondaryLabelColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'Tertiary Label',
                      child: ColorBox(
                        color: MacosColors.tertiaryLabelColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'Tertiary Label Dark',
                      child: ColorBox(
                        color: MacosColors.tertiaryLabelColor.darkColor,
                      ),
                    ),
                    const MacosTooltip(
                      message: 'Quaternary Label',
                      child: ColorBox(
                        color: MacosColors.quaternaryLabelColor,
                      ),
                    ),
                    MacosTooltip(
                      message: 'Quaternary Label Dark',
                      child: ColorBox(
                        color: MacosColors.quaternaryLabelColor.darkColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class ColorBox extends StatelessWidget {
  const ColorBox({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: const SizedBox(
        height: 50,
        width: 50,
      ),
    );
  }
}
