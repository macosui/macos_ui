import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:macos_ui/src/layout/window.dart';
import 'package:macos_ui/src/theme/macos_theme.dart';

/// Defines the height of a regular-sized [TitleBar]
const kTitleBarHeight = 52.0;

class TitleBar extends StatelessWidget {
  /// Creates a title bar in the [MacosScaffold].
  ///
  /// The height of the TitleBar can be changed with [height].
  const TitleBar({
    this.height = kTitleBarHeight,
    this.alignment = Alignment.center,
    this.child,
    this.padding = const EdgeInsets.all(8),
    this.decoration,
  });

  /// Specifies the height of this [TitleBar]
  ///
  /// Defaults to [kTitleBarHeight] which is 52.0
  final double height;

  /// Align the [child] within the [TitleBar].
  ///
  /// Defaults to [Alignment.center].
  ///
  /// The [TitleBar] will expand to fill its parent and position its
  /// child within itself according to the given value.
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final Alignment alignment;

  /// The [child] contained by the container.
  final Widget? child;

  /// The decoration to paint behind the [child].
  final BoxDecoration? decoration;

  /// Empty space to inscribe inside the title bar. The [child], if any, is
  /// placed inside this padding.
  ///
  /// Defaults to `EdgeInsets.all(8)`
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final MacosThemeData theme = MacosTheme.of(context);
    Color dividerColor = theme.dividerColor;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        padding: EdgeInsets.only(left: 60),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: decoration?.color?.alpha == 255
              ? ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0)
              : ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            alignment: alignment,
            padding: padding,
            child: SafeArea(
              top: false,
              right: false,
              bottom: false,
              left: !MacosWindowScope.of(context).isSidebarShown,
              child: child ?? SizedBox.shrink(),
            ),
            decoration: BoxDecoration(
              color: theme.canvasColor,
              border: Border(bottom: BorderSide(color: dividerColor)),
            ).copyWith(
              color: decoration?.color,
              image: decoration?.image,
              border: decoration?.border,
              borderRadius: decoration?.borderRadius,
              boxShadow: decoration?.boxShadow,
              gradient: decoration?.gradient,
            ),
          ),
        ),
      ),
    );
  }
}
