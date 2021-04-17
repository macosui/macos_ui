library macos_ui;

export 'package:flutter/cupertino.dart'
    show CupertinoColors, CupertinoDynamicColor;
export 'package:flutter/material.dart'
    show
        Brightness,
        ThemeMode,
        Feedback,
        DefaultMaterialLocalizations,
        PageTransitionsBuilder,
        FlutterLogo,
        CircleAvatar;

/// todo: package-level docs
export 'package:flutter/widgets.dart' hide Icon, IconTheme, TextBox;

export 'src/buttons/switch.dart';
export 'src/indicators/progress_indicators.dart';
export 'src/layout/scaffold.dart';
export 'src/macos_app.dart';
export 'src/styles/macos_theme.dart';
export 'src/styles/macos_theme_data.dart';
export 'src/styles/typography.dart';
export 'src/util.dart';
