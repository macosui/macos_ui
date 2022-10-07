import 'package:macos_ui/src/library.dart';

/// {@template macosTableCell}
/// The configuration that defines a table cell.
/// {@endtemplate}
class MacosTableCell {
  /// {@macro macosTableCell}
  const MacosTableCell({
    required this.child,
  });

  final Widget child;
}
