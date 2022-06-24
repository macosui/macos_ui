import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/src/indicators/scrollbar.dart';
import 'package:macos_ui/src/layout/content_area.dart';
import 'package:macos_ui/src/layout/resizable_pane.dart';
import 'package:macos_ui/src/layout/scaffold.dart';
import 'package:macos_ui/src/layout/sidebar/sidebar.dart';
import 'package:macos_ui/src/layout/title_bar.dart';
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
    super.key,
    this.child,
    this.titleBar,
    this.sidebar,
    this.backgroundColor,
    this.endSidebar,
  });

  /// Specifies the background color for the Window.
  ///
  /// The default colors from the theme would be used if no color is specified.
  final Color? backgroundColor;

  /// The child of the [MacosWindow]
  final Widget? child;

  /// An app bar to display at the top of the window.
  final TitleBar? titleBar;

  /// A sidebar to display at the left of the window.
  final Sidebar? sidebar;

  /// A sidebar to display at the right of the window.
  final Sidebar? endSidebar;

  @override
  State<MacosWindow> createState() => _MacosWindowState();
}

class _MacosWindowState extends State<MacosWindow> {
  final _sidebarScrollController = ScrollController();
  final _endSidebarScrollController = ScrollController();
  double _sidebarWidth = 0.0;
  double _sidebarDragStartWidth = 0.0;
  double _sidebarDragStartPosition = 0.0;
  double _endSidebarWidth = 0.0;
  double _endSidebarDragStartWidth = 0.0;
  double _endSidebarDragStartPosition = 0.0;
  bool _showSidebar = true;
  late bool _showEndSidebar = widget.endSidebar?.shownByDefault ?? false;
  int _sidebarSlideDuration = 0;
  SystemMouseCursor _sidebarCursor = SystemMouseCursors.resizeColumn;
  SystemMouseCursor _endSidebarCursor = SystemMouseCursors.resizeLeft;

  @override
  void initState() {
    super.initState();
    _sidebarWidth = (widget.sidebar?.startWidth ?? widget.sidebar?.minWidth) ??
        _sidebarWidth;
    _endSidebarWidth =
        (widget.endSidebar?.startWidth ?? widget.endSidebar?.minWidth) ??
            _endSidebarWidth;
    if (widget.sidebar?.builder != null) {
      _sidebarScrollController.addListener(() => setState(() {}));
    }
    if (widget.endSidebar?.builder != null) {
      _endSidebarScrollController.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _sidebarScrollController.dispose();
    _endSidebarScrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MacosWindow old) {
    super.didUpdateWidget(old);
    setState(() {
      if (widget.sidebar == null) {
        _sidebarWidth = 0.0;
      } else if (widget.sidebar!.minWidth != old.sidebar!.minWidth ||
          widget.sidebar!.maxWidth != old.sidebar!.maxWidth) {
        if (widget.sidebar!.minWidth > _sidebarWidth) {
          _sidebarWidth = widget.sidebar!.minWidth;
        }
        if (widget.sidebar!.maxWidth! < _sidebarWidth) {
          _sidebarWidth = widget.sidebar!.maxWidth!;
        }
      }
      if (widget.endSidebar == null) {
        _endSidebarWidth = 0.0;
      } else if (widget.endSidebar!.minWidth != old.endSidebar!.minWidth ||
          widget.endSidebar!.maxWidth != old.endSidebar!.maxWidth) {
        if (widget.endSidebar!.minWidth > _endSidebarWidth) {
          _endSidebarWidth = widget.endSidebar!.minWidth;
        }
        if (widget.endSidebar!.maxWidth! < _endSidebarWidth) {
          _endSidebarWidth = widget.endSidebar!.maxWidth!;
        }
      }
    });
  }

  @override
  // ignore: code-metrics
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    if (widget.sidebar?.startWidth != null) {
      assert((widget.sidebar!.startWidth! >= widget.sidebar!.minWidth) &&
          (widget.sidebar!.startWidth! <= widget.sidebar!.maxWidth!));
    }
    if (widget.endSidebar?.startWidth != null) {
      assert((widget.endSidebar!.startWidth! >= widget.endSidebar!.minWidth) &&
          (widget.endSidebar!.startWidth! <= widget.endSidebar!.maxWidth!));
    }
    final MacosThemeData theme = MacosTheme.of(context);
    late Color backgroundColor = widget.backgroundColor ?? theme.canvasColor;
    late Color sidebarBackgroundColor;
    late Color endSidebarBackgroundColor;
    Color dividerColor = theme.dividerColor;

    final isMac = !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

    // Respect the sidebar color override from parent if one is given
    if (widget.sidebar?.decoration?.color != null) {
      sidebarBackgroundColor = widget.sidebar!.decoration!.color!;
    } else if (isMac &&
        MediaQuery.of(context).platformBrightness.isDark ==
            theme.brightness.isDark) {
      // Only show blurry, transparent sidebar when platform brightness and app
      // brightness are the same, otherwise it looks awful. Also only make the
      // sidebar transparent on native Mac, or it will just be flat black or
      // white.
      sidebarBackgroundColor = Colors.transparent;
    } else {
      sidebarBackgroundColor = theme.brightness.isDark
          ? CupertinoColors.tertiarySystemBackground.darkColor
          : CupertinoColors.systemGrey6.color;
    }

    // Respect the end sidebar color override from parent if one is given
    if (widget.endSidebar?.decoration?.color != null) {
      endSidebarBackgroundColor = widget.endSidebar!.decoration!.color!;
    } else if (isMac &&
        MediaQuery.of(context).platformBrightness.isDark ==
            theme.brightness.isDark) {
      endSidebarBackgroundColor = theme.canvasColor;
    } else {
      endSidebarBackgroundColor = theme.brightness.isDark
          ? CupertinoColors.tertiarySystemBackground.darkColor
          : CupertinoColors.systemGrey6.color;
    }

    const curve = Curves.linearToEaseOut;
    final duration = Duration(milliseconds: _sidebarSlideDuration);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final isAtBreakpoint = width <= (widget.sidebar?.windowBreakpoint ?? 0);
        final canShowSidebar = _showSidebar && !isAtBreakpoint;
        final canShowEndSidebar = _showEndSidebar && !isAtBreakpoint;
        final visibleSidebarWidth = canShowSidebar ? _sidebarWidth : 0.0;
        final visibleEndSidebarWidth =
            canShowEndSidebar ? _endSidebarWidth : 0.0;

        final layout = Stack(
          children: [
            // Background color
            AnimatedPositioned(
              curve: curve,
              duration: duration,
              height: height,
              left: visibleSidebarWidth,
              width: width,
              child: ColoredBox(color: backgroundColor),
            ),

            // Sidebar
            if (widget.sidebar != null)
              AnimatedPositioned(
                curve: curve,
                duration: duration,
                height: height,
                width: _sidebarWidth,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  color: sidebarBackgroundColor,
                  constraints: BoxConstraints(
                    minWidth: widget.sidebar!.minWidth,
                    maxWidth: widget.sidebar!.maxWidth!,
                    minHeight: height,
                    maxHeight: height,
                  ).normalize(),
                  child: Column(
                    children: [
                      if ((widget.sidebar?.topOffset ?? 0) > 0)
                        SizedBox(height: widget.sidebar?.topOffset),
                      if (_sidebarScrollController.hasClients &&
                          _sidebarScrollController.offset > 0.0)
                        Divider(thickness: 1, height: 1, color: dividerColor),
                      if (widget.sidebar!.top != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: widget.sidebar!.top!,
                        ),
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
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: widget.sidebar!.bottom!,
                        ),
                    ],
                  ),
                ),
              ),

            // Content Area
            AnimatedPositioned(
              curve: curve,
              duration: duration,
              left: visibleSidebarWidth,
              width: width - visibleSidebarWidth - visibleEndSidebarWidth,
              height: height,
              child: ClipRect(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: widget.titleBar != null ? widget.titleBar!.height : 0,
                  ),
                  child: widget.child ?? const SizedBox.shrink(),
                ),
              ),
            ),

            // Title bar Area
            Positioned(
              left: visibleSidebarWidth,
              width: width - visibleSidebarWidth,
              height: widget.titleBar?.height,
              child: ClipRect(
                child: widget.titleBar ?? const SizedBox.shrink(),
              ),
            ),

            // Sidebar resizer
            if (widget.sidebar?.isResizable ?? false)
              AnimatedPositioned(
                curve: curve,
                duration: duration,
                left: visibleSidebarWidth - 4,
                width: 7,
                height: height,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragStart: (details) {
                    _sidebarDragStartWidth = _sidebarWidth;
                    _sidebarDragStartPosition = details.globalPosition.dx;
                  },
                  onHorizontalDragUpdate: (details) {
                    final sidebar = widget.sidebar!;
                    setState(() {
                      var newWidth = _sidebarDragStartWidth +
                          details.globalPosition.dx -
                          _sidebarDragStartPosition;

                      if (sidebar.startWidth != null &&
                          sidebar.snapToStartBuffer != null &&
                          (newWidth - sidebar.startWidth!).abs() <=
                              sidebar.snapToStartBuffer!) {
                        newWidth = sidebar.startWidth!;
                      }

                      if (sidebar.dragClosed) {
                        final closeBelow =
                            sidebar.minWidth - sidebar.dragClosedBuffer;
                        _showSidebar = newWidth >= closeBelow;
                      }

                      _sidebarWidth = math.max(
                        sidebar.minWidth,
                        math.min(
                          sidebar.maxWidth!,
                          newWidth,
                        ),
                      );

                      if (_sidebarWidth == sidebar.minWidth) {
                        _sidebarCursor = SystemMouseCursors.resizeRight;
                      } else if (_sidebarWidth == sidebar.maxWidth) {
                        _sidebarCursor = SystemMouseCursors.resizeLeft;
                      } else {
                        _sidebarCursor = SystemMouseCursors.resizeColumn;
                      }
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

            // End sidebar
            if (widget.endSidebar != null)
              AnimatedPositioned(
                left: width - visibleEndSidebarWidth,
                curve: curve,
                duration: duration,
                height: height,
                width: _endSidebarWidth,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  color: endSidebarBackgroundColor,
                  constraints: BoxConstraints(
                    minWidth: widget.endSidebar!.minWidth,
                    maxWidth: widget.endSidebar!.maxWidth!,
                    minHeight: height,
                    maxHeight: height,
                  ).normalize(),
                  child: Column(
                    children: [
                      if ((widget.endSidebar?.topOffset ?? 0) > 0)
                        SizedBox(height: widget.endSidebar?.topOffset),
                      if (_endSidebarScrollController.hasClients &&
                          _endSidebarScrollController.offset > 0.0)
                        Divider(thickness: 1, height: 1, color: dividerColor),
                      if (widget.endSidebar!.top != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: widget.endSidebar!.top!,
                        ),
                      Expanded(
                        child: MacosScrollbar(
                          controller: _endSidebarScrollController,
                          child: Padding(
                            padding:
                                widget.endSidebar?.padding ?? EdgeInsets.zero,
                            child: widget.endSidebar!
                                .builder(context, _endSidebarScrollController),
                          ),
                        ),
                      ),
                      if (widget.endSidebar?.bottom != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: widget.endSidebar!.bottom!,
                        ),
                    ],
                  ),
                ),
              ),

            // End sidebar resizer
            if (widget.endSidebar?.isResizable ?? false)
              AnimatedPositioned(
                curve: curve,
                duration: duration,
                right: visibleEndSidebarWidth - 4,
                width: 7,
                height: height,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragStart: (details) {
                    _endSidebarDragStartWidth = _endSidebarWidth;
                    _endSidebarDragStartPosition = details.globalPosition.dx;
                  },
                  onHorizontalDragUpdate: (details) {
                    final endSidebar = widget.endSidebar!;
                    setState(() {
                      var newWidth = _endSidebarDragStartWidth -
                          details.globalPosition.dx +
                          _endSidebarDragStartPosition;

                      if (endSidebar.startWidth != null &&
                          endSidebar.snapToStartBuffer != null &&
                          (newWidth + endSidebar.startWidth!).abs() <=
                              endSidebar.snapToStartBuffer!) {
                        newWidth = endSidebar.startWidth!;
                      }

                      if (endSidebar.dragClosed) {
                        final closeBelow =
                            endSidebar.minWidth - endSidebar.dragClosedBuffer;
                        _showEndSidebar = newWidth >= closeBelow;
                      }

                      _endSidebarWidth = math.max(
                        endSidebar.minWidth,
                        math.min(
                          endSidebar.maxWidth!,
                          newWidth,
                        ),
                      );

                      if (_endSidebarWidth == endSidebar.minWidth) {
                        _endSidebarCursor = SystemMouseCursors.resizeLeft;
                      } else if (_endSidebarWidth == endSidebar.maxWidth) {
                        _endSidebarCursor = SystemMouseCursors.resizeRight;
                      } else {
                        _endSidebarCursor = SystemMouseCursors.resizeColumn;
                      }
                    });
                  },
                  child: MouseRegion(
                    cursor: _endSidebarCursor,
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
          constraints: constraints,
          isSidebarShown: canShowSidebar,
          sidebarToggler: () async {
            setState(() => _sidebarSlideDuration = 300);
            setState(() => _showSidebar = !_showSidebar);
            await Future.delayed(Duration(milliseconds: _sidebarSlideDuration));
            setState(() => _sidebarSlideDuration = 0);
          },
          endSidebarToggler: () async {
            setState(() => _sidebarSlideDuration = 300);
            setState(() => _showEndSidebar = !_showEndSidebar);
            await Future.delayed(Duration(milliseconds: _sidebarSlideDuration));
            setState(() => _sidebarSlideDuration = 0);
          },
          child: layout,
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
    super.key,
    required this.constraints,
    required super.child,
    required this.isSidebarShown,
    required VoidCallback sidebarToggler,
    required VoidCallback endSidebarToggler,
  })  : _sidebarToggler = sidebarToggler,
        _endSidebarToggler = endSidebarToggler;

  /// Provides the constraints from the [MacosWindow] to its descendants.
  final BoxConstraints constraints;

  /// Provides a callback which will be used to privately toggle the sidebar.
  final Function _sidebarToggler;

  /// Provides a callback which will be used to privately toggle the sidebar.
  final Function _endSidebarToggler;

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
    assert(result != null, 'No MacosWindowScope found in context');
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
    _sidebarToggler();
  }

  /// Toggles the [endSidebar] of the [MacosWindow].
  ///
  /// This does not change the current width of the [endSidebar]. It only
  /// hides or shows it.
  void toggleEndSidebar() {
    _endSidebarToggler();
  }

  @override
  bool updateShouldNotify(MacosWindowScope oldWidget) {
    return constraints != oldWidget.constraints ||
        isSidebarShown != oldWidget.isSidebarShown;
  }
}
