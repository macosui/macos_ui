import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/layout/toolbar/overflow_handler.dart';
import 'package:macos_ui/src/library.dart';

/// Defines the height of a regular-sized [ToolBar]
const _kToolbarHeight = 52.0;

/// Defines the width of the leading widget in the [ToolBar]
const _kLeadingWidth = 20.0;

/// Defines the width of the [ToolBar]'s title.
const _kTitleWidth = 150.0;

/// A toolbar to use in a [MacosScaffold].
class ToolBar extends StatefulWidget {
  /// Creates a toolbar in the [MacosScaffold]. The toolbar appears below the
  /// title bar (if present) of the macOS app or integrates with it.
  ///
  /// A toolbar provides convenient access to frequently used commands and
  /// features (toolbar items).
  ///
  /// Toolbar items include [ToolBarIconButton], [ToolBarPulldownButton], and
  /// [ToolBarSpacer] and [CustomToolbarItem] widgets, and should be provided
  /// via the [items] property.
  ///
  /// The action of every toolbar item should also be provided as a menu bar
  /// command of your app.
  ///
  /// The height of the ToolBar can be changed with [height].
  const ToolBar({
    Key? key,
    this.height = _kToolbarHeight,
    this.alignment = Alignment.center,
    this.title,
    this.titleWidth = _kTitleWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
    this.decoration,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.centerTitle = false,
    this.dividerColor,
  }) : super(key: key);

  /// Specifies the height of this [ToolBar].
  ///
  /// Defaults to [_kToolbarHeight] which is 52.0.
  final double height;

  /// Aligns the [title] within the [ToolBar].
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

  /// The [title] of the toolbar.
  ///
  /// Typically, a [Text] widget.
  final Widget? title;

  /// Specifies the width of the title of the [ToolBar].
  ///
  /// Defaults to [_kTitleWidth] which is 150.0.
  final double titleWidth;

  /// The decoration to paint behind the [title].
  final BoxDecoration? decoration;

  /// Empty space to inscribe inside the toolbar. The [title], if any, is
  /// placed inside this padding.
  ///
  /// Defaults to ` EdgeInsets.symmetric(horizontal: 8, vertical: 4.0)`.
  final EdgeInsets padding;

  /// A widget to display before the toolbar's [title].
  ///
  /// Typically the [leading] widget is a [MacosIcon] or a [MacosIconButton].
  final Widget? leading;

  /// Controls whether we should try to imply the leading widget if null.
  ///
  /// If `true` and [leading] is null, automatically try to deduce what the leading
  /// widget should be. If `false` and [leading] is null, leading space is given to [title].
  /// If leading widget is not null, this parameter has no effect.
  final bool automaticallyImplyLeading;

  /// A list of [ToolbarItem] widgets to display in a row after the [title] widget,
  /// as the toolbar actions.
  ///
  /// Toolbar items include [ToolBarIconButton], [ToolBarPulldownButton],
  /// [ToolBarSpacer], and [CustomToolbarItem] widgets.
  ///
  /// If the toolbar actions exceed the available toolbar width (e.g. when the
  /// window is resized), the overflowed actions are displayed via a
  /// [ToolbarOverflowMenu], that can be opened from the [ToolbarOverflowButton]
  /// at the right edge of the toolbar.
  final List<ToolbarItem>? actions;

  /// Whether the title should be centered.
  final bool centerTitle;

  /// The color of the divider below the toolbar.
  ///
  /// Defaults to MacosTheme.of(context).dividerColor.
  ///
  /// Set it to MacosColors.transparent to remove.
  final Color? dividerColor;

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  List<int> overflowedActionsIndexes = [];

  @override
  Widget build(BuildContext context) {
    final scope = MacosWindowScope.maybeOf(context);
    final MacosThemeData theme = MacosTheme.of(context);
    Color dividerColor = widget.dividerColor ?? theme.dividerColor;
    final route = ModalRoute.of(context);
    double _overflowBreakpoint = 0.0;

    Widget? _leading = widget.leading;
    if (_leading == null && widget.automaticallyImplyLeading) {
      if (route?.canPop ?? false) {
        _leading = Container(
          width: _kLeadingWidth,
          alignment: Alignment.centerLeft,
          child: MacosBackButton(
            fillColor: MacosColors.transparent,
            onPressed: () => Navigator.maybePop(context),
          ),
        );
      }
    }
    if (widget.leading != null) {
      _overflowBreakpoint += _kLeadingWidth;
    }

    Widget? _title = widget.title;
    if (_title != null) {
      _title = SizedBox(
        width: widget.titleWidth,
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
      _overflowBreakpoint += widget.titleWidth;
    }

    // Collect the toolbar action widgets that can be shown inside the ToolBar
    // and the ones that have overflowed.
    List<ToolbarItem>? _inToolbarActions = [];
    late List<ToolbarItem> _overflowedActions;
    bool doAllItemsShowLabel = true;
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      _inToolbarActions = widget.actions!;
      _overflowedActions = overflowedActionsIndexes
          .map((index) => widget.actions![index])
          .toList();
      // If all toolbar actions have labels shown below their icons,
      // reduce the overflow button's size as well.
      for (ToolbarItem item in widget.actions!) {
        if (item is ToolBarIconButton) {
          if (!item.showLabel) {
            doAllItemsShowLabel = false;
          }
        }
      }
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
                  isDense: doAllItemsShowLabel,
                  overflowContentBuilder: (context) => ToolbarOverflowMenu(
                    children: _overflowedActions
                        .map((action) => action.build(
                              context,
                              ToolbarItemDisplayMode.overflowed,
                            ))
                        .toList(),
                  ),
                ),
                children: _inToolbarActions
                    .map((e) =>
                        e.build(context, ToolbarItemDisplayMode.inToolbar))
                    .toList(),
                overflowChangedCallback: (hiddenItems) {
                  setState(() => overflowedActionsIndexes = hiddenItems);
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

/// Describes how [ToolbarItem]s can be displayed.
enum ToolbarItemDisplayMode {
  /// The item is displayed in the horizontal area of the toolbar.
  inToolbar,

  /// The item is displayed in the [ToolbarOverflowMenu] of the toolbar
  /// (via a drop down of the [ToolbarOverflowButton]).
  overflowed,
}

/// An individual action displayed within a [Toolbar]. Sub-class this
/// to build a new type of widget that appears inside of a toolbar.
/// It knows how to build an appropriate widget for the given
/// [ToolbarItemDisplayMode] during build time.
abstract class ToolbarItem with Diagnosticable {
  const ToolbarItem({required this.key});

  final Key? key;

  /// Builds the final widget for this display mode for this item.
  /// Sub-classes implement this to build the widget that is appropriate
  /// for the given display mode (in toolbar or overflowed).
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode);
}
