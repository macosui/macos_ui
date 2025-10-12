import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/help_button_theme.dart';
import 'package:macos_ui/src/theme/macos_colors.dart';
import 'package:macos_ui/src/theme/macos_theme.dart';

void main() {
  testWidgets('macos theme MacosThemeData equality 1', (tester) async {
    final macosThemeData1 = MacosThemeData();
    final macosThemeData2 = MacosThemeData();

    expect(macosThemeData1, equals(macosThemeData2));
  });

  testWidgets('macos theme MacosThemeData equality 2', (tester) async {
    final macosThemeData1 = MacosThemeData(brightness: Brightness.dark);
    final macosThemeData2 = MacosThemeData(brightness: Brightness.light);

    expect(macosThemeData1, isNot(equals(macosThemeData2)));
  });

  testWidgets('macos theme MacosThemeData equality 3', (tester) async {
    final macosThemeData1 = MacosThemeData(
        helpButtonTheme: const HelpButtonThemeData(
      color: MacosColors.appleRed,
    ));

    final macosThemeData2 = MacosThemeData(
        helpButtonTheme: const HelpButtonThemeData(
      color: MacosColors.appleGreen,
    ));

    expect(macosThemeData1, isNot(equals(macosThemeData2)));
  });

  testWidgets('macos theme MacosThemeData equality 4', (tester) async {
    final macosThemeData1 = MacosThemeData(
        helpButtonTheme: const HelpButtonThemeData(
      color: MacosColors.appleRed,
    ));

    final macosThemeData2 = MacosThemeData(
        helpButtonTheme: const HelpButtonThemeData(
      color: MacosColors.appleRed,
    ));

    expect(macosThemeData1, equals(macosThemeData2));
  });
}
