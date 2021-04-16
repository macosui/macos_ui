import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/layout/content_area.dart';
import 'package:macos_ui/src/layout/resizable_pane.dart';
import 'package:macos_ui/src/layout/resizable_pane_notifier.dart';
import 'package:macos_ui/src/layout/sidebar.dart';
import 'package:macos_ui/src/layout/title_bar.dart';

const _kTitleBarHeight = 52.0;

const _kSmallTitleBarHeight = 30.0;

/// A basic screen-layout widget.
///
/// Provides a [body] for main content and a [sidebar] for secondary content
/// (like navigation buttons). If no [sidebar] is specified, only the [body]
/// will be shown.
class Scaffold extends StatefulWidget {
  /// Creates a macOS window layout.
  ///
  /// The [children] can only include one [ContentArea], but can no or multiple [ResizablePane] widgets.
  Scaffold({
    Key? key,
    this.children = const <Widget>[],
    this.sidebar,
    this.titleBar,
    this.backgroundColor,
  })  : assert(
          children.every((e) => e is ContentArea || e is ResizablePane),
          'Scaffold children must either be ResizablePane or ContentArea',
        ),
        assert(children.whereType<ContentArea>().length <= 1,
            'Scaffold cannot have more than one ContentArea widget'),
        super(key: key);

  /// Specifies the background color for the Scaffold.
  ///
  /// The default colors from the theme would be used if no color is specified.
  final Color? backgroundColor;

  /// The children to display in the rest of the scaffold, excluding the [Sidebar] and [Titlebar] regions.
  final List<Widget> children;

  /// A sidebar to display at the left of the scaffold.
  final Sidebar? sidebar;

  /// An app bar to display at the top of the scaffold.
  final TitleBar? titleBar;

  @override
  _ScaffoldState createState() => _ScaffoldState();
}

class _ScaffoldState extends State<Scaffold> {
  final _sidebarScrollController = ScrollController();
  final _minContentAreaWidth = 300.0;
  ResizablePaneNotifier _valueNotifier = ResizablePaneNotifier({});
  double _sidebarWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _sidebarWidth = widget.sidebar?.minWidth ?? _sidebarWidth;
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
  void didUpdateWidget(covariant Scaffold old) {
    super.didUpdateWidget(old);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _valueNotifier.reset();
      setState(() {
        if (widget.sidebar == null)
          _sidebarWidth = 0.0;
        else {
          if (widget.sidebar!.minWidth > _sidebarWidth)
            _sidebarWidth = widget.sidebar!.minWidth;
          if (widget.sidebar!.maxWidth! < _sidebarWidth)
            _sidebarWidth = widget.sidebar!.maxWidth!;
        }
      });
      _valueNotifier.notify();
    });
  }

  @override
  // ignore: code-metrics
  Widget build(BuildContext context) {
    debugCheckHasMacosTheme(context);
    late Color background;
    late Color sidebarColor;

    if (context.theme.brightness!.isLight) {
      background =
          widget.backgroundColor ?? CupertinoColors.systemBackground.color;
      sidebarColor =
          widget.sidebar?.resizerColor ?? CupertinoColors.systemGrey6.color;
    } else {
      background = widget.backgroundColor ??
          CupertinoColors.systemBackground.darkElevatedColor;
      sidebarColor = widget.sidebar?.resizerColor ??
          CupertinoColors.tertiarySystemBackground.darkColor;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final style = context.theme;
        final mediaQuery = MediaQuery.of(context);
        final children = widget.children;
        final titleBarHeight = widget.titleBar?.size == TitleBarSize.large
            ? _kTitleBarHeight
            : _kSmallTitleBarHeight;

        final layout = Stack(
          children: [
            // Sidebar
            if (widget.sidebar != null)
              Positioned(
                height: height,
                width: _sidebarWidth,
                child: AnimatedContainer(
                  duration: style.mediumAnimationDuration ?? Duration.zero,
                  curve: style.animationCurve ?? Curves.linear,
                  color: sidebarColor,
                  child: Padding(
                    padding: widget.sidebar?.padding ??
                        EdgeInsets.only(top: titleBarHeight - 1),
                    child: Column(
                      children: [
                        if (_sidebarScrollController.hasClients &&
                            _sidebarScrollController.offset > 0.0)
                          Divider(thickness: 1, height: 1),
                        Expanded(
                          child: Scrollbar(
                            controller: _sidebarScrollController,
                            child: widget.sidebar!
                                .builder(context, _sidebarScrollController),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Content Area
            Positioned(
              top: 0,
              left: _sidebarWidth,
              height: height,
              child: AnimatedContainer(
                duration:
                    context.theme.mediumAnimationDuration ?? Duration.zero,
                curve: context.theme.animationCurve ?? Curves.linear,
                color: background,
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
            ),

            // Title bar
            if (widget.titleBar != null)
              Positioned(
                height: titleBarHeight,
                left: _sidebarWidth,
                width: math.max(width - _sidebarWidth, 0),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: widget.titleBar?.decoration?.color?.alpha == 255
                        ? ImageFilter.blur()
                        : ImageFilter.blur(
                            sigmaX: 5.0,
                            sigmaY: 5.0,
                          ),
                    child: Container(
                      alignment: widget.titleBar?.alignment ?? Alignment.center,
                      padding: widget.titleBar?.padding ?? EdgeInsets.all(8),
                      child: FittedBox(child: widget.titleBar?.child),
                      decoration: BoxDecoration(
                        color: background,
                      ).copyWith(
                        color: widget.titleBar?.decoration?.color,
                        image: widget.titleBar?.decoration?.image,
                        border: widget.titleBar?.decoration?.border ??
                            Border(
                              bottom: BorderSide(color: Color(0x1F000000)),
                            ),
                        borderRadius: widget.titleBar?.decoration?.borderRadius,
                        boxShadow: widget.titleBar?.decoration?.boxShadow,
                        gradient: widget.titleBar?.decoration?.gradient,
                      ),
                    ),
                  ),
                ),
              ),

            // Sidebar resizer
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
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeColumn,
                  child: Align(
                    alignment: Alignment.center,
                    child: VerticalDivider(
                      thickness: 1,
                      width: 1,
                      color: Color(0x1F000000),
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
            double _remainingWidth = width - (_sidebarWidth + sum);

            return ScaffoldScope(
              child: child!,
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

class ScaffoldScope extends InheritedWidget {
  const ScaffoldScope({
    Key? key,
    required this.constraints,
    required this.contentAreaWidth,
    required Widget child,
    required this.valueNotifier,
  }) : super(key: key, child: child);

  final BoxConstraints constraints;

  final double contentAreaWidth;

  final ResizablePaneNotifier valueNotifier;

  static ScaffoldScope of(BuildContext context) {
    final ScaffoldScope? result =
        context.dependOnInheritedWidgetOfExactType<ScaffoldScope>();
    assert(result != null, 'No ScaffoldContraints found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ScaffoldScope old) {
    return constraints != old.constraints ||
        contentAreaWidth != old.contentAreaWidth ||
        !mapEquals(valueNotifier.value, old.valueNotifier.value);
  }
}
