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
        ContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Table(
                      // defaultColumnWidth: const FixedColumnWidth(150),
                      children: [
                        const TableRow(
                          children: [
                            Text('Light'),
                            Text('Dark'),
                            Text('Name'),
                          ],
                        ),
                        const TableRow(children: [
                          SizedBox(height: 16.0),
                          SizedBox(height: 16.0),
                          SizedBox(height: 16.0),
                        ]),
                        TableRow(
                          children: [
                            const ColorBox(color: MacosColors.systemRedColor),
                            ColorBox(
                              color: MacosColors.systemRedColor.darkColor,
                            ),
                            const Text('systemRed'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.systemOrangeColor,
                            ),
                            ColorBox(
                              color: MacosColors.systemOrangeColor.darkColor,
                            ),
                            const Text('systemOrange'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.systemYellowColor,
                            ),
                            ColorBox(
                              color: MacosColors.systemYellowColor.darkColor,
                            ),
                            const Text('systemYellow'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.systemGreenColor,
                            ),
                            ColorBox(
                              color: MacosColors.systemGreenColor.darkColor,
                            ),
                            const Text('systemGreen'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.systemMintColor,
                            ),
                            ColorBox(
                              color: MacosColors.systemMintColor.darkColor,
                            ),
                            const Text('systemMint'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.systemTealColor,
                            ),
                            ColorBox(
                              color: MacosColors.systemTealColor.darkColor,
                            ),
                            const Text('systemTeal'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.systemCyanColor,
                            ),
                            ColorBox(
                              color: MacosColors.systemCyanColor.darkColor,
                            ),
                            const Text('systemCyan'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.systemBlueColor,
                            ),
                            ColorBox(
                              color: MacosColors.systemBlueColor.darkColor,
                            ),
                            const Text('systemBlue'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.systemIndigoColor,
                            ),
                            ColorBox(
                              color: MacosColors.systemIndigoColor.darkColor,
                            ),
                            const Text('systemIndigo'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.systemPurpleColor,
                            ),
                            ColorBox(
                              color: MacosColors.systemPurpleColor.darkColor,
                            ),
                            const Text('systemPurple'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.systemPinkColor,
                            ),
                            ColorBox(
                              color: MacosColors.systemPinkColor.darkColor,
                            ),
                            const Text('systemPink'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.systemBrownColor,
                            ),
                            ColorBox(
                              color: MacosColors.systemBrownColor.darkColor,
                            ),
                            const Text('systemBrown'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.systemGrayColor,
                            ),
                            ColorBox(
                              color: MacosColors.systemGrayColor.darkColor,
                            ),
                            const Text('systemGray'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        const TableRow(
                          children: [
                            ColorBox(
                              color:
                                  MacosColors.alternateSelectedControlTextColor,
                            ),
                            SizedBox.shrink(),
                            Text('alternateSelectedControlTextColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color:
                                  MacosColors.alternatingContentBackgroundColor,
                            ),
                            ColorBox(
                              color: MacosColors
                                  .alternatingContentBackgroundColor.darkColor,
                            ),
                            const Text('alternatingContentBackgroundColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        const TableRow(
                          children: [
                            ColorBox(
                              color: MacosColors.controlAccentColor,
                            ),
                            SizedBox.shrink(),
                            Text('controlAccent'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.controlBackgroundColor,
                            ),
                            ColorBox(
                              color:
                                  MacosColors.controlBackgroundColor.darkColor,
                            ),
                            const Text('controlBackgroundColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.controlColor,
                            ),
                            ColorBox(
                              color: MacosColors.controlColor.darkColor,
                            ),
                            const Text('controlColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.controlTextColor,
                            ),
                            ColorBox(
                              color: MacosColors.controlTextColor.darkColor,
                            ),
                            const Text('controlTextColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.disabledControlTextColor,
                            ),
                            ColorBox(
                              color: MacosColors
                                  .disabledControlTextColor.darkColor,
                            ),
                            const Text('disabledControlTextColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        const TableRow(
                          children: [
                            ColorBox(
                              color: MacosColors.findHighlightColor,
                            ),
                            SizedBox.shrink(),
                            Text('findHighlightColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.gridColor,
                            ),
                            ColorBox(
                              color: MacosColors.gridColor.darkColor,
                            ),
                            const Text('gridColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.headerTextColor,
                            ),
                            ColorBox(
                              color: MacosColors.headerTextColor.darkColor,
                            ),
                            const Text('headerTextColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.keyboardFocusIndicatorColor,
                            ),
                            ColorBox(
                              color: MacosColors
                                  .keyboardFocusIndicatorColor.darkColor,
                            ),
                            const Text('keyboardFocusIndicatorColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.labelColor,
                            ),
                            ColorBox(
                              color: MacosColors.labelColor.darkColor,
                            ),
                            const Text('labelColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.linkColor,
                            ),
                            ColorBox(
                              color: MacosColors.linkColor.darkColor,
                            ),
                            const Text('linkColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.placeholderTextColor,
                            ),
                            ColorBox(
                              color: MacosColors.placeholderTextColor.darkColor,
                            ),
                            const Text('placeholderTextColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.quaternaryLabelColor,
                            ),
                            ColorBox(
                              color: MacosColors.quaternaryLabelColor.darkColor,
                            ),
                            const Text('quaternaryLabelColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.secondaryLabelColor,
                            ),
                            ColorBox(
                              color: MacosColors.secondaryLabelColor.darkColor,
                            ),
                            const Text('secondaryLabelColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.selectedContentBackgroundColor,
                            ),
                            ColorBox(
                              color: MacosColors
                                  .selectedContentBackgroundColor.darkColor,
                            ),
                            const Text('secondaryLabelColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.selectedControlColor,
                            ),
                            ColorBox(
                              color: MacosColors.selectedControlColor.darkColor,
                            ),
                            const Text('selectedControlColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.selectedControlTextColor,
                            ),
                            ColorBox(
                              color: MacosColors
                                  .selectedControlTextColor.darkColor,
                            ),
                            const Text('selectedControlTextColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        const TableRow(
                          children: [
                            ColorBox(
                              color: MacosColors.selectedMenuItemTextColor,
                            ),
                            SizedBox.shrink(),
                            Text('selectedMenuItemTextColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.selectedTextBackgroundColor,
                            ),
                            ColorBox(
                              color: MacosColors
                                  .selectedTextBackgroundColor.darkColor,
                            ),
                            const Text('selectedTextBackgroundColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.selectedTextColor,
                            ),
                            ColorBox(
                              color: MacosColors.selectedTextColor.darkColor,
                            ),
                            const Text('selectedTextColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.separatorColor,
                            ),
                            ColorBox(
                              color: MacosColors.separatorColor.darkColor,
                            ),
                            const Text('separatorColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.tertiaryLabelColor,
                            ),
                            ColorBox(
                              color: MacosColors.tertiaryLabelColor.darkColor,
                            ),
                            const Text('tertiaryLabelColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.textBackgroundColor,
                            ),
                            ColorBox(
                              color: MacosColors.textBackgroundColor.darkColor,
                            ),
                            const Text('textBackgroundColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.textColor,
                            ),
                            ColorBox(
                              color: MacosColors.textColor.darkColor,
                            ),
                            const Text('textColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.underPageBackgroundColor,
                            ),
                            ColorBox(
                              color: MacosColors
                                  .underPageBackgroundColor.darkColor,
                            ),
                            const Text('underPageBackgroundColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors
                                  .unemphasizedSelectedContentBackgroundColor,
                            ),
                            ColorBox(
                              color: MacosColors
                                  .unemphasizedSelectedContentBackgroundColor
                                  .darkColor,
                            ),
                            const Text(
                                'unemphasizedSelectedContentBackgroundColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors
                                  .unemphasizedSelectedTextBackgroundColor,
                            ),
                            ColorBox(
                              color: MacosColors
                                  .unemphasizedSelectedTextBackgroundColor
                                  .darkColor,
                            ),
                            const Text(
                                'unemphasizedSelectedTextBackgroundColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.unemphasizedSelectedTextColor,
                            ),
                            ColorBox(
                              color: MacosColors
                                  .unemphasizedSelectedTextColor.darkColor,
                            ),
                            const Text('unemphasizedSelectedTextColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.windowBackgroundColor,
                            ),
                            ColorBox(
                              color:
                                  MacosColors.windowBackgroundColor.darkColor,
                            ),
                            const Text('windowBackgroundColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            const ColorBox(
                              color: MacosColors.windowFrameTextColor,
                            ),
                            ColorBox(
                              color: MacosColors.windowFrameTextColor.darkColor,
                            ),
                            const Text('windowFrameTextColor'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        const TableRow(
                          children: [
                            ColorBox(
                              color: MacosColors.appleRed,
                            ),
                            SizedBox.shrink(),
                            Text('appleRed'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        const TableRow(
                          children: [
                            ColorBox(
                              color: MacosColors.appleOrange,
                            ),
                            SizedBox.shrink(),
                            Text('appleOrange'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        const TableRow(
                          children: [
                            ColorBox(
                              color: MacosColors.appleYellow,
                            ),
                            SizedBox.shrink(),
                            Text('appleYellow'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        const TableRow(
                          children: [
                            ColorBox(
                              color: MacosColors.appleGreen,
                            ),
                            SizedBox.shrink(),
                            Text('appleGreen'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        const TableRow(
                          children: [
                            ColorBox(
                              color: MacosColors.appleCyan,
                            ),
                            SizedBox.shrink(),
                            Text('appleCyan'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        const TableRow(
                          children: [
                            ColorBox(
                              color: MacosColors.appleBlue,
                            ),
                            SizedBox.shrink(),
                            Text('appleBlue'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        const TableRow(
                          children: [
                            ColorBox(
                              color: MacosColors.appleMagenta,
                            ),
                            SizedBox.shrink(),
                            Text('appleMagenta'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        const TableRow(
                          children: [
                            ColorBox(
                              color: MacosColors.applePurple,
                            ),
                            SizedBox.shrink(),
                            Text('applePurple'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        const TableRow(
                          children: [
                            ColorBox(
                              color: MacosColors.appleBrown,
                            ),
                            SizedBox.shrink(),
                            Text('appleBrown'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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
    return Stack(
      children: [
        SizedBox(
          height: 75,
          width: 75,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: ColoredBox(
              color: color,
            ),
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Text(
            'R ${color.red}\nG ${color.green}\nB ${color.blue}',
            style: TextStyle(
                color: color.computeLuminance() > 0.5
                    ? MacosColors.black
                    : MacosColors.white),
          ),
        ),
      ],
    );
  }
}
