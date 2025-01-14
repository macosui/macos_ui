import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macos_ui/macos_ui.dart';

class WidgetTextTitle1 extends StatelessWidget {
  const WidgetTextTitle1({super.key, required this.widgetName});

  final String widgetName;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: MacosColors.systemGrayColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6.0,
        ),
        child: Text(
          widgetName,
          style: MacosTypography.of(context)
              .title1
              .copyWith(fontFamily: GoogleFonts.jetBrainsMono().fontFamily),
        ),
      ),
    );
  }
}
