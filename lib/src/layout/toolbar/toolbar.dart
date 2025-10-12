import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/layout/toolbar/overflow_handler.dart';
import 'package:macos_ui/src/layout/wallpaper_tinting_settings/wallpaper_tinting_override.dart';
import 'package:macos_ui/src/library.dart';

/// Defines the height of a regular-sized [ToolBar]
const _kToolbarHeight = 52.0;

/// Defines the width of the leading widget in the [ToolBar]
const _kLeadingWidth = 20.0;

/// Defines the width of the [ToolBar]'s title.
const _kTitleWidth = 150.0;

/// A toolbar to use in a [MacosScaffold].
class ToolBar extends StatefulWidget with Diagnosticable {
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
    this.allowWallpaperTintingOverrides = true,
    this.enableBlur = false,
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

  /// Controls whether the toolbar should try to imply if the [leading] widget
  /// is null.
  ///
  /// If `true` and [leading] are null, the toolbar will automatically try to
  /// deduce what the leading widget should be. If `false` and [leading] is
  /// null, leading space is given to [title]. If the [leading] widget is not
  /// null, this parameter has no effect.
  final bool automaticallyImplyLeading;

  /// A list of [ToolbarItem] widgets to display in a row after the [title]
  /// widget, as the toolbar actions.
  ///
  /// Toolbar items include [ToolBarIconButton], [ToolBarPulldownButton],
  /// [ToolBarSpacer], and [CustomToolbarItem] widgets.
  ///
  /// If the toolbar actions exceed the available toolbar width (e.g. when the
  /// window is resized), the overflowed actions are displayed via a
  /// [ToolbarOverflowMenu], that can be opened from the [ToolbarOverflowButton]
  /// at the right edge of the toolbar.
  final List<ToolbarItem>? actions;

  /// Whether the [title] should be centered.
  final bool centerTitle;

  /// The color of the divider below the toolbar.
  ///
  /// Defaults to `MacosTheme.of(context).dividerColor`.
  ///
  /// Set this to `MacosColors.transparent` to remove.
  final Color? dividerColor;

  /// Whether this [ToolBar] is allowed to perform wallpaper tinting overrides.
  ///
  /// This property is supposed to be set to true when this [ToolBar] is
  /// currently visible on the screen (that is, not e.g. hidden by an
  /// [IndexedStack]).
  ///
  /// This parameter only needs to be supplied when [enableBlur] is true.
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
  /// when this widget's [enableBlur] and [allowWallpaperTintingOverrides] is
  /// true.
  ///
  /// This is meant to be a temporary solution until
  /// [#16296](https://github.com/flutter/flutter/issues/16296) is resolved in
  /// the Flutter project.
  final bool allowWallpaperTintingOverrides;

  /// Whether this [ToolBar] should have a blur backdrop filter applied to it.
  final bool enableBlur;

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
    properties.add(FlagProperty(
      'centerTitle',
      value: centerTitle,
      ifTrue: 'center title',
    ));
    properties.add(DiagnosticsProperty<Color>('dividerColor', dividerColor));
  }

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  int overflowedActionsCount = 0;

  @override
  void didUpdateWidget(ToolBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.actions != null &&
        widget.actions!.length != oldWidget.actions!.length) {
      overflowedActionsCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = MacosWindowScope.maybeOf(context);
    final MacosThemeData theme = MacosTheme.of(context);
    Color dividerColor = widget.dividerColor ?? theme.dividerColor;
    final route = ModalRoute.of(context);
    double overflowBreakpoint = 0.0;

    Widget? leading = widget.leading;
    if (leading == null && widget.automaticallyImplyLeading) {
      if (route?.canPop ?? false) {
        leading = Container(
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
      overflowBreakpoint += _kLeadingWidth;
    }

    Widget? title = widget.title;
    if (title != null) {
      title = SizedBox(
        width: widget.titleWidth,
        child: DefaultTextStyle(
          style: theme.typography.title3.copyWith(
            fontSize: 15,
            fontWeight: MacosFontWeight.w590,
          ),
          child: title,
        ),
      );
      overflowBreakpoint += widget.titleWidth;
    }

    // Collect the toolbar action widgets that can be shown inside the ToolBar
    // and the ones that have overflowed.
    List<ToolbarItem>? inToolbarActions = [];
    List<ToolbarItem> overflowedActions = [];
    bool doAllItemsShowLabel = true;
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      inToolbarActions = widget.actions ?? [];
      overflowedActions = inToolbarActions
          .sublist(inToolbarActions.length - overflowedActionsCount)
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
      child: _WallpaperTintedAreaOrBlurFilter(
        enableWallpaperTintedArea: kIsWeb ? false : !widget.enableBlur,
        isWidgetVisible: widget.allowWallpaperTintingOverrides,
        backgroundColor: theme.canvasColor,
        widgetOpacity: widget.decoration?.color?.a,
        child: Container(
          alignment: widget.alignment,
          padding: widget.padding,
          decoration: BoxDecoration(
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
            middle: title,
            centerMiddle: widget.centerTitle,
            trailing: OverflowHandler(
              overflowBreakpoint: overflowBreakpoint,
              overflowWidget: ToolbarOverflowButton(
                isDense: doAllItemsShowLabel,
                overflowContentBuilder: (context) => ToolbarOverflowMenu(
                  children: overflowedActions
                      .map((action) => action.build(
                            context,
                            ToolbarItemDisplayMode.overflowed,
                          ))
                      .toList(),
                ),
              ),
              children: inToolbarActions
                  .map(
                    (e) => e.build(context, ToolbarItemDisplayMode.inToolbar),
                  )
                  .toList(),
              overflowChangedCallback: (hiddenItems) {
                setState(() => overflowedActionsCount = hiddenItems.length);
              },
            ),
            middleSpacing: 8,
            leading: SafeArea(
              top: false,
              right: false,
              bottom: false,
              left: !(scope?.isSidebarShown ?? false),
              child: leading ?? const SizedBox.shrink(),
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

/// {@template toolbarItem}
/// An individual action displayed within a [Toolbar]. Sub-class this
/// to build a new type of widget that appears inside of a toolbar.
/// It knows how to build an appropriate widget for the given
/// [ToolbarItemDisplayMode] during build time.
/// {@endtemplate}
abstract class ToolbarItem with Diagnosticable {
  /// {@macro toolbarItem}
  const ToolbarItem({required this.key});

  final Key? key;

  /// Builds the final widget for this display mode for this item.
  /// Sub-classes implement this to build the widget that is appropriate
  /// for the given display mode (in toolbar or overflowed).
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode);
}

/// Wraps the widget in either a [WallpaperTintingOverride] or a blurry backdrop
/// filter.
class _WallpaperTintedAreaOrBlurFilter extends StatelessWidget {
  const _WallpaperTintedAreaOrBlurFilter({
    required this.child,
    required this.enableWallpaperTintedArea,
    required this.backgroundColor,
    required this.widgetOpacity,
    required this.isWidgetVisible,
  });

  final Widget child;
  final bool enableWallpaperTintedArea;
  final Color backgroundColor;
  final double? widgetOpacity;
  final bool isWidgetVisible;

  @override
  Widget build(BuildContext context) {
    if (enableWallpaperTintedArea) {
      return WallpaperTintedArea(
        backgroundColor: backgroundColor,
        insertRepaintBoundary: true,
        child: child,
      );
    }

    if (!isWidgetVisible) {
      return child;
    }

    return WallpaperTintingOverride(
      child: ClipRect(
        child: BackdropFilter(
          filter: widgetOpacity == 1.0
              ? ImageFilter.blur()
              : ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
          child: child,
        ),
      ),
    );
  }
}
