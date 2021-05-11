# Theming with macos_ui

Theming with `macos_ui` should feel very familiar to developers who are used to theming using the
`material` library. `macos_ui` has `MacosTheme` and `MacosThemeData` classes, and widgets have
corresponding `{Widget}ThemeData` classes.

In order for your widgets to be properly themed you must use a `MacosTheme` class above them. It is
recommended that this be done at the `MacosApp` level, using the `theme` and `darkTheme` properties.
If unused, the default light/dark themes will be implicitly used.

Below are some examples of `MacosTheme` and `MacosThemeData` in action.

### Explicitly using the default themes
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'macos_ui example',
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
}
```

### Implicitly using the default themes
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'macos_ui example',
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
}
```

### Explicitly using custom themes
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'macos_ui example',
      theme: MacosThemeData(
        brightness: Brightness.light,
        // Set light theme properties here
      ),
      darkTheme: MacosThemeData(
        brightness: Brightness.dark,
        // Set dark theme properties here
      ),
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
}
```