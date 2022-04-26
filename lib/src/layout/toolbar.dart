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
  final List<Widget>? actions;

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
    List<Widget> _allToolbarActions = [];
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
      _allToolbarActions.add(widget.leading!);
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
      _allToolbarActions.add(_title);
      _overflowBreakpoint += _kTitleWidgetWidth;
    }

    Widget? _actions;
    late List<Widget> _overflowedActions;
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      _actions = Wrap(
        children: widget.actions!,
      );
      _allToolbarActions.add(_actions);
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
                  overflowContentBuilder: (context) =>
                      Text(_overflowedActions.toString()),
                ),
                children: widget.actions!,
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
