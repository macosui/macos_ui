import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// {@template macosSegmentedControl}
/// Displays one or more navigational tabs in a single horizontal group.
///
/// Used by [MacosTabView] to navigate between the different tabs of the tab bar.
///
/// [MacosSegmentedControl] can be considered somewhat analogous to Flutter's
/// material `TabBar` in that it requires a list of [tabs]. Unlike `TabBar`,
/// however, [MacosSegmentedControl] explicitly requires a [controller].
///
/// See also:
/// * [MacosTab], which is a navigational item in a [MacosSegmentedControl].
/// * [MacosTabView], which is a multi-page navigational view.
/// {@endtemplate}
class MacosSegmentedControl extends StatefulWidget {
  /// {@macro macosSegmentedControl}
  ///
  /// [tabs] and [controller] must not be null. [tabs] must contain at least one
  /// tab.
  const MacosSegmentedControl({
    super.key,
    required this.tabs,
    required this.controller,
  }) : assert(tabs.length > 0);

  /// The navigational items of this [MacosSegmentedControl].
  final List<MacosTab> tabs;

  /// The [MacosTabController] that manages the [tabs] in this
  /// [MacosSegmentedControl].
  final MacosTabController controller;

  @override
  State<MacosSegmentedControl> createState() => _MacosSegmentedControlState();
}

class _MacosSegmentedControlState extends State<MacosSegmentedControl> {
  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        // Background color
        color: brightness.resolve(
          const Color(0xFFE2E3E6),
          const Color(0xFF2B2E33),
        ),
        boxShadow: [
          BoxShadow(
            color: brightness.resolve(
              const Color(0xFFDBDCDE),
              const Color(0xFF4F5155),
            ),
            offset: const Offset(0, 0.5),
            spreadRadius: 0.5,
          ),
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.5),
        child: IntrinsicHeight(
          child: IntrinsicWidth(
            child: Row(
              children: widget.tabs.map((t) {
                final row = Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.controller.index = widget.tabs.indexOf(t);
                        });
                      },
                      child: t.copyWith(
                        active:
                            widget.controller.index == widget.tabs.indexOf(t),
                      ),
                    ),
                  ],
                );
                bool showDividerColor = true;
                final last = widget.tabs.indexOf(t) == widget.tabs.length - 1;
                if ((widget.controller.index - 1 == widget.tabs.indexOf(t)) ||
                    (widget.controller.index + 1 ==
                        widget.tabs.indexOf(t) + 1) ||
                    last) {
                  showDividerColor = false;
                }

                if (!last) {
                  row.children.add(
                    VerticalDivider(
                      color: showDividerColor
                          ? brightness.resolve(
                              const Color(0xFFC9C9C9),
                              const Color(0xFF26222C),
                            )
                          : MacosColors.transparent,
                      width: 2.0,
                      indent: 5.0,
                      endIndent: 5.0,
                    ),
                  );
                }

                return row;
              }).toList(growable: false),
            ),
          ),
        ),
      ),
    );
  }
}
