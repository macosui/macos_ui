import 'package:flutter/physics.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const _kSheetBorderRadius = BorderRadius.all(Radius.circular(12.0));
const EdgeInsets _defaultInsetPadding =
    EdgeInsets.symmetric(horizontal: 140.0, vertical: 48.0);

/// {@template macosSheet}
/// A modal dialog that’s attached to a particular window and prevents further
/// interaction with the window until the sheet is dismissed.
/// {@endtemplate}
class MacosSheet extends StatelessWidget {
  /// {@macro macosSheet}
  const MacosSheet({
    super.key,
    required this.child,
    this.insetPadding = _defaultInsetPadding,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.backgroundColor,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The amount of padding added to [MediaQueryData.viewInsets] on the outside
  /// of the dialog. This defines the minimum space between the screen's edges
  /// and the dialog.
  final EdgeInsets? insetPadding;

  /// The duration of the animation to show when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  final Duration insetAnimationDuration;

  /// The curve to use for the animation shown when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  final Curve insetAnimationCurve;

  /// The background color for this widget.
  ///
  /// Defaults to
  /// ```dart
  /// brightness.resolve(
  ///   CupertinoColors.systemGrey6.color,
  ///   MacosColors.controlBackgroundColor.darkColor,
  /// )
  /// ```
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final brightness = MacosTheme.brightnessOf(context);

    final outerBorderColor = brightness.resolve(
      Colors.black.withValues(alpha: 0.23),
      Colors.black.withValues(alpha: 0.76),
    );

    final innerBorderColor = brightness.resolve(
      Colors.white.withValues(alpha: 0.45),
      Colors.white.withValues(alpha: 0.15),
    );

    final EdgeInsets effectivePadding =
        MediaQuery.of(context).viewInsets + (insetPadding ?? EdgeInsets.zero);

    return AnimatedPadding(
      padding: effectivePadding,
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ??
              brightness.resolve(
                CupertinoColors.systemGrey6.color,
                MacosColors.controlBackgroundColor.darkColor,
              ),
          borderRadius: _kSheetBorderRadius,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: innerBorderColor,
            ),
            borderRadius: _kSheetBorderRadius,
          ),
          foregroundDecoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: outerBorderColor,
            ),
            borderRadius: _kSheetBorderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Displays a [MacosSheet] above the current application.
Future<T?> showMacosSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = false,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  barrierColor ??= MacosDynamicColor.resolve(
    MacosColors.controlBackgroundColor,
    context,
  ).withValues(alpha: 0.6);

  return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
    _MacosSheetRoute<T>(
      settings: routeSettings,
      pageBuilder: (context, animation, secondaryAnimation) {
        return builder(context);
      },
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel ??
          MaterialLocalizations.of(context).modalBarrierDismissLabel,
    ),
  );
}

class _MacosSheetRoute<T> extends PopupRoute<T> {
  _MacosSheetRoute({
    required RoutePageBuilder pageBuilder,
    bool barrierDismissible = false,
    Color? barrierColor = const Color(0x80000000),
    String? barrierLabel,
    super.settings,
  })  : _pageBuilder = pageBuilder,
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor;

  final RoutePageBuilder _pageBuilder;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  String? get barrierLabel => _barrierLabel;
  final String? _barrierLabel;

  @override
  Color? get barrierColor => _barrierColor;
  final Color? _barrierColor;

  @override
  Curve get barrierCurve => Curves.linear;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 450);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 120);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: _pageBuilder(context, animation, secondaryAnimation),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (animation.status == AnimationStatus.reverse) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutSine,
        ),
        child: child,
      );
    }
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: const _SubtleBounceCurve(),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
        child: child,
      ),
    );
  }
}

class _SubtleBounceCurve extends Curve {
  const _SubtleBounceCurve();

  @override
  double transform(double t) {
    final simulation = SpringSimulation(
      const SpringDescription(
        damping: 14,
        mass: 1.4,
        stiffness: 180,
      ),
      0.0,
      1.0,
      0.1,
    );
    return simulation.x(t) + t * (1 - simulation.x(1.0));
  }
}
