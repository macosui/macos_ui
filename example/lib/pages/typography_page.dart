import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = MacosTypography.of(context);
    final secondaryTypography = MacosTypography(
      color: MacosTheme.brightnessOf(context).isDark
          ? MacosColors.secondaryLabelColor.darkColor
          : MacosColors.secondaryLabelColor,
    );
    final tertiaryTypography = MacosTypography(
      color: MacosTheme.brightnessOf(context).isDark
          ? MacosColors.tertiaryLabelColor.darkColor
          : MacosColors.tertiaryLabelColor,
    );

    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('Typography'),
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Label Color'),
                          const SizedBox(height: 42.0),
                          Text('LargeTitle', style: typography.largeTitle),
                          const SizedBox(height: 8.0),
                          Text(
                            'LargeTitle',
                            style: typography.largeTitle
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 24.0),
                          Text('Title1', style: typography.title1),
                          const SizedBox(height: 8.0),
                          Text(
                            'Title1',
                            style: typography.title1
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 24.0),
                          Text('Title2', style: typography.title2),
                          const SizedBox(height: 8.0),
                          Text(
                            'Title2',
                            style: typography.title2
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 24.0),
                          Text('Title3', style: typography.title3),
                          const SizedBox(height: 8.0),
                          Text(
                            'Title3',
                            style: typography.title3
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 24.0),
                          Text('Headline', style: typography.headline),
                          const SizedBox(height: 8.0),
                          Text(
                            'Headline',
                            style: typography.headline
                                .copyWith(fontWeight: MacosFontWeight.w860),
                          ),
                          const SizedBox(height: 24.0),
                          Text('Body', style: typography.body),
                          const SizedBox(height: 8.0),
                          Text(
                            'Body',
                            style: typography.body
                                .copyWith(fontWeight: MacosFontWeight.w590),
                          ),
                          const SizedBox(height: 24.0),
                          Text('Callout', style: typography.callout),
                          const SizedBox(height: 8.0),
                          Text(
                            'Callout',
                            style: typography.callout
                                .copyWith(fontWeight: MacosFontWeight.w590),
                          ),
                          const SizedBox(height: 24.0),
                          Text('Subheadline', style: typography.subheadline),
                          const SizedBox(height: 8.0),
                          Text(
                            'Subheadline',
                            style: typography.subheadline
                                .copyWith(fontWeight: MacosFontWeight.w590),
                          ),
                          const SizedBox(height: 24.0),
                          Text('Footnote', style: typography.subheadline),
                          const SizedBox(height: 8.0),
                          Text(
                            'Footnote',
                            style: typography.subheadline
                                .copyWith(fontWeight: MacosFontWeight.w590),
                          ),
                          const SizedBox(height: 24.0),
                          Text('Caption1', style: typography.caption1),
                          const SizedBox(height: 8.0),
                          Text(
                            'Caption1',
                            style: typography.caption1
                                .copyWith(fontWeight: MacosFontWeight.w510),
                          ),
                          const SizedBox(height: 24.0),
                          Text('Caption2', style: typography.caption2),
                          const SizedBox(height: 8.0),
                          Text(
                            'Caption2',
                            style: typography.caption2
                                .copyWith(fontWeight: MacosFontWeight.w590),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Secondary Label Color'),
                          const SizedBox(height: 42.0),
                          Text(
                            'LargeTitle',
                            style: secondaryTypography.largeTitle,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'LargeTitle',
                            style: secondaryTypography.largeTitle
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Title1',
                            style: secondaryTypography.title1,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Title1',
                            style: secondaryTypography.title1
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Title2',
                            style: secondaryTypography.title2,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Title2',
                            style: secondaryTypography.title2
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Title3',
                            style: secondaryTypography.title3,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Title3',
                            style: secondaryTypography.title3
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Headline',
                            style: secondaryTypography.headline,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Headline',
                            style: secondaryTypography.headline
                                .copyWith(fontWeight: MacosFontWeight.w860),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Body',
                            style: secondaryTypography.body,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Body',
                            style: secondaryTypography.body
                                .copyWith(fontWeight: MacosFontWeight.w590),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Callout',
                            style: secondaryTypography.callout,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Callout',
                            style: secondaryTypography.callout
                                .copyWith(fontWeight: MacosFontWeight.w590),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Subheadline',
                            style: secondaryTypography.subheadline,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Subheadline',
                            style: secondaryTypography.subheadline
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Footnote',
                            style: secondaryTypography.footnote,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Footnote',
                            style: secondaryTypography.footnote
                                .copyWith(fontWeight: MacosFontWeight.w590),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Caption1',
                            style: secondaryTypography.caption1,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Caption1',
                            style: secondaryTypography.caption1
                                .copyWith(fontWeight: MacosFontWeight.w510),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Caption2',
                            style: secondaryTypography.caption2,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Caption2',
                            style: secondaryTypography.caption2
                                .copyWith(fontWeight: MacosFontWeight.w590),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tertiary Label Color'),
                          const SizedBox(height: 42.0),
                          Text(
                            'LargeTitle',
                            style: tertiaryTypography.largeTitle,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'LargeTitle',
                            style: tertiaryTypography.largeTitle
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Title1',
                            style: tertiaryTypography.title1,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Title1',
                            style: tertiaryTypography.title1
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Title2',
                            style: tertiaryTypography.title2,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Title2',
                            style: tertiaryTypography.title2
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Title3',
                            style: tertiaryTypography.title3,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Title3',
                            style: tertiaryTypography.title3
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Headline',
                            style: tertiaryTypography.headline,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Headline',
                            style: tertiaryTypography.headline
                                .copyWith(fontWeight: MacosFontWeight.w860),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Body',
                            style: tertiaryTypography.body,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Body',
                            style: tertiaryTypography.body
                                .copyWith(fontWeight: MacosFontWeight.w590),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Callout',
                            style: tertiaryTypography.callout,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Callout',
                            style: tertiaryTypography.callout
                                .copyWith(fontWeight: MacosFontWeight.w590),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Subheadline',
                            style: tertiaryTypography.subheadline,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Subheadline',
                            style: tertiaryTypography.subheadline
                                .copyWith(fontWeight: MacosFontWeight.w590),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Footnote',
                            style: tertiaryTypography.footnote,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Footnote',
                            style: tertiaryTypography.footnote
                                .copyWith(fontWeight: MacosFontWeight.w590),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Caption1',
                            style: tertiaryTypography.caption1,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Caption1',
                            style: tertiaryTypography.caption1
                                .copyWith(fontWeight: MacosFontWeight.w510),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Caption2',
                            style: tertiaryTypography.caption2,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Caption2',
                            style: tertiaryTypography.caption2
                                .copyWith(fontWeight: MacosFontWeight.w590),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
