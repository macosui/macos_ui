import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// Defines the height of a regular-sized [SliverToolBar]
const _kToolbarHeight = 52.0;

/// Defines the width of the [SliverToolBar]'s title.
const _kTitleWidth = 150.0;

/// {@template sliverToolBar}
/// A variant of [ToolBar] that is compatible with slivers.
///
/// It is nearly identical to [ToolBar], with the exception that this widget
/// must only be used [ScrollView]s that allow slivers, such as
/// [CustomScrollView] and [NestedScrollView]. It contains three additional
/// properties that are relevant to its usage in such [ScrollView]s: [pinned],
/// [floating], and [toolbarOpacity].
///
/// See also:
/// * [SliverAppBar] (package:material)
/// {@endtemplate}
class SliverToolBar extends StatefulWidget with Diagnosticable {
  /// {@macro sliverToolBar}
  const SliverToolBar({
    super.key,
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
    this.pinned = true,
    this.floating = false,
    this.toolbarOpacity = 0.9,
    this.allowWallpaperTintingOverrides = true,
  });

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

  /// Whether the toolbar should remain visible at the start of the scroll view.
  ///
  /// Defaults to `true`.
  final bool pinned;

  /// Whether the toolbar should become visible as soon as the user scrolls
  /// upwards.
  ///
  /// Otherwise, the user will need to scroll near the top of the scroll view
  /// to reveal the toolbar.
  ///
  /// Defaults to `false`.
  final bool floating;

  /// The opacity of the toolbar when content is scrolled underneath it.
  ///
  /// Adjust this value to tweak the blur effect the toolbar creates. Note that
  /// the blur is only applied when content is being scrolled underneath the
  /// toolbar.
  ///
  /// Defaults to `0.9`.
  final double toolbarOpacity;

  /// Whether this [SliverToolBar] is allowed to perform wallpaper tinting
  /// overrides.
  ///
  /// This property is supposed to be set to true when this [SliverToolBar] is
  /// currently visible on the screen (that is, not e.g. hidden by an
  /// [IndexedStack]).
  ///
  /// By default, macos_ui applies wallpaper tinting to the application's
  /// window to match macOS' native appearance:
  ///
  /// <img src="https://user-images.githubusercontent.com/86920182/220182724-d78319d7-5c41-4e8c-b785-a73a6ea24927.jpg" width=640/>
  ///
  /// However, this effect is realized by inserting `NSVisualEffectView`s behind
  /// Flutter's canvas and turning the background of areas that are meant to be
  /// affected by wallpaper tinting transparent. Since Flutter's
  /// [`ImageFilter.blur`](https://api.flutter.dev/flutter/dart-ui/ImageFilter/ImageFilter.blur.html)
  /// does not support transparency, wallpaper tinting is disabled automatically
  /// when this widget's [allowWallpaperTintingOverrides] is true.
  ///
  /// This is meant to be a temporary solution until
  /// [#16296](https://github.com/flutter/flutter/issues/16296) is resolved in
  /// the Flutter project.
  final bool allowWallpaperTintingOverrides;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<Alignment>('alignment', alignment));
    properties.add(DiagnosticsProperty<Widget>('title', title));
    properties.add(DoubleProperty('titleWidth', titleWidth));
    properties
        .add(DiagnosticsProperty<BoxDecoration>('decoration', decoration));
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
    properties.add(DiagnosticsProperty<Widget>('leading', leading));
    properties.add(FlagProperty(
      'automaticallyImplyLeading',
      value: automaticallyImplyLeading,
      ifTrue: 'automatically imply leading',
    ));
    properties.add(DiagnosticsProperty<List<ToolbarItem>>('actions', actions));
    properties.add(
      FlagProperty('centerTitle', value: centerTitle, ifTrue: 'center title'),
    );
    properties.add(DiagnosticsProperty<Color>('dividerColor', dividerColor));
    properties.add(FlagProperty('pinned', value: pinned, ifTrue: 'pinned'));
    properties
        .add(FlagProperty('floating', value: floating, ifTrue: 'floating'));
  }

  @override
  State<SliverToolBar> createState() => _SliverToolBarState();
}

class _SliverToolBarState extends State<SliverToolBar>
    with TickerProviderStateMixin {
  int overflowedActionsCount = 0;

  @override
  void didUpdateWidget(SliverToolBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.actions != null &&
        widget.actions!.length != oldWidget.actions!.length) {
      overflowedActionsCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: SliverPersistentHeader(
        floating: widget.floating,
        pinned: widget.pinned,
        delegate: _SliverToolBarDelegate(
          height: widget.height,
          alignment: widget.alignment,
          title: widget.title,
          titleWidth: widget.titleWidth,
          decoration: widget.decoration,
          padding: widget.padding,
          leading: widget.leading,
          automaticallyImplyLeading: widget.automaticallyImplyLeading,
          actions: widget.actions,
          centerTitle: widget.centerTitle,
          dividerColor: widget.dividerColor,
          floating: widget.floating,
          pinned: widget.pinned,
          toolbarOpacity: widget.toolbarOpacity,
          allowWallpaperTintingOverrides: widget.allowWallpaperTintingOverrides,
          vsync: this,
        ),
      ),
    );
  }
}

class _SliverToolBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverToolBarDelegate({
    required this.height,
    required this.alignment,
    required this.title,
    required this.titleWidth,
    required this.decoration,
    required this.padding,
    required this.leading,
    required this.automaticallyImplyLeading,
    required this.actions,
    required this.centerTitle,
    required this.dividerColor,
    required this.vsync,
    required this.floating,
    required this.pinned,
    required this.toolbarOpacity,
    required this.allowWallpaperTintingOverrides,
  });

  final double height;
  final Alignment alignment;
  final Widget? title;
  final double titleWidth;
  final BoxDecoration? decoration;
  final EdgeInsets padding;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final List<ToolbarItem>? actions;
  final bool centerTitle;
  final Color? dividerColor;
  final bool floating;
  final bool pinned;
  final double toolbarOpacity;
  final bool allowWallpaperTintingOverrides;

  @override
  double get minExtent => _kToolbarHeight;

  @override
  double get maxExtent => _kToolbarHeight;

  @override
  final TickerProvider vsync;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final bool isScrolledUnder = overlapsContent ||
        (pinned || floating && shrinkOffset > maxExtent - minExtent);
    final double opacity =
        pinned || floating && isScrolledUnder ? toolbarOpacity : 1.0;

    BoxDecoration? effectiveDecoration;
    if (isScrolledUnder) {
      effectiveDecoration = decoration?.copyWith(
            color: decoration?.color?.withValues(alpha: opacity),
          ) ??
          BoxDecoration(
            color:
                MacosTheme.of(context).canvasColor.withValues(alpha: opacity),
          );
    }

    return FlexibleSpaceBar.createSettings(
      minExtent: minExtent,
      maxExtent: maxExtent,
      currentExtent: math.max(minExtent, maxExtent - shrinkOffset),
      toolbarOpacity: opacity,
      isScrolledUnder: isScrolledUnder,
      child: ToolBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        leading: leading,
        title: title,
        titleWidth: titleWidth,
        decoration: effectiveDecoration,
        padding: padding,
        actions: actions,
        centerTitle: centerTitle,
        dividerColor: dividerColor,
        alignment: alignment,
        height: height,
        enableBlur: true,
        allowWallpaperTintingOverrides: allowWallpaperTintingOverrides,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SliverToolBarDelegate oldDelegate) {
    return leading != oldDelegate.leading ||
        automaticallyImplyLeading != oldDelegate.automaticallyImplyLeading ||
        alignment != oldDelegate.alignment ||
        title != oldDelegate.title ||
        titleWidth != oldDelegate.titleWidth ||
        decoration != oldDelegate.decoration ||
        padding != oldDelegate.padding ||
        leading != oldDelegate.leading ||
        actions != oldDelegate.actions ||
        centerTitle != oldDelegate.centerTitle ||
        dividerColor != oldDelegate.dividerColor ||
        floating != oldDelegate.floating ||
        pinned != oldDelegate.pinned ||
        allowWallpaperTintingOverrides !=
            oldDelegate.allowWallpaperTintingOverrides;
  }
}
