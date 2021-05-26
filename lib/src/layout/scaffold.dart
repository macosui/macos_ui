import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/layout/content_area.dart';
import 'package:macos_ui/src/layout/resizable_pane.dart';
import 'package:macos_ui/src/layout/resizable_pane_notifier.dart';
import 'package:macos_ui/src/layout/sidebar.dart';
import 'package:macos_ui/src/layout/title_bar.dart';
import 'package:macos_ui/src/library.dart';

/// Defines the height of a regular-sized [TitleBar]
const kTitleBarHeight = 52.0;

/// Defines the height of a small-sized [TitleBar]
const kSmallTitleBarHeight = 30.0;

/// A basic screen-layout widget.
///
/// Provides a body for main content, via [children], and a [sidebar] for
/// secondary content (like navigation buttons). If no [sidebar] is specified,
/// only the [children] will be shown.
class MacosScaffold extends StatefulWidget {
  /// Creates a macOS window layout.
  ///
  /// The [children] can only include one [ContentArea], but can include
  /// multiple [ResizablePane] widgets.
  const MacosScaffold({
    Key? key,
    this.children = const <Widget>[],
    this.sidebar,
    this.titleBar,
    this.backgroundColor,
  }) : super(key: key);

  /// Specifies the background color for the Scaffold.
  ///
  /// The default colors from the theme would be used if no color is specified.
  final Color? backgroundColor;

  /// The children to display in the rest of the scaffold, excluding the
  /// [Sidebar] and [TitleBar] regions.
  final List<Widget> children;

  /// A sidebar to display at the left of the scaffold.
  final Sidebar? sidebar;

  /// An app bar to display at the top of the scaffold.
  final TitleBar? titleBar;

  @override
  _MacosScaffoldState createState() => _MacosScaffoldState();
}

class _MacosScaffoldState extends State<MacosScaffold> {
  final _sidebarScrollController = ScrollController();
  final _minContentAreaWidth = 300.0;
  ResizablePaneNotifier _valueNotifier = ResizablePaneNotifier({});
  double _sidebarWidth = 0.0;
  bool _showSidebar = true;
  SystemMouseCursor _sidebarCursor = SystemMouseCursors.resizeColumn;

  void _recalculateLayout() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _valueNotifier.reset();
      setState(() {
        if (widget.sidebar == null)
          _sidebarWidth = 0.0;
        else {
          if (widget.sidebar!.minWidth > _sidebarWidth ||
              widget.sidebar!.minWidth < _sidebarWidth)
            _sidebarWidth = widget.sidebar!.minWidth;
          if (widget.sidebar!.maxWidth! < _sidebarWidth)
            _sidebarWidth = widget.sidebar!.maxWidth!;
        }
      });
      _valueNotifier.notify();
    });
  }

  void toggleSidebar() {
    setState(() => _showSidebar = !_showSidebar);
    _recalculateLayout();
  }

  @override
  void initState() {
    super.initState();
    _sidebarWidth = (widget.sidebar?.startWidth ?? widget.sidebar?.minWidth) ??
        _sidebarWidth;
    if (widget.sidebar?.builder != null)
      _sidebarScrollController.addListener(() => setState(() {}));
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _valueNotifier.notify();
    });
  }

  @override
  void dispose() {
    _sidebarScrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MacosScaffold old) {
    super.didUpdateWidget(old);
    _recalculateLayout();
  }

  @override
  // ignore: code-metrics
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    assert(
      widget.children.every((e) => e is ContentArea || e is ResizablePane),
      'Scaffold children must either be ResizablePane or ContentArea',
    );
    assert(
      widget.children.whereType<ContentArea>().length <= 1,
      'Scaffold cannot have more than one ContentArea widget',
    );
    if (widget.sidebar?.startWidth != null) {
      assert((widget.sidebar!.startWidth! >= widget.sidebar!.minWidth) &&
          (widget.sidebar!.startWidth! <= widget.sidebar!.maxWidth!));
    }
    final MacosThemeData theme = MacosTheme.of(context);
    late Color backgroundColor = widget.backgroundColor ?? theme.canvasColor;
    late Color sidebarBackgroundColor;
    Color dividerColor = theme.dividerColor;

    if (!theme.brightness.isDark) {
      sidebarBackgroundColor = widget.sidebar?.decoration?.color ??
          CupertinoColors.systemGrey6.color;
    } else {
      sidebarBackgroundColor = widget.sidebar?.decoration?.color ??
          CupertinoColors.tertiarySystemBackground.darkColor;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final mediaQuery = MediaQuery.of(context);
        final children = widget.children;
        final titleBarHeight = widget.titleBar?.size == TitleBarSize.large
            ? kTitleBarHeight
            : kSmallTitleBarHeight;
        final isAtBreakpoint =
            width <= (widget.sidebar?.scaffoldBreakpoint ?? 0);
        final canShowSidebar = _showSidebar && !isAtBreakpoint;
        final visibleSidebarWidth = canShowSidebar ? _sidebarWidth : 0.0;

        final layout = Stack(
          children: [
            // Sidebar
            if (widget.sidebar != null && canShowSidebar)
              Positioned(
                height: height,
                width: _sidebarWidth,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  color: sidebarBackgroundColor,
                  child: Column(
                    children: [
                      SizedBox(height: titleBarHeight - 1),
                      if (_sidebarScrollController.hasClients &&
                          _sidebarScrollController.offset > 0.0)
                        Divider(thickness: 1, height: 1, color: dividerColor),
                      Expanded(
                        child: MacosScrollbar(
                          controller: _sidebarScrollController,
                          child: Padding(
                            padding: widget.sidebar?.padding ?? EdgeInsets.zero,
                            child: widget.sidebar!
                                .builder(context, _sidebarScrollController),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Background color
            Positioned.fill(
              left: visibleSidebarWidth,
              child: ColoredBox(color: backgroundColor),
            ),

            // Content Area
            Positioned(
              top: 0,
              left: visibleSidebarWidth,
              height: height,
              child: MediaQuery(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: children,
                ),
                data: mediaQuery.copyWith(
                  padding: widget.titleBar != null
                      ? EdgeInsets.only(top: titleBarHeight)
                      : null,
                ),
              ),
            ),

            // Title bar
            if (widget.titleBar != null)
              Positioned(
                height: titleBarHeight,
                left: visibleSidebarWidth,
                width: math.max(width - visibleSidebarWidth, 0),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: widget.titleBar?.decoration?.color?.alpha == 255
                        ? ImageFilter.blur()
                        : ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      alignment: widget.titleBar?.alignment ?? Alignment.center,
                      padding: widget.titleBar?.padding,
                      child: FittedBox(child: widget.titleBar?.child),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                      ).copyWith(
                        color: widget.titleBar?.decoration?.color,
                        image: widget.titleBar?.decoration?.image,
                        border: widget.titleBar?.decoration?.border ??
                            Border(bottom: BorderSide(color: dividerColor)),
                        borderRadius: widget.titleBar?.decoration?.borderRadius,
                        boxShadow: widget.titleBar?.decoration?.boxShadow,
                        gradient: widget.titleBar?.decoration?.gradient,
                      ),
                    ),
                  ),
                ),
              ),

            // Sidebar resizer
            if ((widget.sidebar?.isResizable ?? false) && canShowSidebar)
              Positioned(
                left: _sidebarWidth - 4,
                width: 7,
                height: height,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _sidebarWidth = math.max(
                        widget.sidebar!.minWidth,
                        math.min(
                          math.min(widget.sidebar!.maxWidth!, width),
                          _sidebarWidth + details.delta.dx,
                        ),
                      );
                      if (_sidebarWidth == widget.sidebar!.minWidth)
                        _sidebarCursor = SystemMouseCursors.resizeRight;
                      else if (_sidebarWidth == widget.sidebar!.maxWidth)
                        _sidebarCursor = SystemMouseCursors.resizeLeft;
                      else
                        _sidebarCursor = SystemMouseCursors.resizeColumn;
                    });
                  },
                  child: MouseRegion(
                    cursor: _sidebarCursor,
                    child: Align(
                      alignment: Alignment.center,
                      child: VerticalDivider(
                        thickness: 1,
                        width: 1,
                        color: dividerColor,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );

        return ValueListenableBuilder<Map<Key, double>>(
          child: layout,
          valueListenable: _valueNotifier,
          builder: (_, panes, child) {
            double sum = panes.values.fold(0.0, (prev, curr) => prev + curr);
            double _remainingWidth = width - (visibleSidebarWidth + sum);

            return ScaffoldScope(
              child: child!,
              scaffoldState: this,
              constraints: constraints,
              valueNotifier: _valueNotifier,
              contentAreaWidth: math.max(_minContentAreaWidth, _remainingWidth),
            );
          },
        );
      },
    );
  }
}

/// A [ScaffoldScope] serves as a scope for its descendants to rely on
/// values needed for the layout of the descendants.
///
/// It is embedded in the [MacosScaffold] and available to the widgets just below
/// it in the widget tree. The [ScaffoldScope] passes down the values which
/// are calculated inside [MacosScaffold] to its descendants.
///
/// Descendants of the [ScaffoldScope] automatically work with the values
/// they need, so you will hardly need to manually use the [ScaffoldScope].
class ScaffoldScope extends InheritedWidget {
  /// Creates a widget that manages the layout of the [MacosScaffold].
  ///
  /// [ResizablePane] and [ContentArea] are other widgets that depend
  /// on the [ScaffoldScope] for layout.
  ///
  /// The [constraints], [contentAreaWidth], [child], [valueNotifier]
  /// and [_scaffoldState] arguments are required and must not be null.
  const ScaffoldScope({
    Key? key,
    required this.constraints,
    required this.contentAreaWidth,
    required Widget child,
    required this.valueNotifier,
    required _MacosScaffoldState scaffoldState,
  })  : _scaffoldState = scaffoldState,
        super(key: key, child: child);

  /// Provides the constraints from the [MacosScaffold] to its descendants.
  final BoxConstraints constraints;

  /// The calculated width of the rest of the content area excluding
  /// [ResizablePane] and [Sidebar]. This sizes the width of [ContentArea]
  final double contentAreaWidth;

  /// Provides internal access to the [_MacosScaffoldState] for calling methods
  /// such as [toggleSidebar]
  final _MacosScaffoldState _scaffoldState;

  /// Retrieves the [ResizablePaneNotifier] inside [MacosScaffold].
  ///
  /// [ResizablePane] widgets in this scope register and unregister their
  /// widths and keys using this [valueNotifier]
  final ResizablePaneNotifier valueNotifier;

  /// Returns the [ScaffoldScope] of the [MacosScaffold] that most tightly encloses
  /// the given [context].
  ///
  /// If the [context] does not have a [MacosScaffold] as its ancestor, an assertion
  /// is thrown.
  ///
  /// The [context] argument must not be null.
  static ScaffoldScope of(BuildContext context) {
    final ScaffoldScope? result =
        context.dependOnInheritedWidgetOfExactType<ScaffoldScope>();
    assert(result != null, 'No ScaffoldScope found in context');
    return result!;
  }

  /// Returns a [ScaffoldScope] of the [MacosScaffold] that most tightly
  /// encloses the given [context]. The result can be null.
  ///
  /// If this [context] does not have a [MacosScaffold] as its ancestor, the result
  /// returned is null.
  ///
  /// The [context] argument must not be null.
  static ScaffoldScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ScaffoldScope>();
  }

  /// Toggles the [Sidebar] of the [MacosScaffold].
  ///
  /// This does not change the current width of the [Sidebar]. It only
  /// hides or shows it.
  void toggleSidebar() {
    return _scaffoldState.toggleSidebar();
  }

  @override
  bool updateShouldNotify(ScaffoldScope old) {
    return constraints != old.constraints ||
        contentAreaWidth != old.contentAreaWidth ||
        !mapEquals(valueNotifier.value, old.valueNotifier.value);
  }
}
