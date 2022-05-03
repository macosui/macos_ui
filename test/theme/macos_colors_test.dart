import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  test('MacosColors lerp', () {
    expect(
      MacosColor.lerp(MacosColors.appleBlue, MacosColors.appleRed, 1),
      MacosColors.appleRed,
    );
  });
}
