import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const Duration _kExpand = Duration(milliseconds: 200);
const ShapeBorder _defaultShape = RoundedRectangleBorder(
  //TODO: consider changing to 4.0 or 5.0 - App Store, Notes and Mail seem to use 4.0 or 5.0
  borderRadius: BorderRadius.all(Radius.circular(5.0)),
);

/// {@template sidebarItemSize}
/// Enumerates the size specifications of [SidebarItem]s
///
/// Values were adapted from https://developer.apple.com/design/human-interface-guidelines/components/navigation-and-search/sidebars/#platform-considerations
/// and were eyeballed against apps like App Store, Notes, and Mail.
/// {@endtemplate}
enum SidebarItemSize {
  /// A small [SidebarItem]. Has a [height] of 24 and an [iconSize] of 12.
  small(24.0, 12.0),

  /// A medium [SidebarItem]. Has a [height] of 28 and an [iconSize] of 16.
  medium(29.0, 16.0),

  /// A large [SidebarItem]. Has a [height] of 32 and an [iconSize] of 20.0.
  large(36.0, 18.0);

  /// {@macro sidebarItemSize}
  const SidebarItemSize(
    this.height,
    this.iconSize,
  );

  /// The height of the [SidebarItem].
  final double height;

  /// The maximum size of the [SidebarItem]'s leading icon.
  final double iconSize;
}

/// A scrollable widget that renders [SidebarItem]s.
///
/// See also:
///
///  * [SidebarItem], the items used by this sidebar
///  * [Sidebar], a side bar used alongside [MacosScaffold]
class SidebarItems extends StatelessWidget {
  /// Creates a scrollable widget that renders [SidebarItem]s.
  const SidebarItems({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onChanged,
    this.itemSize = SidebarItemSize.medium,
    this.scrollController,
    this.selectedColor,
    this.unselectedColor,
    this.shape,
    this.cursor = SystemMouseCursors.basic,
  }) : assert(currentIndex >= 0);

  /// The [SidebarItem]s used by the sidebar. If no items are provided,
  /// the sidebar is not rendered.
  final List<SidebarItem> items;

  /// The current selected index. It must be in the range of 0 to
  /// [items.length]
  final int currentIndex;

  /// Called when the current selected index should be changed.
  final ValueChanged<int> onChanged;

  /// The size specifications for all [items].
  ///
  /// Defaults to [SidebarItemSize.medium].
  final SidebarItemSize itemSize;

  /// The scroll controller used by this sidebar. If null, a local scroll
  /// controller is created.
  final ScrollController? scrollController;

  /// The color to paint the item when it's selected.
  ///
  /// If null, the color is chosen automatically based on the user’s selected
  /// system accent color and whether the sidebar is in the main window.
  final Color? selectedColor;

  /// The color to paint the item when it's unselected.
  ///
  /// Defaults to transparent.
  final Color? unselectedColor;

  /// The [shape] property specifies the outline (border) of the
  /// decoration. The shape must not be null. It's used alongside
  /// [selectedColor].
  final ShapeBorder? shape;

  /// Specifies the kind of cursor to use for all sidebar items.
  ///
  /// Defaults to [SystemMouseCursors.basic].
  final MouseCursor? cursor;

  /// The user’s selected system accent color.
  AccentColor _getAccentColor(BuildContext context) =>
      MacosTheme.of(context).accentColor ?? AccentColor.blue;

  /// Returns the sidebar item’s selected color.
  Color _getColor(BuildContext context) {
    final isMainWindow = WindowMainStateListener.instance.isMainWindow;

    return _ColorProvider.getSelectedColor(
      accentColor: _getAccentColor(context),
      isDarkModeEnabled: MacosTheme.of(context).brightness.isDark,
      isWindowMain: isMainWindow,
    );
  }

  List<SidebarItem> get _allItems {
    List<SidebarItem> result = [];
    for (var element in items) {
      if (element.disclosureItems != null) {
        result.addAll(element.disclosureItems!);
      } else if (element.section == false) {
        result.add(element);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    assert(debugCheckHasMacosTheme(context));
    assert(currentIndex < _allItems.length);
    final theme = MacosTheme.of(context);
    return MacosIconTheme.merge(
      data: const MacosIconThemeData(size: 20),
      child: StreamBuilder(
        stream: AccentColorListener.instance.onChanged,
        builder: (context, _) {
          return StreamBuilder<bool>(
            stream: WindowMainStateListener.instance.onChanged,
            builder: (context, _) {
              return _SidebarItemsConfiguration(
                selectedColor: selectedColor ?? _getColor(context),
                unselectedColor: unselectedColor ?? MacosColors.transparent,
                shape: shape ?? _defaultShape,
                itemSize: itemSize,
                child: ListView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding:
                      EdgeInsets.all(10.0 - theme.visualDensity.horizontal),
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    if (item.section == true && item.disclosureItems != null) {
                      return _DisclosureSidebarHeaderItem(
                        item: item,
                        selectedItem: _allItems[currentIndex],
                        onChanged: (item) {
                          onChanged(_allItems.indexOf(item));
                        },
                      );
                    }
                    if (item.section == true) {
                      return _SidebarHeaderItem(item: item);
                    }
                    if (item.disclosureItems != null) {
                      return MouseRegion(
                        cursor: cursor!,
                        child: _DisclosureSidebarItem(
                          item: item,
                          selectedItem: _allItems[currentIndex],
                          onChanged: (item) {
                            onChanged(_allItems.indexOf(item));
                          },
                        ),
                      );
                    }
                    return MouseRegion(
                      cursor: cursor!,
                      child: _SidebarItem(
                        item: item,
                        selected: _allItems[currentIndex] == item,
                        onClick: () => onChanged(_allItems.indexOf(item)),
                      ),
                    );
                  }),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SidebarItemsConfiguration extends InheritedWidget {
  // ignore: use_super_parameters
  const _SidebarItemsConfiguration({
    Key? key,
    required super.child,
    this.selectedColor = MacosColors.transparent,
    this.unselectedColor = MacosColors.transparent,
    this.shape = _defaultShape,
    this.itemSize = SidebarItemSize.medium,
  }) : super(key: key);

  final Color selectedColor;
  final Color unselectedColor;
  final ShapeBorder shape;
  final SidebarItemSize itemSize;

  static _SidebarItemsConfiguration of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SidebarItemsConfiguration>()!;
  }

  @override
  bool updateShouldNotify(_SidebarItemsConfiguration oldWidget) {
    return true;
  }
}

class _SidebarHeaderItem extends StatelessWidget {
  // ignore: use_super_parameters
  const _SidebarHeaderItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final SidebarItem item;

  bool get hasLeading => item.leading != null;
  bool get hasTrailing => item.trailing != null;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final theme = MacosTheme.of(context);

    final double spacing = 10.0 + theme.visualDensity.horizontal;
    final itemSize = _SidebarItemsConfiguration.of(context).itemSize;
    TextStyle? labelStyle;
    switch (itemSize) {
      case SidebarItemSize.small:
        labelStyle = theme.typography.subheadline;
        break;
      case SidebarItemSize.medium:
        labelStyle = theme.typography.body;
        break;
      case SidebarItemSize.large:
        labelStyle = theme.typography.title3;
        break;
    }

    return Semantics(
        label: item.semanticLabel,
        child: Container(
          width: 134.0 + theme.visualDensity.horizontal,
          height: itemSize.height + theme.visualDensity.vertical,
          decoration: ShapeDecoration(
            color: MacosColors.transparent,
            shape: item.shape ?? _SidebarItemsConfiguration.of(context).shape,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 7 + theme.visualDensity.horizontal,
            horizontal: spacing,
          ),
          child: Row(
            children: [
              if (hasLeading)
                Padding(
                  padding: EdgeInsets.only(right: spacing),
                  child: MacosIconTheme.merge(
                    data: MacosIconThemeData(
                      color: theme.primaryColor,
                      size: itemSize.iconSize,
                    ),
                    child: item.leading!,
                  ),
                ),
              Expanded(
                child: _buildLabelWithDefaultTextStyle(labelStyle, context),
              ),
              if (hasTrailing) ...[
                const Spacer(),
                DefaultTextStyle(
                  style: labelStyle.copyWith(
                    color: null,
                  ),
                  child: item.trailing!,
                ),
              ],
            ],
          ),
        ));
  }

  DefaultTextStyle _buildLabelWithDefaultTextStyle(
      TextStyle labelStyle, BuildContext context) {
    final isDarkModeEnabled = MacosTheme.of(context).brightness.isDark;

    return DefaultTextStyle(
      style: labelStyle.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: (labelStyle.fontSize ?? 14.0) * 0.85,
        color: isDarkModeEnabled
            ? MacosColors.white.withValues(alpha: 0.3)
            : MacosColors.black.withValues(alpha: 0.3),
        overflow: TextOverflow.ellipsis,
      ),
      child: item.label,
    );
  }
}

/// A macOS style navigation-list item intended for use in a [Sidebar]
class _SidebarItem extends StatelessWidget {
  /// Builds a [_SidebarItem].
  // ignore: use_super_parameters
  const _SidebarItem({
    Key? key,
    required this.item,
    required this.onClick,
    required this.selected,
  }) : super(key: key);

  /// The widget to lay out first.
  ///
  /// Typically an [Icon]
  final SidebarItem item;

  /// Whether the item is selected or not
  final bool selected;

  /// A function to perform when the widget is clicked or tapped.
  ///
  /// Typically a [Navigator] call
  final VoidCallback? onClick;

  void _handleActionTap() => onClick?.call();

  Map<Type, Action<Intent>> get _actionMap => <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (ActivateIntent intent) => _handleActionTap(),
        ),
        ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
          onInvoke: (ButtonActivateIntent intent) => _handleActionTap(),
        ),
      };

  bool get hasLeading => item.leading != null;
  bool get hasTrailing => item.trailing != null;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final theme = MacosTheme.of(context);

    final selectedColor = MacosDynamicColor.resolve(
      item.selectedColor ??
          _SidebarItemsConfiguration.of(context).selectedColor,
      context,
    );
    final unselectedColor = MacosDynamicColor.resolve(
      item.unselectedColor ??
          _SidebarItemsConfiguration.of(context).unselectedColor,
      context,
    );

    final double spacing = 10.0 + theme.visualDensity.horizontal;
    final itemSize = _SidebarItemsConfiguration.of(context).itemSize;
    TextStyle? labelStyle;
    switch (itemSize) {
      case SidebarItemSize.small:
        labelStyle = theme.typography.subheadline;
        break;
      case SidebarItemSize.medium:
        labelStyle = theme.typography.body;
        break;
      case SidebarItemSize.large:
        labelStyle = theme.typography.title3;
        break;
    }

    return Semantics(
      label: item.semanticLabel,
      button: true,
      focusable: true,
      focused: item.focusNode?.hasFocus,
      enabled: onClick != null,
      selected: selected,
      child: GestureDetector(
        onTap: onClick,
        child: FocusableActionDetector(
          focusNode: item.focusNode,
          descendantsAreFocusable: false,
          enabled: onClick != null,
          //mouseCursor: SystemMouseCursors.basic,
          actions: _actionMap,
          child: Container(
            width: 134.0 + theme.visualDensity.horizontal,
            height: itemSize.height + theme.visualDensity.vertical,
            decoration: ShapeDecoration(
              color: selected ? selectedColor : unselectedColor,
              shape: item.shape ?? _SidebarItemsConfiguration.of(context).shape,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 7 + theme.visualDensity.horizontal,
              horizontal: spacing,
            ),
            child: Row(
              children: [
                if (hasLeading)
                  Padding(
                    padding: EdgeInsets.only(right: spacing),
                    child: MacosIconTheme.merge(
                      data: MacosIconThemeData(
                        color:
                            selected ? MacosColors.white : theme.primaryColor,
                        size: itemSize.iconSize,
                      ),
                      child: item.leading!,
                    ),
                  ),
                Expanded(
                  child: _buildLabelWithDefaultTextStyle(
                    labelStyle,
                    selectedColor,
                    context,
                  ),
                ),
                if (hasTrailing) ...[
                  DefaultTextStyle(
                    style: labelStyle.copyWith(
                      color: selected ? textLuminance(selectedColor) : null,
                    ),
                    child: item.trailing!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  DefaultTextStyle _buildLabelWithDefaultTextStyle(
      TextStyle labelStyle, Color selectedColor, BuildContext context) {
    if (item.section ?? true) {
      final isDarkModeEnabled = MacosTheme.of(context).brightness.isDark;

      return DefaultTextStyle(
        style: labelStyle.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: (labelStyle.fontSize ?? 14.0) * 0.85,
          color: isDarkModeEnabled
              ? MacosColors.white.withValues(alpha: 0.3)
              : MacosColors.black.withValues(alpha: 0.3),
          overflow: TextOverflow.ellipsis,
        ),
        child: item.label,
      );
    }

    return DefaultTextStyle(
      style: labelStyle.copyWith(
        color: selected ? textLuminance(selectedColor) : null,
        overflow: TextOverflow.ellipsis,
      ),
      child: item.label,
    );
  }
}

class _DisclosureSidebarHeaderItem extends StatefulWidget {
  // ignore: use_super_parameters
  const _DisclosureSidebarHeaderItem({
    Key? key,
    required this.item,
    this.selectedItem,
    this.onChanged,
  }) : super(key: key);

  final SidebarItem item;

  final SidebarItem? selectedItem;

  /// A function to perform when the widget is clicked or tapped.
  ///
  /// Typically a [Navigator] call
  final ValueChanged<SidebarItem>? onChanged;

  @override
  __DisclosureSidebarHeaderState createState() =>
      __DisclosureSidebarHeaderState();
}

class __DisclosureSidebarHeaderState extends State<_DisclosureSidebarHeaderItem>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0, end: 0.25);

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late bool _isExpanded;
  bool _isHovering = false;

  bool get hasLeading => widget.item.leading != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));

    _isExpanded = widget.item.expandDisclosureItems;
    if (_isExpanded) {
      _controller.forward();
    }
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    // widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final theme = MacosTheme.of(context);

    final itemSize = _SidebarItemsConfiguration.of(context).itemSize;
    TextStyle? labelStyle;
    switch (itemSize) {
      case SidebarItemSize.small:
        labelStyle = theme.typography.subheadline;
        break;
      case SidebarItemSize.medium:
        labelStyle = theme.typography.body;
        break;
      case SidebarItemSize.large:
        labelStyle = theme.typography.title3;
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
            width: double.infinity,
            child: MouseRegion(
              onEnter: (e) => {
                setState(() {
                  _isHovering = true;
                })
              },
              onExit: (e) => {
                setState(() {
                  _isHovering = false;
                })
              },
              child: _SidebarItem(
                item: SidebarItem(
                  section: true,
                  label: widget.item.label,
                  leading: (hasLeading)
                      ? Padding(
                          padding: const EdgeInsets.all(0),
                          child: MacosIconTheme.merge(
                            data: MacosIconThemeData(size: itemSize.iconSize),
                            child: widget.item.leading!,
                          ),
                        )
                      : null,
                  unselectedColor: MacosColors.transparent,
                  focusNode: widget.item.focusNode,
                  semanticLabel: widget.item.semanticLabel,
                  shape: widget.item.shape,
                  trailing: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (widget.item.trailing != null) widget.item.trailing!,
                      if (_isHovering)
                        RotationTransition(
                          turns: _iconTurns,
                          child: Icon(
                            CupertinoIcons.chevron_right,
                            size: 14.0,
                            color: theme.brightness == Brightness.light
                                ? MacosColors.black.withValues(alpha: 0.3)
                                : MacosColors.white.withValues(alpha: 0.3),
                          ),
                        ),
                    ],
                  ),
                ),
                onClick: _handleTap,
                selected: false,
              ),
            )),
        ClipRect(
          child: DefaultTextStyle(
            style: labelStyle,
            child: Align(
              alignment: Alignment.centerLeft,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final theme = MacosTheme.of(context);

    final bool closed = !_isExpanded && _controller.isDismissed;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.item.disclosureItems!.map((item) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24.0 + theme.visualDensity.horizontal,
              ),
              child: SizedBox(
                width: double.infinity,
                child: _SidebarItem(
                  item: item,
                  onClick: () => widget.onChanged?.call(item),
                  selected: widget.selectedItem == item,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : result,
    );
  }
}

class _DisclosureSidebarItem extends StatefulWidget {
  // ignore: use_super_parameters
  _DisclosureSidebarItem({
    Key? key,
    required this.item,
    this.selectedItem,
    this.onChanged,
  })  : assert(item.disclosureItems != null),
        super(key: key);

  final SidebarItem item;

  final SidebarItem? selectedItem;

  /// A function to perform when the widget is clicked or tapped.
  ///
  /// Typically a [Navigator] call
  final ValueChanged<SidebarItem>? onChanged;

  @override
  __DisclosureSidebarItemState createState() => __DisclosureSidebarItemState();
}

class __DisclosureSidebarItemState extends State<_DisclosureSidebarItem>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.25);

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late bool _isExpanded;

  bool get hasLeading => widget.item.leading != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));

    _isExpanded = widget.item.expandDisclosureItems;
    if (_isExpanded) {
      _controller.forward();
    }
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    // widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final theme = MacosTheme.of(context);
    final double spacing = 10.0 + theme.visualDensity.horizontal;

    final itemSize = _SidebarItemsConfiguration.of(context).itemSize;
    TextStyle? labelStyle;
    switch (itemSize) {
      case SidebarItemSize.small:
        labelStyle = theme.typography.subheadline;
        break;
      case SidebarItemSize.medium:
        labelStyle = theme.typography.body;
        break;
      case SidebarItemSize.large:
        labelStyle = theme.typography.title3;
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: _SidebarItem(
            item: SidebarItem(
              label: widget.item.label,
              leading: Row(
                children: [
                  RotationTransition(
                    turns: _iconTurns,
                    child: Icon(
                      CupertinoIcons.chevron_right,
                      size: 12.0,
                      color: theme.brightness == Brightness.light
                          ? MacosColors.black
                          : MacosColors.white,
                    ),
                  ),
                  if (hasLeading)
                    Padding(
                      padding: EdgeInsets.only(left: spacing),
                      child: MacosIconTheme.merge(
                        data: MacosIconThemeData(size: itemSize.iconSize),
                        child: widget.item.leading!,
                      ),
                    ),
                ],
              ),
              unselectedColor: MacosColors.transparent,
              focusNode: widget.item.focusNode,
              semanticLabel: widget.item.semanticLabel,
              shape: widget.item.shape,
              trailing: widget.item.trailing,
            ),
            onClick: _handleTap,
            selected: false,
          ),
        ),
        ClipRect(
          child: DefaultTextStyle(
            style: labelStyle,
            child: Align(
              alignment: Alignment.centerLeft,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final theme = MacosTheme.of(context);

    final bool closed = !_isExpanded && _controller.isDismissed;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.item.disclosureItems!.map((item) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24.0 + theme.visualDensity.horizontal,
              ),
              child: SizedBox(
                width: double.infinity,
                child: _SidebarItem(
                  item: item,
                  onClick: () => widget.onChanged?.call(item),
                  selected: widget.selectedItem == item,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : result,
    );
  }
}

class _ColorProvider {
  /// Returns the selected color based on the provided parameters.
  static Color getSelectedColor({
    required AccentColor accentColor,
    required bool isDarkModeEnabled,
    required bool isWindowMain,
  }) {
    if (isDarkModeEnabled) {
      if (!isWindowMain) {
        return const MacosColor.fromRGBO(76, 78, 65, 1.0);
      }

      switch (accentColor) {
        case AccentColor.blue:
          return const MacosColor.fromRGBO(22, 105, 229, 0.749);

        case AccentColor.purple:
          return const MacosColor.fromRGBO(204, 45, 202, 0.749);

        case AccentColor.pink:
          return const MacosColor.fromRGBO(229, 74, 145, 0.749);

        case AccentColor.red:
          return const MacosColor.fromRGBO(238, 64, 68, 0.749);

        case AccentColor.orange:
          return const MacosColor.fromRGBO(244, 114, 0, 0.749);

        case AccentColor.yellow:
          return const MacosColor.fromRGBO(233, 176, 0, 0.749);

        case AccentColor.green:
          return const MacosColor.fromRGBO(76, 177, 45, 0.749);

        case AccentColor.graphite:
          return const MacosColor.fromRGBO(129, 129, 122, 0.824);
      }
    }

    if (!isWindowMain) {
      return const MacosColor.fromRGBO(213, 213, 208, 1.0);
    }

    switch (accentColor) {
      case AccentColor.blue:
        return const MacosColor.fromRGBO(9, 129, 255, 0.749);

      case AccentColor.purple:
        return const MacosColor.fromRGBO(162, 28, 165, 0.749);

      case AccentColor.pink:
        return const MacosColor.fromRGBO(234, 81, 152, 0.749);

      case AccentColor.red:
        return const MacosColor.fromRGBO(220, 32, 40, 0.749);

      case AccentColor.orange:
        return const MacosColor.fromRGBO(245, 113, 0, 0.749);

      case AccentColor.yellow:
        return const MacosColor.fromRGBO(240, 180, 2, 0.749);

      case AccentColor.green:
        return const MacosColor.fromRGBO(66, 174, 33, 0.749);

      case AccentColor.graphite:
        return const MacosColor.fromRGBO(174, 174, 167, 0.847);
    }
  }
}
