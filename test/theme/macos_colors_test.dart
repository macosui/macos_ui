import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  test('MacosColors lerp', () {
    expect(
      MacosColor.lerp(MacosColors.appleBlue, MacosColors.appleRed, 1),
      MacosColors.appleRed,
    );
  });

  test('MacosColor.fromRGBO produces the correct RGB values', () {
    const MacosColor color = MacosColor.fromRGBO(79, 72, 75, 1.0);
    expect(color.red, 79);
    expect(color.green, 72);
    expect(color.blue, 75);
  });
}
