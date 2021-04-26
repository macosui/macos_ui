library macos_ui;

/// todo: package-level docs

export 'package:flutter/widgets.dart' hide Icon, IconTheme, TextBox;
export 'package:flutter/material.dart'
    show
        Brightness,
        ThemeMode,
        Feedback,
        DefaultMaterialLocalizations,
        PageTransitionsBuilder,
        FlutterLogo,
        CircleAvatar,
        Scrollbar,
        VerticalDivider,
        Divider;
export 'package:flutter/cupertino.dart'
    show CupertinoColors, CupertinoDynamicColor;

export 'src/macos_app.dart';
export 'src/util.dart';
export 'src/styles/theme.dart';
export 'src/styles/typography.dart';
export 'src/layout/scaffold.dart';
export 'src/layout/content_area.dart';
export 'src/layout/resizable_pane.dart';
export 'src/layout/sidebar.dart';
export 'src/layout/title_bar.dart';
