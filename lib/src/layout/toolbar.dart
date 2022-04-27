import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/layout/overflow_handler.dart';
import 'package:macos_ui/src/library.dart';

/// Defines the height of a regular-sized [ToolBar]
const _kToolbarHeight = 52.0;
const _kLeadingWidgetWidth = 20.0;
const _kTitleWidgetWidth = 200.0;

class ToolBar extends StatefulWidget {
  /// Creates a toolbar in the [MacosScaffold].
  ///
  /// The height of the ToolBar can be changed with [height].
  const ToolBar({
    Key? key,
    this.height = _kToolbarHeight,
    this.alignment = Alignment.center,
    this.title,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
    this.decoration,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.centerTitle = false,
  }) : super(key: key);

  /// Specifies the height of this [ToolBar]
  ///
  /// Defaults to [_kToolbarHeight] which is 52.0
  final double height;

  /// Align the [title] within the [ToolBar].
  ///
  /// Defaults to [Alignment.center].
  ///
  /// The [ToolBar] will expand to fill its parent and position its
  /// child within itself according to the given value.
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final Alignment alignment;

  /// The [title] contained by the container.
  final Widget? title;

  /// The decoration to paint behind the [title].
  final BoxDecoration? decoration;

  /// Empty space to inscribe inside the toolbar. The [title], if any, is
  /// placed inside this padding.
  ///
  /// Defaults to `EdgeInsets.all(8)`
  final EdgeInsets padding;

  /// A widget to display before the toolbar's [title].
  ///
  /// Typically the [leading] widget is an [Icon] or an [IconButton].
  final Widget? leading;

  /// Controls whether we should try to imply the leading widget if null.
  ///
  /// If true and [leading] is null, automatically try to deduce what the leading
  /// widget should be. If false and [leading] is null, leading space is given to [title].
  /// If leading widget is not null, this parameter has no effect.
  final bool automaticallyImplyLeading;

  /// A list of Widgets to display in a row after the [title] widget.
  final List<ToolbarItem>? actions;

  /// Whether the title should be centered.
  final bool centerTitle;

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  List<int> overflowedActionsIndexes = [];

  @override
  Widget build(BuildContext context) {
    final scope = MacosWindowScope.maybeOf(context);
    final MacosThemeData theme = MacosTheme.of(context);
    Color dividerColor = theme.dividerColor;
    final route = ModalRoute.of(context);
    double _overflowBreakpoint = 0.0;

    Widget? _leading = widget.leading;
    if (_leading == null && widget.automaticallyImplyLeading) {
      if (route?.canPop ?? false) {
        _leading = Container(
          width: 20,
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: MacosBackButton(
            fillColor: const Color(0x00000),
            onPressed: () => Navigator.maybePop(context),
          ),
        );
      }
    }
    if (widget.leading != null) {
      _overflowBreakpoint += _kLeadingWidgetWidth;
    }

    Widget? _title = widget.title;
    if (_title != null) {
      _title = SizedBox(
        width: 200.0,
        child: DefaultTextStyle(
          child: _title,
          style: MacosTheme.of(context).typography.headline.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.brightness.isDark
                    ? const Color(0xFFEAEAEA)
                    : const Color(0xFF4D4D4D),
              ),
        ),
      );
      _overflowBreakpoint += _kTitleWidgetWidth;
    }

    late List<ToolbarItem>? _inToolbarActions;
    late List<ToolbarItem> _overflowedActions;
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      _inToolbarActions = widget.actions!;
      _overflowedActions = overflowedActionsIndexes
          .map((index) => widget.actions![index])
          .toList();
    }

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        padding: EdgeInsets.only(
          left: !kIsWeb && isMacOS ? 70 : 0,
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: widget.decoration?.color?.opacity == 1
              ? ImageFilter.blur()
              : ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            alignment: widget.alignment,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: theme.canvasColor,
              border: Border(bottom: BorderSide(color: dividerColor)),
            ).copyWith(
              color: widget.decoration?.color,
              image: widget.decoration?.image,
              border: widget.decoration?.border,
              borderRadius: widget.decoration?.borderRadius,
              boxShadow: widget.decoration?.boxShadow,
              gradient: widget.decoration?.gradient,
            ),
            child: NavigationToolbar(
              middle: _title,
              centerMiddle: widget.centerTitle,
              trailing: OverflowHandler(
                overflowBreakpoint: _overflowBreakpoint,
                overflowWidget: ToolbarOverflowButton(
                  overflowContentBuilder: (context) => ToolbarOverflowMenu(
                    children: _overflowedActions
                        .map((action) => action.build(
                              context,
                              ToolbarItemDisplayMode.overflowed,
                            ))
                        .toList(),
                  ),
                ),
                children: (_inToolbarActions != null)
                    ? _inToolbarActions
                        .map((e) =>
                            e.build(context, ToolbarItemDisplayMode.inToolbar))
                        .toList()
                    : [],
                overflowChangedCallback: (hiddenItems) {
                  setState(() {
                    overflowedActionsIndexes = hiddenItems;
                  });
                },
              ),
              middleSpacing: 8,
              leading: SafeArea(
                top: false,
                right: false,
                bottom: false,
                left: !(scope?.isSidebarShown ?? false),
                child: _leading ?? const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum ToolbarItemDisplayMode {
  /// The item is displayed in the horizontal area (primary command area)
  /// of the command bar.
  ///
  /// The item should be rendered by wrapping content in a
  /// [CommandBarItemInPrimary] widget.
  inToolbar,

  /// The item is displayed within the secondary command area (within a
  /// Flyout as a drop down of the "more" button).
  ///
  /// Normally you would want to render an item in this visual context as a
  /// [TappableListTile].
  overflowed,
}

/// An individual control displayed within a [Toolbar]. Sub-class this
/// to build a new type of widget that appears inside of a command bar.
/// It knows how to build an appropriate widget for the given
/// [ToolbarItemDisplayMode] during build time.
abstract class ToolbarItem with Diagnosticable {
  const ToolbarItem({required this.key});

  final Key? key;

  /// Builds the final widget for this display mode for this item.
  /// Sub-classes implement this to build the widget that is appropriate
  /// for the given display mode.
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode);
}
