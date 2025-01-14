import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const double _kScrollbarMinLength = 36.0;
const double _kScrollbarMinOverscrollLength = 8.0;
const Duration _kScrollbarTimeToFade = Duration(milliseconds: 1200);
const Duration _kScrollbarFadeDuration = Duration(milliseconds: 250);
const Duration _kScrollbarResizeDuration = Duration(milliseconds: 100);
const double _kScrollbarMainAxisMargin = 3.0;
const double _kScrollbarCrossAxisMargin = 2.0;

/// A macOS-style scrollbar.
///
/// Applications built with `macos_ui` will automatically apply this widget
/// to [ScrollView]s as the default scrollbar.
///
/// To explicitly add a scrollbar to a [ScrollView], wrap the scroll view
/// widget in a [MacosScrollbar] widget.
///
/// {@macro flutter.widgets.Scrollbar}
///
/// See also:
///
///  * [RawScrollbar], a basic scrollbar that fades in and out, extended
///    by this class internally to add animations and behaviors that aim to
///    match the native macOS scrollbar.
///  * [MacosScrollbarTheme], which configures this widget's appearance.
///  * [Scrollbar], a Material style scrollbar.
///  * [CupertinoScrollbar], an iOS style scrollbar.
class MacosScrollbar extends StatelessWidget {
  /// Creates a macOS-style scrollbar that by default will connect to the
  /// closest Scrollable descendant of [child].
  ///
  /// The [child] should be a source of [ScrollNotification] notifications,
  /// typically a [Scrollable] widget.
  ///
  /// If the [controller] is null, the default behavior is to
  /// enable scrollbar dragging using the [PrimaryScrollController].
  const MacosScrollbar({
    super.key,
    required this.child,
    this.controller,
    this.thumbVisibility,
    this.thickness,
    this.thicknessWhileHovering,
    this.radius,
    this.notificationPredicate,
    this.scrollbarOrientation,
  });

  /// {@macro flutter.widgets.Scrollbar.child}
  final Widget child;

  /// {@macro flutter.widgets.Scrollbar.controller}
  final ScrollController? controller;

  /// {@macro flutter.widgets.Scrollbar.thumbVisibility}
  final bool? thumbVisibility;

  /// The thickness of the scrollbar in the cross axis of the scrollable.
  ///
  /// Defaults to 6.0.
  final double? thickness;

  /// The thickness of the scrollbar in the cross axis of the scrollable while
  /// the mouse cursor is hovering over the scrollbar.
  ///
  /// Defaults to 9.0.
  final double? thicknessWhileHovering;

  /// The [Radius] of the scrollbar thumb's rounded rectangle corners.
  ///
  /// Defaults to `const Radius.circular(25)`.
  final Radius? radius;

  /// {@macro flutter.widgets.Scrollbar.notificationPredicate}
  final ScrollNotificationPredicate? notificationPredicate;

  /// {@macro flutter.widgets.Scrollbar.scrollbarOrientation}
  final ScrollbarOrientation? scrollbarOrientation;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final scrollbarTheme = MacosScrollbarTheme.of(context);
    assert(scrollbarTheme.thickness != null);
    assert(scrollbarTheme.thicknessWhileHovering != null);

    return _RawMacosScrollBar(
      controller: controller,
      thumbVisibility: thumbVisibility ?? scrollbarTheme.thumbVisibility,
      thickness: thickness ?? scrollbarTheme.thickness,
      thicknessWhileHovering:
          thicknessWhileHovering ?? scrollbarTheme.thicknessWhileHovering!,
      notificationPredicate: notificationPredicate,
      scrollbarOrientation: scrollbarOrientation,
      effectiveThumbColor: scrollbarTheme.thumbColor!,
      radius: radius ?? scrollbarTheme.radius,
      child: child,
    );
  }
}

class _RawMacosScrollBar extends RawScrollbar {
  const _RawMacosScrollBar({
    required super.child,
    super.controller,
    bool? thumbVisibility,
    super.thickness,
    required this.thicknessWhileHovering,
    ScrollNotificationPredicate? notificationPredicate,
    super.scrollbarOrientation,
    required this.effectiveThumbColor,
    super.radius,
  })  : assert(thickness != null && thickness < double.infinity),
        assert(thicknessWhileHovering < double.infinity),
        super(
          thumbVisibility: thumbVisibility ?? false,
          fadeDuration: _kScrollbarFadeDuration,
          timeToFade: _kScrollbarTimeToFade,
          notificationPredicate:
              notificationPredicate ?? defaultScrollNotificationPredicate,
        );

  final double thicknessWhileHovering;
  final Color effectiveThumbColor;

  @override
  RawScrollbarState<_RawMacosScrollBar> createState() =>
      _RawMacosScrollBarState();
}

class _RawMacosScrollBarState extends RawScrollbarState<_RawMacosScrollBar> {
  late AnimationController _thumbThicknessAnimationController;
  late AnimationController _trackColorAnimationController;
  late Animation _trackColorTween;
  bool _hoverIsActive = false;

  double get _thickness {
    return widget.thickness! +
        _thumbThicknessAnimationController.value *
            (widget.thicknessWhileHovering - widget.thickness!);
  }

  @override
  void initState() {
    super.initState();
    _thumbThicknessAnimationController = AnimationController(
      vsync: this,
      duration: _kScrollbarResizeDuration,
    );
    _trackColorAnimationController = AnimationController(
      vsync: this,
      duration: _kScrollbarResizeDuration,
    );
    _trackColorTween = ColorTween(
      begin: MacosColors.transparent,
      end: widget.effectiveThumbColor.withValues(alpha: 0.15),
    ).animate(_trackColorAnimationController);
    _thumbThicknessAnimationController.addListener(() {
      updateScrollbarPainter();
    });
    _trackColorAnimationController.addListener(() {
      updateScrollbarPainter();
    });
  }

  @override
  void updateScrollbarPainter() {
    scrollbarPainter
      ..color = widget.effectiveThumbColor
      ..trackColor = _trackColorTween.value
      ..textDirection = Directionality.of(context)
      ..thickness = _thickness
      ..mainAxisMargin = _kScrollbarMainAxisMargin
      ..crossAxisMargin = _kScrollbarCrossAxisMargin
      ..radius = widget.radius
      ..padding = MediaQuery.of(context).padding
      ..minLength = _kScrollbarMinLength
      ..minOverscrollLength = _kScrollbarMinOverscrollLength
      ..scrollbarOrientation = widget.scrollbarOrientation;
  }

  @override
  void handleHover(PointerHoverEvent event) {
    super.handleHover(event);
    if (isPointerOverScrollbar(event.position, event.kind, forHover: true)) {
      setState(() => _hoverIsActive = true);
      _thumbThicknessAnimationController.forward();
      _trackColorAnimationController.forward();
    } else if (_hoverIsActive) {
      setState(() => _hoverIsActive = false);
      _thumbThicknessAnimationController.reverse();
      _trackColorAnimationController.reverse();
    }
  }

  @override
  void handleHoverExit(PointerExitEvent event) {
    super.handleHoverExit(event);
    setState(() => _hoverIsActive = false);
    _thumbThicknessAnimationController.reverse();
    _trackColorAnimationController.reverse();
  }

  @override
  void dispose() {
    _thumbThicknessAnimationController.dispose();
    _trackColorAnimationController.dispose();
    super.dispose();
  }
}
