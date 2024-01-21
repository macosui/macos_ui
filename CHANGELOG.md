## [2.0.5]
### 🛠️ Fixed 🛠️
* Fixed `MacosRadioButton` check null value issue.

## [2.0.4]
### 🔄 Updated 🔄
* Added `initialTime` parameter to `MacosTimePicker`, allowing to set an initial time for the picker.This provides more customization options for selecting time.

## [2.0.3]
### 🛠️ Fixed 🛠️
* Fixed a bug that caused the sidebar to appear darker than intended.

### 🔄 Updated 🔄
* `SidebarItems` has now respects the user’s selected accent color and mimics the look of macOS’ sidebar items more closely.

## [2.0.2]
### 🛠️ Fixed 🛠️
* Fixed images in generated documentation.

## [2.0.1]
### 🔄 Updated 🔄
* `PushButton` has received a facelift. It now mimics the look and feel of native macOS buttons more closely.
    * **Note:** As a result, its `pressedOpacity` property and the `PushButtonTheme` class have been deprecated.

## [2.0.0]
### 🚨 Breaking Changes 🚨
* `macos_ui` has been migrated to utilize [macos_window_utils](https://pub.dev/packages/macos_window_utils) under the hood, which provides the following benefits:
    * Window animation smoothness is drastically improved, particularly when miniaturizing and deminiaturizing the application window.
    * Some visual artifacts that occurred while the window was being (de)miniaturized (such as the application's shadow going missing) no longer occur.
    * The sidebar remains transparent when the app's brightness setting mismatches the OS setting.
    * Wallpaper tinting is now supported.
    * To migrate an existing application, please refer to the “Modern window look” section in the README.

* Support for Flutter 3.10 and Dart 3
* `PushButton` has been updated to support the `ControlSize` enum.
    * The `buttonSize` property has been changed to `controlSize`.
    * Buttons can now be any of the following sizes: mini, small, regular, or large.
* `PushButton.isSecondary` is now `PushButton.secondary`.
* `MacosAlertDialog`: `primaryButton` and `secondaryButton` are now declared to be of type `PushButton`.
* `RelevanceIndicator` has been deprecated
* `MacosTypography` white and black are now factory constructors called `darkOpaque()` and `lightOpaque()` to reflect
  Apple's naming conventions.

### ✨ New ✨
* `MacosSwitch` has been completely rewritten and now matches the native macOS switch in appearance and behavior.
* A `ControlSize` enum has been introduced, which will allow widgets to more closely match their native counterparts.
* `MacosTypography`
    * You can now call `MacosTypography.of(context)` as a shorthand for retrieving the typography used in your `MacosTheme`.
    * `MacosFontWeight` allows using Apple-specific font weights like `w510`, `w590`, and `w860`.
* Localization
    * Added support for `weekdayAbbreviations` and `monthAbbreviations` to `MacosDatePicker`.
    * Added support for `dateFormat` to `MacosDatePicker`.
    * Added support for `startWeekOnMonday` to `MacosDatePicker`.

### 🔄 Updated 🔄
* `MacosColor` has been updated with some previously missing elements.
* `PushButton`
    * Now uses the correct `body` text style instead of the incorrect `headline`
* `PushButton`'s secondary and disabled colors more closely match their native counterparts.
* `MacosCheckbox` appearance more closely matches its native counterpart.
* `MacosAlertDialog`
    * `primaryButton` and `secondaryButton` are now required to have `controlSize`s of `ControlSize.large`.
    * Docs now suggest that `appIcon` should be of size 64x64.
* `Toolbar` now uses the correct `title3` text style instead of the incorrect `headline`
* `MacosTheme` sets the global typography more efficiently
* `HelpButton` now sizes itself according to specification
* `ResizablePane` can now disallow the usage of its internal scrollbar via the  `ReziablePane.noScrollBar` constructor.

### 🛠️ Fixed 🛠️
* Clicking on the calendar elements in `MacosDatePicker` has better UX
* `ToolBar`s in use where a `SideBar` is not present will now have their title's avoid the traffic lights (native window controls).
* `MacosTypography.darkOpaque()` and `MacosTypography.lightOpaque()` now conform to specification by using `MacosColors.labelColor`
* Ensure builds targeting web do not utilize any `macos_window_utils` code
* Ensure builds targeting web are themed correctly

## [1.12.5]
* Fixed a bug where the `Sidebar.key` parameter wasn't used, which caused certain layouts to be unachievable.

## [1.12.4]
* Default the `_selectedDay` state variable to be 1 when selecting the previous/next month from widget to ensure new date is valid for `_formatAsDateTime()` method (https://github.com/flutter/flutter/issues/123669 & https://github.com/macosui/macos_ui/pull/402)

## [1.12.3]
* Added support for `routerConfig` to `MacosApp.router`. ([#388](https://github.com/macosui/macos_ui/issues/388))

## [1.12.2]
* Fixed a bug where clicking on a overflowed toolbar item with a navigation callback wouldn't work ([#346](https://github.com/GroovinChip/macos_ui/issues/346)).

## [1.12.1+1]
* Fixed a typo in the December abbreviation displayed in the `MacosDatePicker`.

## [1.12.1]
* Fix SidebarItem's leading icons not respecting the theme's primary color

## [1.12.0]
✨ New widget: `SliverToolBar`

## [1.11.1]
* Fixed an issue where the `MacosSearchField` would not perform an action when an item was selected.

## [1.11.0]
* 🚨 Breaking Changes 🚨
* `ResizablePane` can now be vertically resized
    * `ResizablePane.startWidth` has been changed to `ResizablePane.startSize`
    * `ResizablePane.minWidth` has been changed to `ResizablePane.minSize`
    * `ResizablePane.maxWidth` has been changed to `ResizablePane.maxSize`

## [1.10.0]
🚨 Breaking Changes 🚨
* `MacosScrollbar` has been completely overhauled and now resembles the native macOS scrollbar in appearance and
  behavior. Previously, it wrapped the material scrollbar, and now creates a custom scrollbar that extends
  `RawScrollbar`. This resulted in the removal of several material-based properties for the scrollbar, and
  `ContentArea.builder` is once again a `ScrollableWidgetBuilder`! 🎉
* Removed material-based scrollbar properties from `MacosScrollbarThemeData`

Other changes:
* Added implementation of `MacosDisclosureButton`
* Fixed a bug where `CapacityIndicator` only worked correctly for splits = 10

## [1.9.1]
* Adds optional `initialDate` to `MacosDatePicker`

## [1.9.0]
* Implement `MacosSlider`

## [1.8.0]
🚨 Breaking Changes 🚨
* `ContentArea.builder` has been changed from a `ScrollableWidgetBuilder` to a `WidgetBuilder` due to
  changes in Flutter 3.7. The `MacosScrollbar` widget needs to undergo radical changes in order to achieve the
  native macOS scrollbar look and feel in the future, so this will be revisited at that time.

Other changes:
* Per Flutter 3.7.0: Replace deprecated `MacosTextField.toolbarOptions` with `MacosTextField.contextMenuBuilder`
* Ensure the color panel releases when it is closed
* Avoid render overflows in the `Sidebar` when the window height is resized below a certain threshold ([#325](https://github.com/GroovinChip/macos_ui/issues/325))
* Update `MacosScrollbar.thumbVisibility` with the latest change introduced in Flutter 3.7
* Update `README.md` to address issues [#325](https://github.com/GroovinChip/macos_ui/issues/325) & [#332](https://github.com/GroovinChip/macos_ui/issues/332)

## [1.7.6]
* Fixed a bug where `MacosPopupButton` would report that a `ScrollController` was not attached to any views

## [1.7.5]
* Addressed Flutter 3.3 analyzer warnings

## [1.7.4]
* Added `backgroundColor` to `MacosSheet`

## [1.7.3]
* Fixed an issue where the `title` property of `TitleBar` did not apply a fitting `DefaultTextStyle`

## [1.7.2]
* Added padding as parameter to MacosTabView constructor.

## [1.7.1]
* Fixed an issue where end sidebar window breakpoints were not respected

## [1.7.0]
* ✨ New
    * `MacosImageIcon` widget. Identical to the `ImageIcon` from `flutter/widgets.dart` except it will obey a
      `MacosIconThemeData` instead of an `IconThemeData`
    * `SidebarItemSize` enum, which determines the height of sidebar items and the maximum size their `leading` widgets.
    * `SidebarItem` now accepts an optional `trailing` widget.
* 🔄 Updated
    * `SidebarItems` now supports `SidebarItemSize` via the `itemSize` property, which defaults to
      `SidebarItemSize.medium`. The widget has been updated to manage the item's height, the maximum size of the item's
      leading widget, and the font size of the item's label widget according to the given `SidebarItemSize`.
    * The example app has been tweaked to use some icons from the SF Symbols 4 Beta via the new `MacosImageIcon` widget.

## [1.6.0]
* New widgets: `MacosTabView` and `MacosTabView`
* BREAKING CHANGE: `Label.yAxis` has been renamed to `Label.crossAxisAlignment`
* BREAKING CHANGE: `TooltipTheme` and `TooltipThemeData` have been renamed to `MacosTooltipTheme` and
  `MacosTooltipThemeData`

## [1.5.1]
* Correct the placement of the leading widget in disclosure sidebar items [#268](https://github.com/GroovinChip/macos_ui/issues/268)
* Improve the sizing of the disclosure item indicator

## [1.5.0]
* Adds `endSidebar` to `MacosWindow`

## [1.4.2]
* Fixes RenderFlex overflowed in `MacosListTile` [#264](https://github.com/GroovinChip/macos_ui/issues/264)

## [1.4.1+1]
* Update `pubspec.yaml` with `repository` and new `homepage` field.

## [1.4.1]
* Fixes an issue where if the app was displayed in full screen mode, an opaque empty toolbar would appear at the top [#249](https://github.com/GroovinChip/macos_ui/issues/249)

## [1.4.0]
* Migration to Flutter 3.0
    * Minimum dart sdk version is now 2.17.0
    * Use new super parameters feature
    * Update to `flutter_lints: ^2.0.1` with subsequent fixes
    * `MacosScrollbar` API more closely matches its material counterpart
* Update `MacosColor` to more closely match the `Color` class
    * Adds `MacosColor.fromARGB` constructor
    * Adds `MacosColor.fromRGBO` constructor
    * Adds `alphaBlend` function
    * Adds `getAlphaFromOpacity` function

## [1.3.0]
* Add a `top` property to `Sidebar`
* Tweak the default `primaryColor` value in `MacosThemeData`.

## [1.2.1+1]
* Fix `MacosApp` documentation

## [1.2.1]
* Fixes issue with error thrown when toolbar actions are modified programmatically [#239](https://github.com/GroovinChip/macos_ui/issues/239)

## [1.2.0]
* Improved styling for `MacosTooltip`:
    * Better color and shadows.
    * Displays left-aligned, below the mouse cursor.
* New widget: `ToolBarDivider` that can be used as a divider (vertical/horizontal line) in the `ToolBar` [#231](https://github.com/GroovinChip/macos_ui/issues/231).
* All toolbar widgets can now receive a `tooltipMessage` property to display a `MacosTooltip` when user hovers over them [#232](https://github.com/GroovinChip/macos_ui/issues/232).

## [1.1.0+1]
* Minor improvements to `README.md`

## [1.1.0]
* New functionality for `MacosSearchField`
    * Shows a list of search results in an overlay below the field
    * A result can be selected and customized.
* A `MacosOverlayFilter` widget can now be used to apply the blurry "frosted glass" effect on surfaces.
* New widget: `CustomToolbarItem` that enables any widget to be used in the `Toolbar`.

## [1.0.1]
* Improvements to the graphical `MacosTimePicker`
    * Better color gradient on the border
    * Better inner shadow
    * Minor size adjustments
    * API improvements
* Throw an exception if `MacosColorWell` is clicked on a non-macOS platform

## [1.0.0+1]
* Minor documentation fix for [MacosColorWell]

## [1.0.0]
* First stable release 🎉

## [0.16.0]
* New widget: `MacosTimePicker` (textual style only!)

## [0.15.0]
* New widget: `MacosColorWell`

## [0.14.0]
* New widget: `ToolBar`, which can be used to create a toolbar at the top of the `MacosScaffold`. Toolbar items include `ToolBarIconButton`, `ToolBarPulldownButton`, and `ToolBarSpacer` widgets.
* New widget: `MacosSearchField`, which creates a macOS-style search field.
* Breaking change: the title bar (`TitleBar`) should now be set via the `titlebar` property of `MacosWindow` (was previously a property of `MacosScaffold`). If you are using a title bar in your app, please note a small change you would need to make in your `macos/Runner/MainFlutterWindow.swift` file, described in the "Modern window look" section of the README file.
* Fix the graphical version of `MacosDatePicker` having an incorrect current day text color in light theme

## [0.13.1]
* Minor style fixes for `MacosTextField`

## [0.13.0]
* New widget: `MacosDatePicker`

## [0.12.4+3]
* Move theme classes to their own files in the `/theme` directory

## [0.12.4+2]
* Switch over to `flutter_lints`

## [0.12.4+1]
* Improve visual design of `MacosPopupButton` and `MacosPulldownButton`, to better match the styling and translucency effect of Apple design.
* Remove unnecessary properties of `MacosPopupButton`

## [0.12.4]
* New widget: `MacosPulldownButton`, which can be used as a dropdown for selecting actions with either text or an icon as its title.

## [0.12.3+1]
* Fix `padding` on `MacosAlertDialog` when `supress` is null [#188](https://github.com/GroovinChip/macos_ui/issues/188)

## [0.12.3]
* Remove `MacosScrollbar` from `ContentArea` widget (fixes [#170](https://github.com/GroovinChip/macos_ui/issues/170))
* Remove useless bundled fonts (fixes [#187](https://github.com/GroovinChip/macos_ui/issues/187))
* Allow users to customize the mouse cursor for sidebar items (fixes [#181](https://github.com/GroovinChip/macos_ui/issues/181))
* Fix active sidebar item icon color (fixes [#190](https://github.com/GroovinChip/macos_ui/issues/190))

## [0.12.2+2]
* Added `padding` property to `MacosIconButton` and `MacosIconButtonTheme`.

## [0.12.2+1]
* Adds missing `merge` methods to `MacosThemeData` and widget `ThemeData` classes, making it possible to use them properly with any number of user-provided custom properties.

## [0.12.2]
* Fixes `MacosThemeData` to properly apply user-defined `pushButtonTheme`, `helpButtonTheme`, and `tooltipTheme` properties.

## [0.12.1]
* Sidebar and ResizablePane more precisely track cursor location
* Sidebar can now be closed by dragging below its minWidth
* Sidebar can now be configured to snap into place when dragged near its startWidth

## [0.12.0+1]
* Reverts bundling the `native_context_menu` plugin per [#179](https://github.com/GroovinChip/macos_ui/issues/179)

## [0.12.0]
* New Widget: `MacosPopupButton`


## [0.10.2]
* Updates to `MacosIconButton` and `MacosBackButton`:
    * Added a hover effect when mouse moves over the buttons ([#168](https://github.com/GroovinChip/macos_ui/issues/168))
    * Added `hoverColor` property.
    * Default shape is now `BoxShape.rectangle` with border radius, as it seems to be the most used in macOS design.

## [0.10.1]
* Added support for transparent sidebar. Please note that changes to `MainFlutterWindow.swift` are required for this to work. [(#175)](https://github.com/GroovinChip/macos_ui/pull/175)

## [0.10.0+1]
* Update `native_context_menu` dependency

## [0.10.0]
* New widget - `MacosIcon`! `MacosIcon` is identical to regular icons, with the exception that it respects a `MacosTheme`. Also includes corresponding theme classes
* `MacosThemeData` now sets a global, configurable `iconTheme` for `MacosIcon`s

## [0.9.3]
* Update to `PushButton`:
    * Added `isSecondary` property

## [0.9.2]
* Nearly all `MouseRegion`s have been updated to use `SystemMouseCursors.basic` in order to more closely adhere to Apple norms
* `mouseCursor` properties have been added to most buttons

## [0.9.1]
* Added top-level theming for `MacosIconButton`
    * Introduces the `MacosIconButtonTheme` InheritedTheme and the `MacosIconButtonThemeData` theme class
* Updates `MacosThemeData` and `MacosIconButton` to use the new `MacosIconButtonThemeData`
* Removes an unnecessary setting of VisualDensity from `MacosThemeData.dark()`

## [0.9.0]
* Added [native_context_menu](https://pub.dev/packages/native_context_menu) as a dependency for native context menus!

## [0.8.2]
* Updates to `MacosListTile`:
    * Added `leadingWhitespace` property
    * Added `onClick` callback
    * Added `onLongPress` callback
    * Added `mouseCursor` property

## [0.8.1]
* Fix the outer border of `MacosSheet` not having a border radius

## [0.8.0]
* New Widget: `MacoSheet`
* New Widget: `MacosListTile`

## [0.7.3]
* Fixed bug where cursor would not change caret location on mouse click

## [0.7.2]
* Upgraded various `copyWith` functions
* Added `==` and `hashCode` to various classes

## [0.7.1]
* Add generics support to `MacosRadioButton` - Thank you, [Sacha Arbonel](https://github.com/sachaarbonel)!

## [0.7.0+2]
* Add note in docs that a `Builder` is required for manual sidebar toggling to work.

## [0.7.0+1]
* Fix docs for `PushButtonThemeData`
* Update `dart_code_metrics` dependency

## [0.7.0]
* Adds: `MacosWindow`
* Improved `MacosScaffold`

## [0.6.2]
* Chore: Remove box shadows from `MacosIconButton`

## [0.6.1]
* Fix `builder` property in `MacosApp` never being used ([#148](https://github.com/GroovinChip/macos_ui/issues/148))

## [0.6.0]
* Improved `MacosAlertDialog` design
* Added `showMacosAlertDialog` to display a `MacosAlertDialog` with standard macOS animations and behaviour.

## [0.5.2]
* Fixes maximum height issue with `MacosAlertDialog`

## [0.5.1]
* Adds `suppress` widget parameter to `MacosAlertDialog`

## [0.5.0]
* Adds `MacosAlertDialog`

## [0.4.2]
* Add `bottom` Item to `Sidebar`

## [0.4.1]
* Update `MacosColors`
* Fix `Label` alignment

## [0.4.0]
* Adds the `SidebarItem` widget
* Fixes an alignment issue with `MacosTextField`

## [0.3.0]
* Add `MacosPrefix` to widgets/classes with names that overlap with the material/cupertino libraries:
    * `TextField` -> `MacosTextField`
    * `Scaffold` -> `MacosTextField`
    * `IconButton` -> `MacosIconButton`
    * `BackButton` -> `MacosBackButton`
    * `Scrollbar` -> `MacosScrollbar`
    * `Checkbox` -> `MacosCheckbox`
    * `RadioButton` -> `MacosRadioButton`
    * `Tooltip` -> `MacosTooltip`
    * `Typography` -> `MacosTypography`
    * `Switch` -> `MacosSwitch`

## [0.2.4]
* Fix text field prefix icon alignment

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
    * Added the method `lerp` on all theme data classes.

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
