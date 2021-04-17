## [0.0.4]
* Major theme refactor that more closely resembles flutter/material and flutter/cupertino
  * The `Style` class is now `MacosThemeData`
  * `MacosTheme` is now a `StatelessWidget` that returns a private `_InheritedMacosTheme`. 
  The static `MacosTheme.of(context)` is now defined here.
  * `MacosApp` now takes a `theme` and `darkTheme` rather than `style` and `darkStyle`. 
  Additionally, there are minor changes to the way `MacosApp` is built that more closely 
  resemble how `MaterialApp` is built. 

## [0.0.3]

* Implemented `ProgressCircle` and `ProgressBar`
* Implemented the `Switch` widget

## [0.0.2]

* `Scaffold` widget
* Fix `Typography` so that text color is shown appropriately based on Brightness

## [0.0.1]

* Project creation
  * `MacosApp` widget
  * Basic `Typography`
  * Basic theming via `MacosTheme` and `Style`
