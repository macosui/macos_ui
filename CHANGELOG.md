## [0.2.4]
* Fix textfield prefix icon alignment

## [0.2.3]
* Add `canvasColor` to `MacosThemeData`. `Scaffold` now uses this as its default background color.

## [0.2.2]
* Add new `MacosColor` and `MacosColors` classes
* Rename `colors.dart` to `macos_dynamic_color`

## [0.2.1]
* `IconButton` updates:
  - The `color` property is now `backgroundColor`
  - The widget now takes a `Widget icon` rather than `IconData iconData` for better control over widget properties
  - Deprecate and remove internal `foregroundColor` value

## [0.2.0]
* New widget: `BackButton`, `IconButton`
* Add `VisualDensity` to `MacosThemeData`
* Ensure localizations get returned in `MacosApp`

## [0.1.4]
* Add `startWidth` properties to `ResizablePane` and `Sidebar`
* Implement `Scrollbar`
* Implement `MacosScrollBehavior`

## [0.1.3]
* Fix `TextField` on Flutter v2.2.0

## [0.1.2]
* Updated the theme api
  * Properties in `MacosThemeData` and in `Typography` can't be null
  * Renamed `DynamicColorX` to `MacosDynamicColor`
  * Added the method `lerp` on all theme datas.

## [0.1.1]
* Implemented `Label` ([#61](https://github.com/GroovinChip/macos_ui/issues/61))
* Capacity Indicator now works as expected ([#49](https://github.com/GroovinChip/macos_ui/issues/49))
* Clear button is now aligned to text ([#82](https://github.com/GroovinChip/macos_ui/issues/82))

## [0.1.0]
* pub.dev release

## [0.0.13]
* Documentation for `ScaffoldScope`

## [0.0.12]
* Implement `Tooltip`
* Add mouse cursors to help button, push button and `TextField`

## [0.0.11]
* Implement `TextField`

## [0.0.10]
* Revamp `Scaffold` [#26](https://github.com/GroovinChip/macos_ui/issues/26)

## [0.0.9+1]
* `CapacityIndicator` colors can now be set on its constructor
* Accessibility support for most of the widgets
* Diagnostics Properties (dev tools) for most of the widgets

## [0.0.9]
* Implemented `HelpButton`
* Fixed [#49](https://github.com/GroovinChip/macos_ui/issues/49)

## [0.0.7]
* Implemented `Checkbox`
* Implemented `RadioButton`

## [0.0.6]
* Update `Typography` with correct letter spacing and font weights
* Add `brightnessOf` and `maybeBrightnessOf` functions to `MacosTheme`

## [0.0.5]
* Adds the `PushButton` widget along with `PushButtonTheme` and `PushButtonThemeData`
* Removes the `height` property from `Typography`'s `TextStyle`s
* Updates `Typography.headline`'s weight and letter spacing

## [0.0.4]
* Major theme refactor that more closely resembles flutter/material and flutter/cupertino
  * The `Style` class is now `MacosThemeData`
  * `MacosTheme` is now a `StatelessWidget` that returns a private `_InheritedMacosTheme`. 
  The static `MacosTheme.of(context)` is now defined here.
  * `MacosApp` now takes a `theme` and `darkTheme` rather than `style` and `darkStyle`. 
  Additionally, there are minor changes to the way `MacosApp` is built that more closely 
  resemble how `MaterialApp` is built. 

## [0.0.3]

* Implemented `Checkbox`
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
