import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const double _kScrollbarMinLength = 36.0;
const double _kScrollbarMinOverscrollLength = 8.0;
const Duration _kScrollbarTimeToFade = Duration(milliseconds: 1200);
const Duration _kScrollbarFadeDuration = Duration(milliseconds: 250);
const Duration _kScrollbarResizeDuration = Duration(milliseconds: 100);
const double _kScrollbarMainAxisMargin = 3.0;
const double _kScrollbarCrossAxisMargin = 3.0;

/// A Macos Design scrollbar.
///
/// To add a scrollbar to a [ScrollView], wrap the scroll view
/// widget in a [MacosScrollbar] widget.
///
/// {@macro flutter.widgets.Scrollbar}
///
/// The color of the Scrollbar will change when dragged. A hover animation is
/// also triggered when used on web and desktop platforms. A scrollbar track
/// can also been drawn when triggered by a hover event, which is controlled by
/// [trackVisibility]. The thickness of the track and scrollbar thumb will
/// become larger when hovering, unless overridden by [hoverThickness].
///
/// See also:
///
///  * [RawScrollbar], a basic scrollbar that fades in and out, extended
///    by this class to add more animations and behaviors.
///  * [MacosScrollbarTheme], which configures the Scrollbar's appearance.
///  * [m.Scrollbar], a Material style scrollbar.
///  * [CupertinoScrollbar], an iOS style scrollbar.
///  * [ListView], which displays a linear, scrollable list of children.
///  * [GridView], which displays a 2 dimensional, scrollable array of children.
class MacosScrollbar extends StatelessWidget {
  /// Creates a macos design scrollbar that by default will connect to the
  /// closest Scrollable descendent of [child].
  ///
  /// The [child] should be a source of [ScrollNotification] notifications,
  /// typically a [Scrollable] widget.
  ///
  /// If the [controller] is null, the default behavior is to
  /// enable scrollbar dragging using the [PrimaryScrollController].
  ///
  /// When null, [thickness] defaults to 8.0 pixels on desktop and web, and 4.0
  /// pixels when on mobile platforms. A null [radius] will result in a default
  /// of an 8.0 pixel circular radius about the corners of the scrollbar thumb,
  /// except for when executing on [TargetPlatform.android], which will render the
  /// thumb without a radius.
  const MacosScrollbar({
    super.key,
    required this.child,
    this.controller,
    this.thumbVisibility,
    this.trackVisibility,
    this.thickness,
    this.radius,
    this.notificationPredicate,
    this.interactive,
    this.scrollbarOrientation,
  });

  /// {@macro flutter.widgets.Scrollbar.child}
  final Widget child;

  /// {@macro flutter.widgets.Scrollbar.controller}
  final ScrollController? controller;

  /// {@macro flutter.widgets.Scrollbar.thumbVisibility}
  final bool? thumbVisibility;

  /// Controls if the track will always be visible or not.
  ///
  /// If this property is null, then [MacosScrollbarThemeData.showTrackOnHover] of
  /// [MacosThemeData.scrollbarTheme] is used. If that is also null, the default value
  /// is false.
  final bool? trackVisibility;

  /// The thickness of the scrollbar in the cross axis of the scrollable.
  ///
  /// If null, the default value is platform dependent. On [TargetPlatform.android],
  /// the default thickness is 4.0 pixels. On [TargetPlatform.iOS],
  /// [CupertinoScrollbar.defaultThickness] is used. The remaining platforms have a
  /// default thickness of 8.0 pixels.
  final double? thickness;

  /// The [Radius] of the scrollbar thumb's rounded rectangle corners.
  ///
  /// If null, the default value is platform dependent. On [TargetPlatform.android],
  /// no radius is applied to the scrollbar thumb. On [TargetPlatform.iOS],
  /// [CupertinoScrollbar.defaultRadius] is used. The remaining platforms have a
  /// default [Radius.circular] of 8.0 pixels.
  final Radius? radius;

  /// {@macro flutter.widgets.Scrollbar.interactive}
  final bool? interactive;

  /// {@macro flutter.widgets.Scrollbar.notificationPredicate}
  final ScrollNotificationPredicate? notificationPredicate;

  /// {@macro flutter.widgets.Scrollbar.scrollbarOrientation}
  final ScrollbarOrientation? scrollbarOrientation;

  /// Default value for [radius] if it's not specified in [CupertinoScrollbar].
  static const Radius defaultRadius = Radius.circular(1.5);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final scrollbarTheme = MacosScrollbarTheme.of(context);

    return _RawMacosScrollBar(
      thumbVisibility: thumbVisibility ?? scrollbarTheme.thumbVisibility,
      controller: controller,
      notificationPredicate: notificationPredicate,
      scrollbarOrientation: scrollbarOrientation,
      effectiveThumbColor: scrollbarTheme.thumbColor!,
      child: child,
    );
  }
}

class _RawMacosScrollBar extends RawScrollbar {
  const _RawMacosScrollBar({
    // super.key,
    required super.child,
    super.controller,
    bool? thumbVisibility,
    double super.thickness = 6,
    this.thicknessWhileDraggingOrHovering = 9,
    ScrollNotificationPredicate? notificationPredicate,
    super.scrollbarOrientation,
    required this.effectiveThumbColor,
  })  : assert(thickness < double.infinity),
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
      ..radius = const Radius.circular(25)
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
