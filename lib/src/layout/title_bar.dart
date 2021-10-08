import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/src/buttons/back_button.dart';
import 'package:macos_ui/src/layout/window.dart';
import 'package:macos_ui/src/theme/macos_theme.dart';

/// Defines the height of a regular-sized [TitleBar]
const kTitleBarHeight = 52.0;

class TitleBar extends StatelessWidget {
  /// Creates a title bar in the [MacosScaffold].
  ///
  /// The height of the TitleBar can be changed with [height].
  const TitleBar({
    Key? key,
    this.height = kTitleBarHeight,
    this.alignment = Alignment.center,
    this.title,
    this.padding = const EdgeInsets.all(8),
    this.decoration,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.centerTitle = true,
  }) : super(key: key);

  /// Specifies the height of this [TitleBar]
  ///
  /// Defaults to [kTitleBarHeight] which is 52.0
  final double height;

  /// Align the [title] within the [TitleBar].
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

  /// The [title] contained by the container.
  final Widget? title;

  /// The decoration to paint behind the [title].
  final BoxDecoration? decoration;

  /// Empty space to inscribe inside the title bar. The [title], if any, is
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
  Widget build(BuildContext context) {
    final scope = MacosWindowScope.maybeOf(context);
    final MacosThemeData theme = MacosTheme.of(context);
    Color dividerColor = theme.dividerColor;
    final route = ModalRoute.of(context);

    Widget? _leading = leading;
    if (_leading == null && automaticallyImplyLeading) {
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

    Widget? _title = title;
    if (_title != null) {
      _title = DefaultTextStyle(
        child: _title,
        style: MacosTheme.of(context).typography.headline.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: theme.brightness.isDark
                  ? const Color(0xFFEAEAEA)
                  : const Color(0xFF4D4D4D),
            ),
      );
    }

    Widget? _actions;
    if (actions != null && actions!.isNotEmpty) {
      _actions = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: actions!,
      );
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
          filter: decoration?.color?.opacity == 1
              ? ImageFilter.blur()
              : ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            alignment: alignment,
            padding: padding,
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
            child: NavigationToolbar(
              middle: _title,
              centerMiddle: centerTitle,
              trailing: _actions,
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
