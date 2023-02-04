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
    this.thickness = 6,
    this.thicknessWhileDraggingOrHovering = 9,
    this.radius = const Radius.circular(25),
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
  /// Defaults to 6.
  final double thickness;

  /// The thickness of the scrollbar in the cross axis of the scrollable while
  /// the mouse cursor is hovering over and/or dragging the scrollbar.
  ///
  /// Defaults to 9.
  final double thicknessWhileDraggingOrHovering;

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

    return _RawMacosScrollBar(
      controller: controller,
      thumbVisibility: thumbVisibility ?? scrollbarTheme.thumbVisibility,
      thickness: thickness,
      thicknessWhileDraggingOrHovering: thicknessWhileDraggingOrHovering,
      notificationPredicate: notificationPredicate,
      scrollbarOrientation: scrollbarOrientation,
      effectiveThumbColor: scrollbarTheme.thumbColor!,
      radius: radius,
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
    this.thicknessWhileDraggingOrHovering = 9,
    ScrollNotificationPredicate? notificationPredicate,
    super.scrollbarOrientation,
    required this.effectiveThumbColor,
    super.radius,
  })  : assert(thickness != null && thickness < double.infinity),
        assert(thicknessWhileDraggingOrHovering < double.infinity),
        super(
          thumbVisibility: thumbVisibility ?? false,
          fadeDuration: _kScrollbarFadeDuration,
          timeToFade: _kScrollbarTimeToFade,
          notificationPredicate:
              notificationPredicate ?? defaultScrollNotificationPredicate,
        );

  final double thicknessWhileDraggingOrHovering;
  final Color effectiveThumbColor;

  @override
  RawScrollbarState<_RawMacosScrollBar> createState() =>
      _RawMacosScrollBarState();
}

class _RawMacosScrollBarState extends RawScrollbarState<_RawMacosScrollBar> {
  late AnimationController _thicknessAnimationController;
  late AnimationController _colorAnimationController;
  late Animation _colorTween;

  double get _thickness {
    return widget.thickness! +
        _thicknessAnimationController.value *
            (widget.thicknessWhileDraggingOrHovering - widget.thickness!);
  }

  @override
  void initState() {
    super.initState();
    _thicknessAnimationController = AnimationController(
      vsync: this,
      duration: _kScrollbarResizeDuration,
    );
    _colorAnimationController = AnimationController(
      vsync: this,
      duration: _kScrollbarResizeDuration,
    );
    _colorTween = ColorTween(
      begin: MacosColors.transparent,
      end: widget.effectiveThumbColor.withOpacity(.15),
    ).animate(_colorAnimationController);
    _thicknessAnimationController.addListener(() {
      updateScrollbarPainter();
    });
    _colorAnimationController.addListener(() {
      updateScrollbarPainter();
    });
  }

  @override
  void updateScrollbarPainter() {
    scrollbarPainter
      ..color = widget.effectiveThumbColor
      ..trackColor = _colorTween.value
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
  void handleThumbPress() {
    if (getScrollbarDirection() == null) {
      return;
    }
    super.handleThumbPress();
    _thicknessAnimationController.forward();
    _colorAnimationController.forward();
  }

  @override
  void handleThumbPressEnd(Offset localPosition, Velocity velocity) {
    final Axis? direction = getScrollbarDirection();
    if (direction == null) {
      return;
    }
    _thicknessAnimationController.reverse();
    _colorAnimationController.reverse();
    super.handleThumbPressEnd(localPosition, velocity);
  }

  @override
  void dispose() {
    _thicknessAnimationController.dispose();
    _colorAnimationController.dispose();
    super.dispose();
  }
}
