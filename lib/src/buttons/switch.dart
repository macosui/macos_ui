import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const _kDefaultBorderColor = CupertinoDynamicColor.withBrightness(
  color: MacosColor.fromRGBO(215, 215, 215, 1.0),
  darkColor: MacosColor.fromRGBO(101, 101, 101, 1.0),
);

const _kDefaultTrackColor = CupertinoDynamicColor.withBrightness(
  color: MacosColor.fromRGBO(228, 226, 228, 1.0),
  darkColor: MacosColor.fromRGBO(66, 66, 66, 1.0),
);

// Dark color might be Color.fromRGBO(255, 255, 255, 0.721)??
const _kDefaultKnobColor = CupertinoDynamicColor.withBrightness(
  color: MacosColors.white,
  darkColor: MacosColor.fromRGBO(207, 207, 207, 1.0),
);

/// {@template macosSwitch}
/// A switch is a control that offers a binary choice between two mutually
/// exclusive states — on and off.
///
/// A switch shows that it's on when the [activeColor] is visible and off when
/// the [trackColor] is visible.
///
/// Additional Reference:
/// * [Toggles (Human Interface Guidelines)](https://developer.apple.com/design/human-interface-guidelines/components/selection-and-input/toggles)
/// * [Toggles (Apple Developer)](https://developer.apple.com/documentation/swiftui/toggle)
/// {@endtemplate}
class MacosSwitch extends StatefulWidget {
  /// {@macro macosSwitch}
  const MacosSwitch({
    super.key,
    required this.value,
    this.size = ControlSize.regular,
    required this.onChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.activeColor,
    this.trackColor,
    this.knobColor,
    this.semanticLabel,
  });

  /// Whether this switch is on or off.
  ///
  /// Must not be null.
  final bool value;

  /// The size of the switch, which is [ControlSize.regular] by default.
  ///
  /// Allowable sizes are [ControlSize.mini], [ControlSize.small], and
  /// [ControlSize.regular]. If [ControlSize.large] is used, the switch will
  /// size itself as a [ControlSize.regular] switch.
  final ControlSize size;

  /// Called when the user toggles with switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// value.
  ///
  /// If null, the switch will be displayed as disabled, which has a reduced opacity.
  ///
  /// The callback provided to onChanged should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// MacosSwitch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool>? onChanged;

  /// {@macro flutter.cupertino.CupertinoSwitch.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// The color to use for the track when this switch is on.
  ///
  /// Defaults to [MacosThemeData.primaryColor] when null.
  final MacosColor? activeColor;

  /// The color to use for track when this switch is off.
  ///
  /// Defaults to [MacosTheme.primaryColor] when null.
  final MacosColor? trackColor;

  /// The color to use for the switch's knob.
  final MacosColor? knobColor;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  @override
  State<MacosSwitch> createState() => _MacosSwitchState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty(
      'checked',
      value: value,
      ifFalse: 'unchecked',
    ));
    properties.add(EnumProperty('size', size));
    properties.add(EnumProperty('dragStartBehavior', dragStartBehavior));
    properties.add(FlagProperty(
      'enabled',
      value: onChanged == null,
      ifFalse: 'disabled',
    ));
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('trackColor', trackColor));
    properties.add(ColorProperty('knobColor', knobColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }
}

class _MacosSwitchState extends State<MacosSwitch>
    with TickerProviderStateMixin {
  late TapGestureRecognizer _tap;
  late HorizontalDragGestureRecognizer _drag;

  late AnimationController _positionController;
  late CurvedAnimation position;

  late AnimationController _reactionController;
  late Animation<double> _reaction;

  bool get isInteractive => widget.onChanged != null;

  // A non-null boolean value that changes to true at the end of a drag if the
  // switch must be animated to the position indicated by the widget's value.
  bool needsPositionAnimation = false;

  @override
  void initState() {
    super.initState();

    _tap = TapGestureRecognizer()
      ..onTapDown = _handleTapDown
      ..onTapUp = _handleTapUp
      ..onTap = _handleTap
      ..onTapCancel = _handleTapCancel;
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..dragStartBehavior = widget.dragStartBehavior;

    _positionController = AnimationController(
      duration: _kToggleDuration,
      value: widget.value ? 1.0 : 0.0,
      vsync: this,
    );
    position = CurvedAnimation(
      parent: _positionController,
      curve: Curves.linear,
    );
    _reactionController = AnimationController(
      duration: _kReactionDuration,
      vsync: this,
    );
    _reaction = CurvedAnimation(
      parent: _reactionController,
      curve: Curves.ease,
    );
  }

  @override
  void didUpdateWidget(MacosSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    _drag.dragStartBehavior = widget.dragStartBehavior;

    if (needsPositionAnimation || oldWidget.value != widget.value) {
      _resumePositionAnimation(isLinear: needsPositionAnimation);
    }
  }

  // `isLinear` must be true if the position animation is trying to move the
  // knob to the closest end after the most recent drag animation, so the curve
  // does not change when the controller's value is not 0 or 1.
  //
  // It can be set to false when it's an implicit animation triggered by
  // widget.value changes.
  void _resumePositionAnimation({bool isLinear = true}) {
    needsPositionAnimation = false;
    position
      ..curve = isLinear ? Curves.linear : Curves.ease
      ..reverseCurve = isLinear ? Curves.linear : Curves.ease.flipped;
    if (widget.value) {
      _positionController.forward();
    } else {
      _positionController.reverse();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (isInteractive) {
      needsPositionAnimation = false;
    }
    _reactionController.forward();
  }

  void _handleTap() {
    if (isInteractive) {
      widget.onChanged!(!widget.value);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (isInteractive) {
      needsPositionAnimation = false;
      _reactionController.reverse();
    }
  }

  void _handleTapCancel() {
    if (isInteractive) {
      _reactionController.reverse();
    }
  }

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) {
      needsPositionAnimation = false;
      _reactionController.forward();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      position
        ..curve = Curves.linear
        ..reverseCurve = Curves.linear;
      final double delta = details.primaryDelta! / widget.size.trackInnerLength;
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          _positionController.value -= delta;
          break;
        case TextDirection.ltr:
          _positionController.value += delta;
          break;
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    // Deferring the animation to the next build phase.
    setState(() => needsPositionAnimation = true);
    // Call onChanged when the user's intent to change value is clear.
    if (position.value >= 0.5 != widget.value) {
      widget.onChanged!(!widget.value);
    }
    _reactionController.reverse();
  }

  @override
  void dispose() {
    _tap.dispose();
    _drag.dispose();

    _positionController.dispose();
    _reactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final MacosThemeData theme = MacosTheme.of(context);
    MacosColor borderColor =
        MacosDynamicColor.resolve(_kDefaultBorderColor, context).toMacosColor();
    final resolvedActiveColor = MacosDynamicColor.resolve(
      widget.activeColor ?? theme.primaryColor,
      context,
    );
    MacosColor activeColor = MacosColor.fromRGBO(
      (resolvedActiveColor.r * 255).toInt(),
      (resolvedActiveColor.g * 255).toInt(),
      (resolvedActiveColor.b * 255).toInt(),
      resolvedActiveColor.a,
    );
    MacosColor trackColor = widget.trackColor ??
        MacosDynamicColor.resolve(_kDefaultTrackColor, context).toMacosColor();
    MacosColor knobColor = widget.knobColor ??
        MacosDynamicColor.resolve(_kDefaultKnobColor, context).toMacosColor();

    // Shot in the dark to try and get the border color correct for each
    // possible color
    if (widget.value) {
      if (theme.brightness.isDark) {
        borderColor.computeLuminance() > 0.5
            ? borderColor = MacosColor.darken(activeColor, 20)
            : borderColor = MacosColor.lighten(activeColor, 20);
      } else {
        borderColor.computeLuminance() > 0.5
            ? borderColor = MacosColor.darken(activeColor, 20)
            : borderColor = MacosColor.lighten(activeColor, 20);
      }
    }

    return Semantics(
      label: widget.semanticLabel,
      checked: widget.value,
      child: _MacosSwitchRenderObjectWidget(
        value: widget.value,
        size: widget.size,
        activeColor: activeColor,
        trackColor: trackColor,
        knobColor: knobColor,
        borderColor: borderColor,
        onChanged: widget.onChanged,
        textDirection: Directionality.of(context),
        state: this,
      ),
    );
  }
}

class _MacosSwitchRenderObjectWidget extends LeafRenderObjectWidget {
  const _MacosSwitchRenderObjectWidget({
    required this.value,
    required this.size,
    required this.activeColor,
    required this.trackColor,
    required this.knobColor,
    required this.borderColor,
    required this.onChanged,
    required this.textDirection,
    required this.state,
  });
  final bool value;
  final ControlSize size;
  final MacosColor activeColor;
  final MacosColor trackColor;
  final MacosColor knobColor;
  final MacosColor borderColor;
  final ValueChanged<bool>? onChanged;
  final TextDirection textDirection;
  final _MacosSwitchState state;

  @override
  _RenderMacosSwitch createRenderObject(BuildContext context) {
    return _RenderMacosSwitch(
      value: value,
      size: size,
      activeColor: activeColor,
      trackColor: trackColor,
      knobColor: knobColor,
      borderColor: borderColor,
      onChanged: onChanged,
      textDirection: textDirection,
      state: state,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMacosSwitch renderObject,
  ) {
    assert(renderObject._state == state);
    renderObject
      ..value = value
      ..controlSize = size
      ..activeColor = activeColor
      ..trackColor = trackColor
      ..knobColor = knobColor
      ..borderColor = borderColor
      ..onChanged = onChanged
      ..textDirection = textDirection;
  }
}

const Size _kMiniTrackSize = Size(26.0, 15.0);
const Size _kSmallTrackSize = Size(32.0, 18.0);
const Size _kRegularTrackSize = Size(38.0, 22.0);

const double _kMiniKnobSize = 13.0;
const double _kSmallKnobSize = 16.0;
const double _kRegularKnobSize = 20.0;

// Shortcuts for details about how to create the switch, based on the control
// size.
extension _ControlSizeX on ControlSize {
  Size get trackSize {
    switch (this) {
      case ControlSize.mini:
        return _kMiniTrackSize;
      case ControlSize.small:
        return _kSmallTrackSize;
      default:
        return _kRegularTrackSize;
    }
  }

  double get knobSize {
    switch (this) {
      case ControlSize.mini:
        return _kMiniKnobSize;
      case ControlSize.small:
        return _kSmallKnobSize;
      default:
        return _kRegularKnobSize;
    }
  }

  double get knobRadius => knobSize / 2.0;
  double get trackInnerStart => trackSize.height / 2.0;
  double get trackInnerEnd => trackSize.width - trackInnerStart;
  double get trackInnerLength => trackInnerEnd - trackInnerStart;
}

const Duration _kReactionDuration = Duration(milliseconds: 400);
const Duration _kToggleDuration = Duration(milliseconds: 300);

class _RenderMacosSwitch extends RenderConstrainedBox {
  _RenderMacosSwitch({
    required bool value,
    required ControlSize size,
    required MacosColor activeColor,
    required MacosColor trackColor,
    required MacosColor knobColor,
    required MacosColor borderColor,
    required ValueChanged<bool>? onChanged,
    required TextDirection textDirection,
    required _MacosSwitchState state,
  })  : _value = value,
        _size = size,
        _activeColor = activeColor,
        _trackColor = trackColor,
        _knobPainter = MacosSwitchKnobPainter(color: knobColor),
        _borderColor = borderColor,
        _onChanged = onChanged,
        _textDirection = textDirection,
        _state = state,
        super(
          additionalConstraints: BoxConstraints.tightFor(
            width: size.trackSize.width,
            height: size.trackSize.height,
          ),
        ) {
    state.position.addListener(markNeedsPaint);
    state._reaction.addListener(markNeedsPaint);
  }

  final _MacosSwitchState _state;

  bool get value => _value;
  bool _value;
  set value(bool newValue) {
    if (newValue == _value) {
      return;
    }
    _value = newValue;
    markNeedsSemanticsUpdate();
  }

  ControlSize get controlSize => _size;
  ControlSize _size;
  set controlSize(ControlSize value) {
    if (value == _size) {
      return;
    }
    _size = value;
    markNeedsPaint();
  }

  MacosColor get activeColor => _activeColor;
  MacosColor _activeColor;
  set activeColor(MacosColor value) {
    if (value == _activeColor) {
      return;
    }
    _activeColor = value;
    markNeedsPaint();
  }

  MacosColor get trackColor => _trackColor;
  MacosColor _trackColor;
  set trackColor(MacosColor value) {
    if (value == _trackColor) {
      return;
    }
    _trackColor = value;
    markNeedsPaint();
  }

  MacosColor get knobColor => _knobPainter.color;
  MacosSwitchKnobPainter _knobPainter;
  set knobColor(MacosColor value) {
    if (value == knobColor) {
      return;
    }
    _knobPainter = MacosSwitchKnobPainter(color: value);
    markNeedsPaint();
  }

  MacosColor get borderColor => _borderColor;
  MacosColor _borderColor;
  set borderColor(MacosColor value) {
    if (value == borderColor) {
      return;
    }
    _borderColor = value;
    markNeedsPaint();
  }

  ValueChanged<bool>? get onChanged => _onChanged;
  ValueChanged<bool>? _onChanged;
  set onChanged(ValueChanged<bool>? value) {
    if (value == _onChanged) {
      return;
    }
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) {
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (value == _textDirection) {
      return;
    }
    _textDirection = value;
    markNeedsPaint();
  }

  bool get isInteractive => onChanged != null;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && isInteractive) {
      _state._drag.addPointer(event);
      _state._tap.addPointer(event);
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    if (isInteractive) {
      config.onTap = _state._handleTap;
    }

    config.isEnabled = isInteractive;
    config.isToggled = _value;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    final double currentValue = _state.position.value;
    final trackSize = controlSize.trackSize;
    final innerStart = controlSize.trackInnerStart;
    final innerEnd = controlSize.trackInnerEnd;

    final double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    final Paint paint = Paint()
      ..color = MacosColor.lerp(trackColor, activeColor, currentValue);

    final Rect trackRect = Rect.fromLTWH(
      offset.dx + (size.width - trackSize.width) / 2.0,
      offset.dy + (size.height - trackSize.height) / 2.0,
      trackSize.width,
      trackSize.height,
    );
    final RRect trackRRect = RRect.fromRectAndRadius(
      trackRect,
      Radius.circular(trackSize.height / 2.0),
    );
    canvas.drawRRect(trackRRect, paint);
    canvas.drawRRect(
      trackRRect,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke,
    );

    final double knobLeft = lerpDouble(
      trackRect.left + innerStart - controlSize.knobRadius,
      trackRect.left + innerEnd - controlSize.knobRadius,
      visualPosition,
    )!;
    final double knobRight = lerpDouble(
      trackRect.left + innerStart + controlSize.knobRadius,
      trackRect.left + innerEnd + controlSize.knobRadius,
      visualPosition,
    )!;
    final double knobCenterY = offset.dy + size.height / 2.0;
    final Rect knobBounds = Rect.fromLTRB(
      knobLeft,
      knobCenterY - controlSize.knobRadius,
      knobRight,
      knobCenterY + controlSize.knobRadius,
    );

    _clipRRectLayer.layer = context.pushClipRRect(
      needsCompositing,
      Offset.zero,
      knobBounds,
      trackRRect,
      (PaintingContext innerContext, Offset offset) {
        _knobPainter.paint(
          innerContext.canvas,
          knobBounds,
          visualPosition == 1.0,
        );
      },
      oldLayer: _clipRRectLayer.layer,
    );
  }

  final LayerHandle<ClipRRectLayer> _clipRRectLayer =
      LayerHandle<ClipRRectLayer>();

  @override
  void dispose() {
    _clipRRectLayer.layer = null;
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(FlagProperty(
      'value',
      value: value,
      ifTrue: 'checked',
      ifFalse: 'unchecked',
      showName: true,
    ));
    description.add(FlagProperty(
      'isInteractive',
      value: isInteractive,
      ifTrue: 'enabled',
      ifFalse: 'disabled',
      showName: true,
      defaultValue: true,
    ));
  }
}

const List<BoxShadow> _kSwitchOffBoxShadows = <BoxShadow>[
  BoxShadow(
    color: Color(0x26000000),
    // offset: Offset(1, 1),
    blurRadius: 8.0,
    blurStyle: BlurStyle.inner,
  ),
  BoxShadow(
    color: Color(0x0F000000),
    // offset: Offset(1, 1),
    blurRadius: 1.0,
    blurStyle: BlurStyle.inner,
  ),
];

const List<BoxShadow> _kSwitchOnBoxShadows = <BoxShadow>[
  BoxShadow(
    color: Color(0x26000000),
    // offset: Offset(-3, 1),
    blurRadius: 8.0,
    blurStyle: BlurStyle.inner,
  ),
  BoxShadow(
    color: Color(0x0F000000),
    // offset: Offset(-1, 1),
    blurRadius: 1.0,
    blurStyle: BlurStyle.inner,
  ),
];

/// Paints a macOS-style switch knob.
///
/// Used by [MacosSwitch].
class MacosSwitchKnobPainter {
  /// Creates an object that paints a macOS-style switch knob.
  const MacosSwitchKnobPainter({required this.color});

  /// The color of the interior of the knob.
  final MacosColor color;

  /// Paints the knob onto the given canvas in the given rectangle.
  void paint(Canvas canvas, Rect rect, bool isOn) {
    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(rect.shortestSide / 2.0),
    );

    if (isOn) {
      for (final BoxShadow shadow in _kSwitchOnBoxShadows) {
        canvas.drawRRect(rrect.shift(shadow.offset), shadow.toPaint());
      }
    } else {
      for (final BoxShadow shadow in _kSwitchOffBoxShadows) {
        canvas.drawRRect(rrect.shift(shadow.offset), shadow.toPaint());
      }
    }

    canvas.drawRRect(rrect, Paint()..color = color);
  }
}
