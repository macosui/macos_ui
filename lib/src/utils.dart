import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// Asserts that the given context has a [MacosTheme] ancestor.
///
/// To call this function, use the following pattern, typically in the
/// relevant Widget's build method:
///
/// ```dart
/// assert(debugCheckHasMacosTheme(context));
/// ```
///
/// Does nothing if asserts are disabled. Always returns true.
bool debugCheckHasMacosTheme(BuildContext context, [bool check = true]) {
  assert(() {
    if (MacosTheme.maybeOf(context) == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('A MacosTheme widget is necessary to draw this layout.'),
        ErrorHint(
          'To introduce a MacosTheme widget, you can either directly '
          'include one, or use a widget that contains MacosTheme itself, '
          'such as MacosApp',
        ),
        ...context.describeMissingAncestor(expectedAncestorType: MacosTheme),
      ]);
    }
    return true;
  }());
  return true;
}

Color textLuminance(Color backgroundColor) {
  return backgroundColor.computeLuminance() >= 0.5
      ? CupertinoColors.black
      : CupertinoColors.white;
}

Color helpIconLuminance(Color backgroundColor, bool isDark) {
  return !isDark
      ? backgroundColor.computeLuminance() > 0.5
          ? CupertinoColors.black
          : CupertinoColors.white
      : backgroundColor.computeLuminance() < 0.5
          ? CupertinoColors.black
          : CupertinoColors.white;
}

Color iconLuminance(Color backgroundColor, bool isDark) {
  if (isDark) {
    return backgroundColor.computeLuminance() > 0.5
        ? CupertinoColors.black
        : CupertinoColors.white;
  } else {
    return backgroundColor.computeLuminance() > 0.5
        ? CupertinoColors.black
        : CupertinoColors.white;
  }
}

String intToMonthAbbr(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      throw Exception('Unsupported value');
  }
}

class Unsupported {
  const Unsupported(this.message);

  final String message;
}
