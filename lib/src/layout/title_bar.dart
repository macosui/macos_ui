import 'package:flutter/widgets.dart';

enum TitleBarSize { large, small }

class TitleBar {
  /// Creates a title bar in the [Scaffold].
  ///
  /// The [size] value includes the padding.
  /// All the values of the [TitleBar] can be null.
  const TitleBar({
    this.alignment,
    this.child,
    this.padding = const EdgeInsets.all(8),
    this.decoration,
    this.size = TitleBarSize.large,
  });

  /// Align the [child] within the [TitleBar].
  ///
  /// Defaults to [Alignment.center].
  ///
  /// If non-null, the [TitleBar] will expand to fill its parent and position its
  /// child within itself according to the given value.
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final Alignment? alignment;

  /// The [child] contained by the container.
  final Widget? child;

  /// The decoration to paint behind the [child].
  final BoxDecoration? decoration;

  /// Empty space to inscribe inside the title bar. The [child], if any, is
  /// placed inside this padding.
  ///
  /// Defaults to `EdgeInsets.all(8)`
  final EdgeInsets padding;

  /// Height of the title bar. This defaults to [TitleBarSize.large]
  final TitleBarSize? size;
}
