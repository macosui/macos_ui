import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class SliverToolbarPage extends StatefulWidget {
  const SliverToolbarPage({super.key, required this.isVisible});

  /// TODO: document this
  final bool isVisible;

  @override
  State<SliverToolbarPage> createState() => _SliverToolbarPageState();
}

class _SliverToolbarPageState extends State<SliverToolbarPage> {
  bool pinned = true;
  bool floating = false;
  double opacity = .9;

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return CustomScrollView(
              slivers: [
                SliverToolBar(
                  title: const Text('SliverToolbar'),
                  floating: floating,
                  pinned: pinned,
                  toolbarOpacity: opacity,
                  isVisible: widget.isVisible,
                  actions: [
                    ToolBarIconButton(
                      label: 'Pinned',
                      icon: MacosIcon(
                        pinned ? CupertinoIcons.pin_fill : CupertinoIcons.pin,
                      ),
                      tooltipMessage: pinned ? 'Unpin' : 'Pin',
                      showLabel: false,
                      onPressed: () {
                        setState(() => pinned = !pinned);
                      },
                    ),
                    ToolBarIconButton(
                      label: 'Floating',
                      icon: MacosImageIcon(
                        AssetImage(
                          floating
                              ? 'assets/sf_symbols/menubar.arrow.down.rectangle_2x.png'
                              : 'assets/sf_symbols/menubar.arrow.up.rectangle_2x.png',
                        ),
                      ),
                      tooltipMessage: floating ? 'Unfloat' : 'Float',
                      showLabel: false,
                      onPressed: () {
                        setState(() => floating = !floating);
                      },
                    ),
                    CustomToolbarItem(
                      inToolbarBuilder: (context) {
                        return MacosTooltip(
                          message: 'Toolbar opacity',
                          child: MacosPopupButton<double>(
                            value: opacity,
                            items: const [
                              MacosPopupMenuItem(
                                value: 0.25,
                                child: Text('25%'),
                              ),
                              MacosPopupMenuItem(
                                value: 0.5,
                                child: Text('50%'),
                              ),
                              MacosPopupMenuItem(
                                value: 0.75,
                                child: Text('75%'),
                              ),
                              MacosPopupMenuItem(
                                value: 0.9,
                                child: Text('90% (Default)'),
                              ),
                            ],
                            onChanged: (opacity) {
                              if (opacity == 0.25) {
                                setState(() => this.opacity = 0.25);
                              } else if (opacity == 0.5) {
                                setState(() => this.opacity = 0.5);
                              } else if (opacity == 0.75) {
                                setState(() => this.opacity = 0.75);
                              } else if (opacity == 0.9) {
                                setState(() => this.opacity = 0.9);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'SliverToolbar is nearly identical to the standard '
                      'Toolbar widget, except that it can be used in a '
                      'CustomScrollView. It can be pinned, floating, or '
                      'neither.',
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Row(
                        children: [
                          ...List<Widget>.generate(
                            3,
                            (index) => const FlutterLogo(size: 150),
                          )
                        ],
                      ),
                      ...List<Widget>.generate(
                        100,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Item ${index + 1}'),
                        ),
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
