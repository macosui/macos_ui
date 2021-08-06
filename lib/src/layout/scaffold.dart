import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:macos_ui/src/layout/content_area.dart';
import 'package:macos_ui/src/layout/resizable_pane.dart';
import 'package:macos_ui/src/layout/sidebar.dart';
import 'package:macos_ui/src/layout/title_bar.dart';
import 'package:macos_ui/src/layout/window.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/macos_theme.dart';

/// A macOS page widget.
///
/// This widget fills the rest of the space in a [MacosWindow]
class MacosScaffold extends StatefulWidget {
  /// Creates a macOS page layout.
  ///
  /// The [children] can only include one [ContentArea], but can include
  /// multiple [ResizablePane] widgets.
  const MacosScaffold({
    Key? key,
    this.children = const <Widget>[],
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

  /// An app bar to display at the top of the scaffold.
  final TitleBar? titleBar;

  @override
  _MacosScaffoldState createState() => _MacosScaffoldState();
}

class _MacosScaffoldState extends State<MacosScaffold> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
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

    final MacosThemeData theme = MacosTheme.of(context);
    late Color backgroundColor = widget.backgroundColor ?? theme.canvasColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final mediaQuery = MediaQuery.of(context);
        final children = widget.children;

        return Stack(
          children: [
            // Background color
            Positioned.fill(
              child: ColoredBox(color: backgroundColor),
            ),

            // Content Area
            Positioned(
              top: 0,
              width: width,
              height: height,
              child: MediaQuery(
                child: _ScaffoldBody(children: children),
                data: mediaQuery.copyWith(
                  padding: widget.titleBar != null
                      ? EdgeInsets.only(top: widget.titleBar!.height)
                      : null,
                ),
              ),
            ),

            // Title bar
            if (widget.titleBar != null)
              Positioned(
                width: width,
                height: widget.titleBar!.height,
                child: widget.titleBar!,
              ),
          ],
        );
      },
    );
  }
}

class _ScaffoldBody extends MultiChildRenderObjectWidget {
  _ScaffoldBody({
    List<Widget> children = const <Widget>[],
  }) : super(children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    final index =
        children.indexWhere((e) => e.key == Key('macos_scaffold_content_area'));
    return _RenderScaffoldBody(contentAreaIndex: index > -1 ? index : null);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderScaffoldBody renderObject,
  ) {
    final index =
        children.indexWhere((e) => e.key == Key('macos_scaffold_content_area'));
    renderObject..contentAreaIndex = index > -1 ? index : null;
  }
}

class _ParentData extends ContainerBoxParentData<RenderBox> {
  int index = 0;
  double width = 0.0;
}

class _RenderScaffoldBody extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ParentData> {
  _RenderScaffoldBody({
    List<RenderBox> children = const <RenderBox>[],
    this.contentAreaIndex,
  }) {
    addAll(children);
  }

  int? contentAreaIndex;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ParentData) child.parentData = _ParentData();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void performLayout() {
    final fullHeight = constraints.biggest.height;
    final fullWidth = constraints.biggest.width;
    double width = 0.0;
    int childCount = 0;
    RenderBox? child = firstChild;
    double sum = 0;

    final _children = getChildrenAsList();
    if (contentAreaIndex != null) {
      _children.removeAt(contentAreaIndex!);
    }
    _children.forEach((child) {
      child.layout(BoxConstraints.tightFor(), parentUsesSize: true);
      sum += child.size.width;
    });

    while (child != null) {
      final isContentArea = childCount == contentAreaIndex;
      if (isContentArea) {
        double contentAreaWidth = math.max(300, fullWidth - sum);
        child.layout(
          BoxConstraints(
            maxWidth: contentAreaWidth,
            maxHeight: fullHeight,
            minHeight: fullHeight,
          ).normalize(),
          parentUsesSize: true,
        );
      } else {
        child.layout(BoxConstraints.tightFor(), parentUsesSize: true);
      }
      final childSize = child.size;
      final _ParentData childParentData = child.parentData! as _ParentData;
      childParentData.width = childSize.width;
      if (childParentData.previousSibling != null) {
        width +=
            (childParentData.previousSibling?.parentData as _ParentData).width;
      }
      childParentData.offset = Offset(width, 0);
      childParentData.index = childCount;
      childCount++;
      child = childParentData.nextSibling;
    }
    size = Size(fullWidth, fullHeight);
  }
}
