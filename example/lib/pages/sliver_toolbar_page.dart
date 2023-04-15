import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class SliverToolbarPage extends StatefulWidget {
  const SliverToolbarPage({super.key, required this.isVisible});

  /// Whether this [SliverToolbarPage] is currently visible on the screen
  /// (that is, not e.g. hidden by an [IndexedStack]).
  ///
  /// By default, macos_ui applies wallpaper tinting to the application's
  /// window to match macOS' native appearance:
  ///
  /// <img src="https://user-images.githubusercontent.com/86920182/220182724-d78319d7-5c41-4e8c-b785-a73a6ea24927.jpg" width=640/>
  ///
  /// However, this effect is realized by inserting `NSVisualEffectView`s behind
  /// Flutter's canvas and turning the background of areas that are meant to be
  /// affected by wallpaper tinting transparent. Since Flutter's
  /// [`ImageFilter.blur`](https://api.flutter.dev/flutter/dart-ui/ImageFilter/ImageFilter.blur.html)
  /// does not support transparency, wallpaper tinting is disabled automatically
  /// when this widget's [isVisible] is true.
  ///
  /// This is meant to be a temporary solution until
  /// [#16296](https://github.com/flutter/flutter/issues/16296) is resolved in
  /// the Flutter project.
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
                  allowWallpaperTintingOverrides: widget.isVisible,
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
