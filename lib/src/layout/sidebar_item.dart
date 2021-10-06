import 'package:flutter/foundation.dart';

import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const Duration _kExpand = Duration(milliseconds: 200);
const ShapeBorder _defaultShape = const RoundedRectangleBorder(
  borderRadius: const BorderRadius.all(const Radius.circular(7.0)),
);

/// A macOS style navigation-list item intended for use in a [Sidebar]
///
/// See also:
///
///  * [Sidebar], a side bar used alongside [MacosScaffold]
///  * [SidebarItems], the widget that displays [SidebarItem]s vertically
class SidebarItem with Diagnosticable {
  /// Creates a sidebar item.
  const SidebarItem({
    this.leading,
    required this.label,
    this.selectedColor,
    this.unselectedColor,
    this.shape,
    this.focusNode,
    this.semanticLabel,
    this.disclosureItems,
  });

  /// The widget before [label].
  ///
  /// Typically an [Icon]
  final Widget? leading;

  /// Indicates what content this widget represents.
  ///
  /// Typically a [Text]
  final Widget label;

  /// The color to paint this widget as when selected.
  ///
  /// If null, [MacosThemeData.primaryColor] is used.
  final Color? selectedColor;

  /// The color to paint this widget as when unselected.
  ///
  /// Defaults to transparent.
  final Color? unselectedColor;

  /// The [shape] property specifies the outline (border) of the
  /// decoration. The shape must not be null. It's used alonside
  /// [selectedColor].
  final ShapeBorder? shape;

  /// The focus node used by this item.
  final FocusNode? focusNode;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  /// The disclosure items. If null, there will be no disclosure items.
  ///
  /// If non-null and [leading] is null, a local animated icon is created
  final List<SidebarItem>? disclosureItems;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('selectedColor', selectedColor));
    properties.add(ColorProperty('unselectedColor', unselectedColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
    properties.add(IterableProperty<SidebarItem>(
      'disclosure items',
      disclosureItems,
    ));
  }
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
    Key? key,
    required this.currentIndex,
    required this.onChanged,
    required this.items,
    this.scrollController,
    this.selectedColor,
    this.unselectedColor,
    this.shape,
  })  : assert(currentIndex >= 0),
        super(key: key);

  /// The [SidebarItem]s used by the sidebar. If no items are provided,
  /// the sidebar is not rendered.
  final List<SidebarItem> items;

  /// The current selected index. It must be in the range of 0 to
  /// [items.length]
  final int currentIndex;

  /// Called when the current selected index should be changed.
  final ValueChanged<int> onChanged;

  /// The scroll controller used by this sidebar. If null, a local scroll
  /// controller is created.
  final ScrollController? scrollController;

  /// The color to paint the item iwhen it's selected.
  ///
  /// If null, [MacosThemeData.primaryColor] is used.
  final Color? selectedColor;

  /// The color to paint the item when it's unselected.
  ///
  /// Defaults to transparent.
  final Color? unselectedColor;

  /// The [shape] property specifies the outline (border) of the
  /// decoration. The shape must not be null. It's used alonside
  /// [selectedColor].
  final ShapeBorder? shape;

  List<SidebarItem> get _allItems {
    List<SidebarItem> result = [];
    items.forEach((element) {
      if (element.disclosureItems != null) {
        result.addAll(element.disclosureItems!);
      } else {
        result.add(element);
      }
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return SizedBox.shrink();
    assert(debugCheckHasMacosTheme(context));
    assert(currentIndex < _allItems.length);
    final theme = MacosTheme.of(context);
    return IconTheme.merge(
      data: const IconThemeData(size: 20),
      child: _SidebarItemsConfiguration(
        selectedColor: selectedColor ?? theme.primaryColor,
        unselectedColor: unselectedColor ?? MacosColors.transparent,
        shape: shape ?? _defaultShape,
        child: ListView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.all(10.0 - theme.visualDensity.horizontal),
          children: List.generate(items.length, (index) {
            final item = items[index];
            if (item.disclosureItems != null) {
              return _DisclosureSidebarItem(
                item: item,
                selectedItem: _allItems[currentIndex],
                onChanged: (item) {
                  onChanged(_allItems.indexOf(item));
                },
              );
            }
            return _SidebarItem(
              item: item,
              selected: _allItems[currentIndex] == item,
              onClick: () => onChanged(_allItems.indexOf(item)),
            );
          }),
        ),
      ),
    );
  }
}

class _SidebarItemsConfiguration extends InheritedWidget {
  const _SidebarItemsConfiguration({
    Key? key,
    required this.child,
    this.selectedColor = MacosColors.transparent,
    this.unselectedColor = MacosColors.transparent,
    this.shape = _defaultShape,
  }) : super(key: key, child: child);

  final Widget child;

  final Color selectedColor;
  final Color unselectedColor;
  final ShapeBorder shape;

  static _SidebarItemsConfiguration of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SidebarItemsConfiguration>()!;
  }

  @override
  bool updateShouldNotify(_SidebarItemsConfiguration oldWidget) {
    return true;
  }
}

/// A macOS style navigation-list item intended for use in a [Sidebar]
class _SidebarItem extends StatelessWidget {
  /// Builds a [_SidebarItem].
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

  void _handleActionTap() async {
    onClick?.call();
  }

  Map<Type, Action<Intent>> get _actionMap => <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (ActivateIntent intent) => _handleActionTap(),
        ),
        ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
          onInvoke: (ButtonActivateIntent intent) => _handleActionTap(),
        ),
      };

  bool get hasLeading => item.leading != null;

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
          mouseCursor: SystemMouseCursors.click,
          actions: _actionMap,
          child: Container(
            width: 134.0 + theme.visualDensity.horizontal,
            height: 38.0 + theme.visualDensity.vertical,
            decoration: ShapeDecoration(
              color: selected ? selectedColor : unselectedColor,
              shape: item.shape ?? _SidebarItemsConfiguration.of(context).shape,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 7 + theme.visualDensity.horizontal,
              horizontal: spacing,
            ),
            child: Row(children: [
              if (hasLeading)
                Padding(
                  padding: EdgeInsets.only(right: spacing),
                  child: IconTheme.merge(
                    data: IconThemeData(
                      color: selected
                          ? MacosColors.white
                          : CupertinoColors.systemBlue,
                    ),
                    child: item.leading!,
                  ),
                ),
              DefaultTextStyle(
                style: theme.typography.title3.copyWith(
                  color: selected ? textLuminance(selectedColor) : null,
                ),
                child: item.label,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _DisclosureSidebarItem extends StatefulWidget {
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
  static Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.25);

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    // widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final theme = MacosTheme.of(context);

    final double spacing = 10.0 + theme.visualDensity.horizontal;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: _SidebarItem(
            item: SidebarItem(
              label: widget.item.label,
              leading: Row(children: [
                if (widget.item.leading != null)
                  Padding(
                    padding: EdgeInsets.only(right: spacing),
                    child: widget.item.leading!,
                  ),
                RotationTransition(
                  turns: _iconTurns,
                  child: Icon(
                    CupertinoIcons.chevron_right,
                    color: theme.brightness == Brightness.light
                        ? MacosColors.black
                        : MacosColors.white,
                  ),
                ),
              ]),
              unselectedColor: MacosColors.transparent,
              focusNode: widget.item.focusNode,
              semanticLabel: widget.item.semanticLabel,
              shape: widget.item.shape,
            ),
            onClick: _handleTap,
            selected: false,
          ),
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            heightFactor: _heightFactor.value,
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final theme = MacosTheme.of(context);

    final bool closed = !_isExpanded && _controller.isDismissed;

    final Widget result = Offstage(
      child: TickerMode(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.item.disclosureItems!.map((e) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24.0 + theme.visualDensity.horizontal,
              ),
              child: SizedBox(
                width: double.infinity,
                child: _SidebarItem(
                  item: e,
                  onClick: () {
                    widget.onChanged?.call(e);
                  },
                  selected: widget.selectedItem == e,
                ),
              ),
            );
          }).toList(),
        ),
        enabled: !closed,
      ),
      offstage: closed,
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : result,
    );
  }
}
