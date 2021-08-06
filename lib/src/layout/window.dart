import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/src/indicators/scrollbar.dart';
import 'package:macos_ui/src/layout/content_area.dart';
import 'package:macos_ui/src/layout/resizable_pane.dart';
import 'package:macos_ui/src/layout/sidebar.dart';
import 'package:macos_ui/src/layout/scaffold.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/macos_theme.dart';

/// A basic frame layout.
///
/// Provides a body for main content, via [child], and a [sidebar] for
/// secondary content (like navigation buttons). If no [sidebar] is specified,
/// only the [child] will be shown.
class MacosWindow extends StatefulWidget {
  /// Creates a macOS window layout with a sidebar on the left.
  ///
  /// The [child] widget is typically a [MacosScaffold] which fills the
  /// rest of the screen.
  const MacosWindow({
    Key? key,
    this.child,
    this.sidebar,
    this.backgroundColor,
  }) : super(key: key);

  /// Specifies the background color for the Window.
  ///
  /// The default colors from the theme would be used if no color is specified.
  final Color? backgroundColor;

  /// The child of the [MacosWindow]
  final Widget? child;

  /// A sidebar to display at the left of the scaffold.
  final Sidebar? sidebar;

  @override
  _MacosWindowState createState() => _MacosWindowState();
}

class _MacosWindowState extends State<MacosWindow> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _sidebarScrollController = ScrollController();
  double _sidebarWidth = 0.0;
  bool _showSidebar = true;
  SystemMouseCursor _sidebarCursor = SystemMouseCursors.resizeColumn;

  void _recalculateLayout() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
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
    });
  }

  @override
  void initState() {
    super.initState();
    _sidebarWidth = (widget.sidebar?.startWidth ?? widget.sidebar?.minWidth) ??
        _sidebarWidth;
    if (widget.sidebar?.builder != null)
      _sidebarScrollController.addListener(() => setState(() {}));
    _recalculateLayout();
  }

  @override
  void dispose() {
    _sidebarScrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MacosWindow old) {
    super.didUpdateWidget(old);
    _recalculateLayout();
  }

  @override
  // ignore: code-metrics
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
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
                      SizedBox(height: 51),
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
                      if (widget.sidebar?.bottom != null)
                        widget.sidebar!.bottom!,
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
              width: width - visibleSidebarWidth,
              height: height,
              child: ClipRect(
                child: CupertinoTabView(
                  navigatorKey: _navigatorKey,
                  onGenerateRoute: (_) {
                    return CupertinoPageRoute(
                      builder: (_) => Builder(
                        builder: (_) => widget.child ?? SizedBox.shrink(),
                      ),
                    );
                  },
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

        return MacosWindowScope(
          child: layout,
          constraints: constraints,
          isSidebarShown: canShowSidebar,
          sidebarToggler: () {
            setState(() => _showSidebar = !_showSidebar);
          },
        );
      },
    );
  }
}

/// A [MacosWindowScope] serves as a scope for its descendants to rely on
/// values needed for the layout of the descendants.
///
/// It is embedded in the [MacosWindow] and available to the widgets just below
/// it in the widget tree. The [MacosWindowScope] passes down the values which
/// are calculated inside [MacosWindow] to its descendants.
///
/// Descendants of the [MacosWindowScope] automatically work with the values
/// they need, so you will hardly need to manually use the [MacosWindowScope].
class MacosWindowScope extends InheritedWidget {
  /// Creates a widget that manages the layout of the [MacosWindow].
  ///
  /// [ResizablePane] and [ContentArea] are other widgets that depend
  /// on the [MacosWindowScope] for layout.
  ///
  /// The [constraints], [contentAreaWidth], [child], [valueNotifier]
  /// and [_scaffoldState] arguments are required and must not be null.
  const MacosWindowScope({
    Key? key,
    required this.constraints,
    required Widget child,
    required this.isSidebarShown,
    required VoidCallback sidebarToggler,
  })  : _sidebarToggler = sidebarToggler,
        super(key: key, child: child);

  /// Provides the constraints from the [MacosWindow] to its descendants.
  final BoxConstraints constraints;

  /// Provides a callback which will be used to privately toggle the sidebar.
  final Function _sidebarToggler;

  /// Returns the [MacosWindowScope] of the [MacosWindow] that most tightly encloses
  /// the given [context].
  ///
  /// If the [context] does not have a [MacosWindow] as its ancestor, an assertion
  /// is thrown.
  ///
  /// The [context] argument must not be null.
  static MacosWindowScope of(BuildContext context) {
    final MacosWindowScope? result =
        context.dependOnInheritedWidgetOfExactType<MacosWindowScope>();
    assert(result != null, 'No ScaffoldScope found in context');
    return result!;
  }

  /// Returns a [MacosWindowScope] of the [MacosWindow] that most tightly
  /// encloses the given [context]. The result can be null.
  ///
  /// If this [context] does not have a [MacosWindow] as its ancestor, the result
  /// returned is null.
  ///
  /// The [context] argument must not be null.
  static MacosWindowScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MacosWindowScope>();
  }

  /// Provides the current visible state of the [Sidebar].
  final bool isSidebarShown;

  /// Toggles the [Sidebar] of the [MacosWindow].
  ///
  /// This does not change the current width of the [Sidebar]. It only
  /// hides or shows it.
  void toggleSidebar() {
    return _sidebarToggler();
  }

  @override
  bool updateShouldNotify(MacosWindowScope old) {
    return constraints != old.constraints ||
        isSidebarShown != old.isSidebarShown;
  }
}
