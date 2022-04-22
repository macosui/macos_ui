import 'package:flutter/foundation.dart';
import 'package:macos_ui/src/library.dart';

class TooltipThemeData with Diagnosticable {
  const TooltipThemeData({
    this.height,
    this.verticalOffset,
    this.padding,
    this.margin,
    this.preferBelow,
    this.decoration,
    this.showDuration,
    this.waitDuration,
    this.textStyle,
  });

  /// Creates a default tooltip theme.
  ///
  /// [textStyle] is usually [MacosTypography.caption2]
  factory TooltipThemeData.standard({
    required Brightness brightness,
    required TextStyle textStyle,
  }) {
    return TooltipThemeData(
      height: 32.0,
      verticalOffset: 24.0,
      preferBelow: false,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      waitDuration: const Duration(seconds: 1),
      textStyle: textStyle,
      decoration: () {
        const radius = BorderRadius.zero;
        final shadow = kElevationToShadow[4];
        if (brightness == Brightness.light) {
          return BoxDecoration(
            color: CupertinoColors.systemGrey6.color,
            borderRadius: radius,
            boxShadow: shadow,
          );
        } else {
          return BoxDecoration(
            color: CupertinoColors.systemGrey6.darkColor,
            borderRadius: radius,
            boxShadow: shadow,
          );
        }
      }(),
    );
  }

  /// Copy this tooltip with [style]
  TooltipThemeData copyWith({
    Decoration? decoration,
    double? height,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    bool? preferBelow,
    Duration? showDuration,
    TextStyle? textStyle,
    double? verticalOffset,
    Duration? waitDuration,
  }) {
    return TooltipThemeData(
      decoration: decoration ?? this.decoration,
      height: height ?? this.height,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      preferBelow: preferBelow ?? this.preferBelow,
      showDuration: showDuration ?? this.showDuration,
      textStyle: textStyle ?? this.textStyle,
      verticalOffset: verticalOffset ?? this.verticalOffset,
      waitDuration: waitDuration ?? this.waitDuration,
    );
  }

  /// The height of the tooltip's [child].
  ///
  /// If the [child] is null, then this is the tooltip's intrinsic height.
  final double? height;

  /// The vertical gap between the widget and the displayed tooltip.
  ///
  /// When [preferBelow] is set to true and tooltips have sufficient space
  /// to display themselves, this property defines how much vertical space
  /// tooltips will position themselves under their corresponding widgets.
  /// Otherwise, tooltips will position themselves above their corresponding
  /// widgets with the given offset.
  final double? verticalOffset;

  /// The amount of space by which to inset the tooltip's [child].
  ///
  /// Defaults to 10.0 logical pixels in each direction.
  final EdgeInsetsGeometry? padding;

  /// The empty space that surrounds the tooltip.
  ///
  /// Defines the tooltip's outer [Container.margin]. By default, a long
  /// tooltip will span the width of its window. If long enough, a tooltip
  /// might also span the window's height. This property allows one to define
  /// how much space the tooltip must be inset from the edges of their display
  /// window.
  final EdgeInsetsGeometry? margin;

  /// Whether the tooltip defaults to being displayed below the widget.
  ///
  /// Defaults to true. If there is insufficient space to display the tooltip
  /// in the preferred direction, the tooltip will be displayed in the opposite
  /// direction.
  final bool? preferBelow;

  /// Specifies the tooltip's shape and background color.
  ///
  /// The tooltip shape defaults to a rounded rectangle with a border radius of 4.0.
  /// Tooltips will also default to an opacity of 90% and with the color [CupertinoColors.systemGrey]
  /// if [ThemeData.brightness] is [Brightness.dark], and [CupertinoColors.white] if
  /// it is [Brightness.light].
  final Decoration? decoration;

  /// The length of time that a pointer must hover over a tooltip's widget before
  /// the tooltip will be shown.
  ///
  /// Once the pointer leaves the widget, the tooltip will immediately disappear.
  ///
  /// Defaults to 0 milliseconds (tooltips are shown immediately upon hover).
  final Duration? waitDuration;

  /// The length of time that the tooltip will be shown after a long press is released.
  ///
  /// If on desktop, defaults to 10 seconds, otherwise, defaults to 1.5 seconds.
  final Duration? showDuration;

  /// The style to use for the message of the tooltip.
  ///
  /// If null, [MacosTypography.caption] is used
  final TextStyle? textStyle;

  /// Linearly interpolate between two tooltip themes.
  ///
  /// All the properties must be non-null.
  static TooltipThemeData lerp(
    TooltipThemeData a,
    TooltipThemeData b,
    double t,
  ) {
    return TooltipThemeData(
      decoration: Decoration.lerp(a.decoration, b.decoration, t),
      height: t < 0.5 ? a.height : b.height,
      margin: EdgeInsetsGeometry.lerp(a.margin, b.margin, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      preferBelow: t < 0.5 ? a.preferBelow : b.preferBelow,
      showDuration: t < 0.5 ? a.showDuration : b.showDuration,
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      verticalOffset: t < 0.5 ? a.verticalOffset : b.verticalOffset,
      waitDuration: t < 0.5 ? a.waitDuration : b.waitDuration,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TooltipThemeData &&
          runtimeType == other.runtimeType &&
          height == other.height &&
          verticalOffset == other.verticalOffset &&
          padding == other.padding &&
          margin == other.margin &&
          preferBelow == other.preferBelow &&
          decoration == other.decoration &&
          waitDuration == other.waitDuration &&
          showDuration == other.showDuration &&
          textStyle == other.textStyle;

  @override
  int get hashCode =>
      height.hashCode ^
      verticalOffset.hashCode ^
      padding.hashCode ^
      margin.hashCode ^
      preferBelow.hashCode ^
      decoration.hashCode ^
      waitDuration.hashCode ^
      showDuration.hashCode ^
      textStyle.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
    properties.add(DoubleProperty('verticalOffset', verticalOffset));
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding),
    );
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin),
    );
    properties.add(FlagProperty(
      'preferBelow',
      value: preferBelow,
      ifFalse: 'prefer above',
    ));
    properties.add(DiagnosticsProperty<Decoration>('decoration', decoration));
    properties.add(DiagnosticsProperty<Duration>('waitDuration', waitDuration));
    properties.add(DiagnosticsProperty<Duration>('showDuration', showDuration));
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
  }

  TooltipThemeData merge(TooltipThemeData? other) {
    if (other == null) return this;
    return copyWith(
      decoration: other.decoration,
      height: other.height,
      margin: other.margin,
      padding: other.padding,
      preferBelow: other.preferBelow,
      showDuration: other.showDuration,
      textStyle: other.textStyle,
      verticalOffset: other.verticalOffset,
      waitDuration: other.waitDuration,
    );
  }
}
