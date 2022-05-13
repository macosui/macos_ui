---
id: installation
title: Manual Installation
sidebar_position: 2
---

How to add `macos_ui` to your `pubspec.yaml` file

### Depend on it

To add `macos_ui` to your Flutter application you must include it to your `pubspec.yaml` file. You can do this by running the following command at the root of your application directory:

```sh title="terminal"
$ flutter pub add macos_ui
```

This will add a line like this to your package's `pubspec.yaml` (and run an implicit `flutter pub get`):

```yaml title="pubspec.yaml"
dependencies:
  macos_ui: ^1.2.0
```

It is recommended to use this method of adding `macos_ui` to your `pubspec.yaml` because it will ensure that you get the most recently published version.

### Import it

Now in your Dart code, you can use:

```dart
import 'package:macos_ui/macos_ui.dart';
```

Congratulations! You've now added `macos_ui` to your application. Let's move on to a codelab that will introduce some basic concepts.