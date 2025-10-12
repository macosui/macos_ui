import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('typography equality 1', (tester) async {
    final typography1 = Typography();
    final typography2 = Typography();

    expect(typography1, equals(typography2));
  });

  testWidgets('typography equality 2', (tester) async {
    final typography1 = Typography(
      black: const TextTheme(bodyLarge: TextStyle(fontSize: 10)),
    );
    final typography2 = Typography(
      black: const TextTheme(bodyLarge: TextStyle(fontSize: 12)),
    );

    expect(typography1, isNot(equals(typography2)));
  });

  testWidgets('typography equality 3', (tester) async {
    final typography1 = Typography(
      englishLike: const TextTheme(
        bodyLarge: TextStyle(fontSize: 10),
      ),
    );
    final typography2 = Typography(
      englishLike: const TextTheme(
        bodyLarge: TextStyle(fontSize: 10),
      ),
    );

    expect(typography1, equals(typography2));
  });

  testWidgets('typography equality 4', (tester) async {
    final typography1 = Typography(
      englishLike: const TextTheme(
        bodyLarge: TextStyle(fontSize: 10),
      ),
    );
    final typography2 = Typography(
      englishLike: const TextTheme(
        bodyLarge: TextStyle(fontSize: 12),
      ),
    );

    expect(typography1, isNot(equals(typography2)));
  });

  testWidgets('typography equality 5', (tester) async {
    final typography1 = Typography(
      englishLike: const TextTheme(
        headlineLarge: TextStyle(fontSize: 10),
      ),
    );
    final typography2 = Typography(
      englishLike: const TextTheme(
        headlineLarge: TextStyle(fontSize: 12),
      ),
    );

    expect(typography1, isNot(equals(typography2)));
  });

  testWidgets('typography equality 6', (tester) async {
    final typography1 = Typography(
      englishLike: const TextTheme(
        headlineLarge: TextStyle(fontSize: 10),
      ),
    );
    final typography2 = Typography(
      englishLike: const TextTheme(
        headlineLarge: TextStyle(fontSize: 10),
      ),
    );

    expect(typography1, equals(typography2));
  });
}
