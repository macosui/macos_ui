import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class ColorsPage extends StatefulWidget {
  ColorsPage({Key? key}) : super(key: key);

  @override
  _ColorsPageState createState() => _ColorsPageState();
}

class _ColorsPageState extends State<ColorsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: [
            MacosTooltip(
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
            MacosTooltip(
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
            MacosTooltip(
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
            MacosTooltip(
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
        const SizedBox(height: 16.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: [
            MacosTooltip(
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
            MacosTooltip(
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
            MacosTooltip(
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
            MacosTooltip(
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
            MacosTooltip(
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
            MacosTooltip(
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
            MacosTooltip(
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
            MacosTooltip(
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
            MacosTooltip(
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
            MacosTooltip(
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
            MacosTooltip(
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
          ],
        ),
      ],
    );
  }
}

class ColorBox extends StatelessWidget {
  const ColorBox({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: SizedBox(
        height: 50,
        width: 50,
      ),
    );
  }
}
