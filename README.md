# macos_ui

Flutter widgets and themes implementing the current macOS design language.

Check out our **interactive widget gallery** online at https://groovinchip.github.io/macos_ui/#/

[![pub package](https://img.shields.io/pub/v/macos_ui.svg)](https://pub.dev/packages/macos_ui)
[![pub package](https://img.shields.io/pub/publisher/macos_ui.svg)](https://pub.dev/packages/macos_ui)  

[![Flutter Analysis](https://github.com/GroovinChip/macos_ui/actions/workflows/flutter_analysis.yml/badge.svg)](https://github.com/GroovinChip/macos_ui/actions/workflows/flutter_analysis.yml)
[![Pana Analysis](https://github.com/GroovinChip/macos_ui/actions/workflows/pana_analysis.yml/badge.svg)](https://github.com/GroovinChip/macos_ui/actions/workflows/pana_analysis.yml)
[![codecov](https://github.com/GroovinChip/macos_ui/actions/workflows/codecov.yaml/badge.svg)](https://github.com/GroovinChip/macos_ui/actions/workflows/codecov.yaml)
[![codecov](https://codecov.io/gh/GroovinChip/macos_ui/branch/dev/graph/badge.svg?token=1SZGEVVMCH)](https://codecov.io/gh/GroovinChip/macos_ui)

<img src="https://imgur.com/5mFQKBU.png" width="75%"/>

## Contents

<details>
<summary>Contributing & Resources</summary>

- [macos_ui](#macos_ui)
  - [Contributing](#contributing)
  - [Resources](#resources)
</details>

<details>
<summary>Layout</summary>

- [Layout](#layout)
  - [MacosWindow](#macoswindow)
  - [MacosScaffold](#macosscaffold)
  - [Modern Window Look](#modern-window-look)
  - [ToolBar](#toolbar)
  - [MacosListTile](#MacosListTile)
</details>

<details>
<summary>Icons</summary>

- [Icons](#icons)
  - [MacosIcon](#MacosIcon)
</details>

<details>
<summary>Buttons</summary>

- [Buttons](#buttons)
  - [MacosCheckbox](#macoscheckbox)
  - [HelpButton](#helpbutton)
  - [RadioButton](#radiobutton)
  - [PulldownButton](#pulldownbutton)
  - [PopupButton](#popupbutton)
  - [PushButton](#pushbutton)
  - [MacosSwitch](#macosswitch)
</details>
  
<details>
<summary>Dialogs & Sheets</summary>

- [Dialogs & Sheets](#dialogs)
  - [MacosAlertDialog](#MacosAlertDialog)
  - [MacosSheet](#MacosSheet)
</details>

<details>
<summary>Fields & Labels</summary>

- [Fields](#fields)
  - [MacosTextField](#macostextfield)
  - [MacosSearchField](#macossearchfield)
- [Labels](#labels)
  - [MacosTooltip](#macostooltip)
</details>

<details>
<summary>Indicators</summary>

- [Indicators](#indicators)
  - [Progress Indicators](#progress-indicators)
    - [ProgressCircle](#progresscircle)
    - [ProgressBar](#progressbar)
  - [Level Indicators](#level-indicators)
    - [CapacityIndicator](#capacityindicator)
    - [RatingIndicator](#ratingindicator)
    - [RelevanceIndicator](#relevanceindicator)
</details>

<details>
<summary>Selectors</summary>

- [Selectors](#selectors)
  - [MacosDatePicker](#macosdatepicker)
  - [MacosTimePicker](#macostimepicker)
</details>

---

## Contributing

`macos_ui` welcomes contributions! Please see `CONTRIBUTING.md` for more information.

## Resources

- [macOS Design Resources](https://developer.apple.com/design/resources/)
- [macOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos)
- [macOS Big Sur Figma kit](https://www.figma.com/file/M6K5L3GK0WJh6pnsASyVeE/macOS-Big-Sur-UI-Kit?node-id=1%3A2)

# Layout

## MacosWindow

`MacosWindow` is the basic frame for a macOS-style layout.

<img src="https://imgur.com/olstQFC.png" width="40%"/>
<img src="https://imgur.com/yFXsoSy.png" width="40%"/>

It supports a `Sidebar` on the left, an optional `TitleBar` at the top, and the rest of the window is typically filled out
with a `MacosScaffold`. 

A scope for the `MacosWindow` is provided by `MacosWindowScope`.
The sidebar can be toggled with `MacosWindowScope.of(context).toggleSidebar()`. **Please note** that you must wrap 
your `MacosScaffold` in a `Builder` widget in order for this to work properly.

<img src="https://imgur.com/IBbp5rN.gif" width="75%">

## MacosScaffold

The `MacosScaffold` is what you might call a "page".

The scaffold has a `toolbar` property and a `children` property. `children` accepts a `ContentArea` widget and 
multiple `ResizablePane` widgets. To catch navigation or routes below the scaffold, consider wrapping the 
`MacosScaffold` in a [`CupertinoTabView`](https://api.flutter.dev/flutter/cupertino/CupertinoTabView-class.html). 
By doing so, navigation inside the `MacosScaffold` will be displayed inside the `MacosScaffold` area instead of 
covering the entire window. To push a route outside a `MacosScaffold` wrapped in a 
[`CupertinoTabView`](https://api.flutter.dev/flutter/cupertino/CupertinoTabView-class.html), use the root navigator 
`Navigator.of(context, rootNavigator: true)`

See the documentation for customizations and `ToolBar` examples.

<img src="https://imgur.com/KT1fdjI.png" width="75%"/>

<img src="https://imgur.com/4mknLAy.png" width="75%"/>

<img src="https://imgur.com/mXR2wwu.png" width="75%"/>

## Modern window look

A new look for macOS apps was introduced in Big Sur (macOS 11). To match that look 
in your Flutter app, like our screenshots, your `macos/Runner/MainFlutterWindow.swift` 
file should look like this:

```swift
import Cocoa
import FlutterMacOS

class BlurryContainerViewController: NSViewController {
  let flutterViewController = FlutterViewController()

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  override func loadView() {
    let blurView = NSVisualEffectView()
    blurView.autoresizingMask = [.width, .height]
    blurView.blendingMode = .behindWindow
    blurView.state = .active
    if #available(macOS 10.14, *) {
        blurView.material = .sidebar
    }
    self.view = blurView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.addChild(flutterViewController)

    flutterViewController.view.frame = self.view.bounds
    flutterViewController.view.autoresizingMask = [.width, .height]
    self.view.addSubview(flutterViewController.view)
  }
}

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let blurryContainerViewController = BlurryContainerViewController()
    let windowFrame = self.frame
    self.contentViewController = blurryContainerViewController
    self.setFrame(windowFrame, display: true)

    if #available(macOS 10.13, *) {
      let customToolbar = NSToolbar()
      customToolbar.showsBaselineSeparator = false
      self.toolbar = customToolbar
    }
    self.titleVisibility = .hidden
    self.titlebarAppearsTransparent = true
    if #available(macOS 11.0, *) {
      // Use .expanded if the app will have a title bar, else use .unified
      self.toolbarStyle = .unified
    }

    self.isMovableByWindowBackground = true
    self.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)

    self.isOpaque = false
    self.backgroundColor = .clear

    RegisterGeneratedPlugins(registry: blurryContainerViewController.flutterViewController)

    super.awakeFromNib()
  }

  func window(_ window: NSWindow, willUseFullScreenPresentationOptions proposedOptions: NSApplication.PresentationOptions = []) -> NSApplication.PresentationOptions {
    // Hides the toolbar when in fullscreen mode
    return [.autoHideToolbar, .autoHideMenuBar, .fullScreen]
  }
}

```

See [this issue comment](https://github.com/flutter/flutter/issues/59969#issuecomment-916682559) for more details on the new look and explanations for how it works.

Please note that if you are using a title bar (`TitleBar`) in your `MacosWindow`, you should set the `toolbarStyle` of NSWindow to `.expanded`, in order to properly align the close, minimize, zoom window buttons. In any other case, you should keep it as `.unified`. This must be set beforehand, i.e. it cannot be switched in runtime.

## ToolBar

Creates a toolbar in the `MacosScaffold`. The toolbar appears below the title bar (if present) of the macOS app or integrates with it, by using its `title` property. 

A toolbar provides convenient access to frequently used commands and features (toolbar items). Different routes of your app could have different toolbars. 

Toolbar items include `ToolBarIconButton`, `ToolBarPulldownButton`, and `ToolBarSpacer` widgets, and should be provided via the `items` property. The action of every toolbar item should also be provided as a menu bar command of your app.

Toolbars look best and are easiest to understand when they contain elements of the same type (so either use labels for every toolbar item or not).

You can use the `ToolBarSpacer` widgets to set the grouping of the different toolbar actions.

An example toolbar would be:

```dart
ToolBar(
  title: const Text('Untitled Document'),
  titleWidth: 200.0,
  leading: MacosBackButton(
    onPressed: () => debugPrint('click'),
    fillColor: Colors.transparent,
  ),
  actions: [
    ToolBarIconButton(
      label: "Add",
      icon: const MacosIcon(
        CupertinoIcons.add_circled,
      ),
      onPressed: () => debugPrint("Add..."),
      showLabel: true,
    ),
    const ToolBarSpacer(),
    ToolBarIconButton(
      label: "Delete",
      icon: const MacosIcon(
        CupertinoIcons.trash,
      ),
      onPressed: () => debugPrint("Delete"),
      showLabel: false,
    ),
    ToolBarPullDownButton(
      label: "Actions",
      icon: CupertinoIcons.ellipsis_circle,
      items: [
        MacosPulldownMenuItem(
          label: "New Folder",
          title: const Text("New Folder"),
          onTap: () => debugPrint("Creating new folder..."),
        ),
        MacosPulldownMenuItem(
          label: "Open",
          title: const Text("Open"),
          onTap: () => debugPrint("Opening..."),
        ),
      ],
    ),
  ]
),
```

This builds this simple toolbar: 
<img src="https://imgur.com/BDUdQkj.png"/>

Other toolbar examples:

- Toolbar with icon buttons (no labels):
<img src="https://imgur.com/PtrjhPx.png"/>

- Toolbar with icon buttons and labels:
<img src="https://imgur.com/Ouaud12.png"/>

- Toolbar with a pulldown button open:
<img src="https://imgur.com/QCxoGmM.png"/>

- Toolbar with title bar above (also see [the note above](#modern-window-look)):
<img src="https://imgur.com/eAgcsKY.png"/>

You can also create your own `CustomToolbarItem` to include any type of widget in the toolbar:

```dart
// Add a grey vertical line as a custom toolbar item:
CustomToolbarItem(
  inToolbarBuilder: (context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(color: Colors.grey, width: 1, height: 30),
  ),
  inOverflowedBuilder: (context) =>
      Container(color: Colors.grey, width: 30, height: 1),
),
```

## MacosListTile

A widget that aims to approximate the [ListTile] widget found in
Flutter's material library.

![MacosListTile](https://imgur.com/pQB99M2.png)

Usage:
```dart
MacosListTile(
  leading: const Icon(CupertinoIcons.lightbulb),
  title: Text(
    'A robust library of Flutter components for macOS',
    style: MacosTheme.of(context).typography.headline,
  ),
  subtitle: Text(
    'Create native looking macOS applications using Flutter',
    style: MacosTheme.of(context).typography.subheadline.copyWith(
      color: MacosColors.systemGrayColor,
    ),
  ),
),
```



# Icons

## MacosIcon

A `MacosIcon` is identical to a regular `Icon` in every way with one exception - it respects
a `MacosTheme`. Use it the same way you would a regular icon:

```dart
MacosIcon(
  CupertinoIcons.add,
  // color: CupertinoColors.activeBlue.color,
  // size: 20,
),
```

# Buttons

## MacosCheckbox

A checkbox is a type of button that lets the user choose between two opposite states, actions, or values. A selected 
checkbox is considered on when it contains a checkmark and off when it's empty. A checkbox is almost always followed 
by a title unless it appears in a checklist. [Learn more](https://developer.apple.com/design/human-interface-guidelines/macos/buttons/checkboxes/)

| Off                                                                                                                   | On                                                                                                                 | Mixed                                                                                                              |
| --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------ |
| ![Off Checkbox](https://developer.apple.com/design/human-interface-guidelines/macos/images/CheckBoxes_Deselected.svg) | ![On Checkbox](https://developer.apple.com/design/human-interface-guidelines/macos/images/CheckBoxes_Selected.svg) | ![Mixed Checkbox](https://developer.apple.com/design/human-interface-guidelines/macos/images/CheckBoxes_Mixed.svg) |

Here's an example of how to create a basic checkbox:

```dart
bool selected = false;

MacosCheckbox(
  value: selected,
  onChanged: (value) {
    setState(() => selected = value);
  },
)
```

To make a checkbox in the `mixed` state, set `value` to `null`.

## HelpButton

A help button appears within a view and opens app-specific help documentation when clicked. All help buttons are 
circular, consistently sized buttons that contain a question mark icon. [Learn more](https://developer.apple.com/design/human-interface-guidelines/macos/buttons/help-buttons/)

![HelpButton Example](https://developer.apple.com/design/human-interface-guidelines/macos/images/buttonsHelp.png)

Here's an example of how to create a help button:

```dart
HelpButton(
  onPressed: () {
    print('pressed help button'),
  },
)
```

You can customize the help button appearance and behaviour using the `HelpButtonTheme`, but it's not recommended by 
apple to change help button's appearance.

## RadioButton

A radio button is a small, circular button followed by a title. Typically presented in groups of two to five, radio 
buttons provide the user a set of related but mutually exclusive choices. A radio button’s state is either on 
(a filled circle) or off (an empty circle). [Learn more](https://developer.apple.com/design/human-interface-guidelines/macos/buttons/radio-buttons/)

![RadioButton Preview](https://developer.apple.com/design/human-interface-guidelines/macos/images/radioButtons.png)

Here's an example of how to create a basic radio button:

```dart
bool selected = false;

MacosRadioButton(
  value: selected,
  onChanged: (value) {
    setState(() => selected = value);
  },
),
```

## PulldownButton

A pull-down button (often referred to as a pull-down menu) is a type of pop-up button that, when clicked, displays a 
menu containing a list of choices. The menu appears below the button. Once the menu is displayed onscreen, it remains 
open until the user chooses a menu item, clicks outside of the menu, switches to another app, or quits the app; or 
until the system displays an alert. [Learn more](https://developer.apple.com/design/human-interface-guidelines/macos/buttons/pull-down-buttons/)

Use a pull-down button to present a list of commands. A pull-down button can either show a `title` or an `icon` to 
describe the contents of the button's menu. If you use an icon, make sure it clearly communicates the button’s purpose.

If `items` is null, the button will be disabled (greyed out). 

 A `title` or an `icon` must be provided, to be displayed as the  pull-down button's title, but not both at the same time.

The menu can also be navigated with the up/down keys and an action selected with the Return key.

It can also appear in the toolbar, via the `ToolBarPulldownButton` widget.

| Dark Theme                                 | Light Theme                                |
| ------------------------------------------ | ------------------------------------------ |
| <img src="https://imgur.com/XZlsUxF.jpg"/> | <img src="https://imgur.com/EtrydYd.jpg"/> |
| <img src="https://imgur.com/KVX8OsR.jpg"/> | <img src="https://imgur.com/mTvBxyL.jpg"/> |
| <img src="https://imgur.com/k1Wm6fd.jpg"/> | <img src="https://imgur.com/wb08RXI.jpg"/> |

Here's an example of how to create a basic pull-down button:

```dart
MacosPulldownButton(
  title: "Actions",
  // Or provide an icon to use as title:
  // icon: CupertinoIcons.ellipsis_circle, 
  items: [
    MacosPulldownMenuItem(
      title: const Text('Save'),
      onTap: () => debugPrint("Saving..."),
    ),
    MacosPulldownMenuItem(
      title: const Text('Save as...'),
      onTap: () => debugPrint("Opening Save As dialog..."),
    ),
    const MacosPulldownMenuDivider(),
    MacosPulldownMenuItem(
      enabled: false,
      title: const Text('Export'),
      onTap: () => debugPrint("Exporting"),
    ),
  ],
),
```

## PopupButton

A pop-up button (often referred to as a pop-up menu) is a type of button that, when clicked, displays a menu containing 
a list of mutually exclusive choices. The menu appears on top of the button. Like other types of menus, a pop-up 
button’s menu can include separators and symbols like checkmarks. After the menu is revealed, it remains open until the 
user chooses a menu item, clicks outside of the menu, switches to another app, or quits the app; or until the system 
displays an alert. [Learn more](https://developer.apple.com/design/human-interface-guidelines/macos/buttons/pop-up-buttons/)

The type `T` of the `MacosPopupButton` is the type of the value that each pop-up menu item represents. All the entries 
in a given menu must represent values with consistent types. Typically, an `enum` is used. Each `MacosPopupMenuItem` 
in items must be specialized with that same type argument.

The `onChanged` callback should update a state variable that defines the pop-up menu's value. It should also call 
`State.setState` to rebuild the pop-up button with the new value.

When there are menu items that cannot be displayed within the available menu constraints, a caret is shown at the top 
or bottom of the open menu to signal that there are items that are not currently visible. 

The menu can also be navigated with the up/down keys and an item selected with the Return key.

| Dark Theme                                 | Light Theme                                |
| ------------------------------------------ | ------------------------------------------ |
| <img src="https://imgur.com/ov0kzJC.jpg"/> | <img src="https://imgur.com/buhYEo1.jpg"/> |
| <img src="https://imgur.com/BOEH59L.jpg"/> | <img src="https://imgur.com/61S7DSX.jpg"/> |
| <img src="https://imgur.com/zY0d8RF.jpg"/> | <img src="https://imgur.com/W4CMa5z.jpg"/> |

Here's an example of how to create a basic pop-up button:

```dart
String popupValue = 'One';

MacosPopupButton<String>(
  value: popupValue,
  onChanged: (String? newValue) {
    setState(() {
      popupValue = newValue!;
    });
  },
  items: <String>['One', 'Two', 'Three', 'Four']
      .map<MacosPopupMenuItem<String>>((String value) {
    return MacosPopupMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList(),
),
```

## PushButton

A push button appears within a view and initiates an instantaneous app-specific action, such as printing a document or 
deleting a file. Push buttons contain text—not icons—and often open a separate window, dialog, or app so the user can 
complete a task. [Learn more](https://developer.apple.com/design/human-interface-guidelines/macos/buttons/push-buttons/)

| Dark Theme                                 | Light Theme                                |
| ------------------------------------------ | ------------------------------------------ |
| <img src="https://imgur.com/GsShoF6.jpg"/> | <img src="https://imgur.com/klWHTAX.jpg"/> |
| <img src="https://imgur.com/v99ekWA.jpg"/> | <img src="https://imgur.com/hj6uGhI.jpg"/> |
| <img src="https://imgur.com/wt0K6u4.jpg"/> | <img src="https://imgur.com/7khWnwt.jpg"/> |
| <img src="https://imgur.com/TgfjJdQ.jpg"/> | <img src="https://imgur.com/83cEMeP.jpg"/> |

Here's an example of how to create a basic push button:

```dart
PushButton(
  child: Text('button'),
  buttonSize: ButtonSize.large,
  onPressed: () {
    print('button pressed');
  },
),
```

## MacosSwitch

A switch is a visual toggle between two mutually exclusive states — on and off. A switch shows that it's on when the 
accent color is visible and off when the switch appears colorless. [Learn more](https://developer.apple.com/design/human-interface-guidelines/macos/buttons/switches/)

| On                                         | Off                                        |
| ------------------------------------------ | ------------------------------------------ |
| <img src="https://imgur.com/qK1VCVr.jpg"/> | <img src="https://imgur.com/IBh5jkz.jpg"/> |

Here's an example of how to create a basic toggle switch:

```dart
bool selected = false;

MacosSwitch(
  value: selected,
  onChanged: (value) {
    setState(() => selected = value);
  },
),
```

# Dialogs and Sheets

## MacosAlertDialog

Usage:
```dart
showMacosAlertDialog(
  context: context,
  builder: (_) => MacosAlertDialog(
    appIcon: FlutterLogo(
      size: 56,
    ),
    title: Text(
      'Alert Dialog with Primary Action',
      style: MacosTheme.of(context).typography.headline,
    ),
    message: Text(
      'This is an alert dialog with a primary action and no secondary action',
      textAlign: TextAlign.center,
      style: MacosTheme.of(context).typography.headline,
    ),
    primaryButton: PushButton(
      buttonSize: ButtonSize.large,
      child: Text('Primary'),
      onPressed: () {},
    ),
  ),
);
```

![](https://imgur.com/G3dcjew.png)
![](https://imgur.com/YHtgv59.png)
![](https://imgur.com/xuBR5qK.png)

## MacosSheet

Usage:
```dart
showMacosSheet(
  context: context,
  builder: (_) => const MacosuiSheet(),
);
```

![](https://imgur.com/NV0o5Ws.png)

# Fields

## MacosTextField

A text field is a rectangular area in which the user enters or edits one or more lines of text. A text field can 
contain plain or styled text.

<img src="https://imgur.com/UzyMlcL.png" width="75%"/>

Here's an example of how to create a basic text field:

```dart
MacosTextField(
  placeholder: 'Type some text here',
)
```

## MacosSearchField

A search field is a style of text field optimized for performing text-based searches in a large collection of values.

When the user starts typing into the search field, a list of selectable results appears in an overlay below (or above) the field. 

<img src="https://imgur.com/qbabwAW.png" width="75%"/>

| Dark Theme                                 | Light Theme                                |
| ------------------------------------------ | ------------------------------------------ |
| <img src="https://imgur.com/Jol85ny.jpg"/> | <img src="https://imgur.com/xP3l3Lv.jpg"/> |

Here's an example of how to create a search field:

```dart
MacosSearchField(
  placeholder: 'Search for a country...',
  results: countries.map((e) => SearchResultItem(e)).toList(),
  onResultSelected: (resultItem) {
    debugPrint(resultItem.searchKey);
  },
)
```

Check the `examples/fields_page` for more examples.

# Labels

Labels are a short description of what an element on the screen does.

## MacosTooltip

Tooltips succinctly describe how to use controls without shifting people’s focus away from the primary interface. 
Help tags appear when the user positions the pointer over a control for a few seconds. A tooltip remains visible for 
10 seconds, or until the pointer moves away from the control.

| Dark Theme                                 | Light Theme                                |
| ------------------------------------------ | ------------------------------------------ |
| <img src="https://imgur.com/0qLFqdK.jpg"/> | <img src="https://imgur.com/Y3PLqBo.jpg"/> |

To create a tooltip, wrap any widget on a `MacosTooltip`:

```dart
MacosTooltip(
  message: 'This is a tooltip',
  child: Text('Hover or long press to show a tooltip'),
),
```

You can customize the tooltip the way you want by customizing the theme's `TooltipTheme`. A tooltip automatically adapts to its 
environment, responding to touch and pointer events. To use a tooltip with a toolbar item, provide it with a `tooltipMessage` property.

# Indicators

## Progress Indicators

Don’t make people sit around staring at a static screen waiting for your app to load content or perform lengthy data 
processing operations. Use progress indicators to let people know your app hasn't stalled and to give them some idea 
of how long they’ll be waiting.

Progress indicators have two distinct styles:

- **Bar indicators**, more commonly known as progress bars, show progress in a horizontal bar.
- **Spinning indicators** show progress in a circular form, either as a spinner or as a circle that fills in as progress continues.

People don't interact with progress indicators; however, they are often accompanied by a button for canceling the 
corresponding operation. [Learn more](https://developer.apple.com/design/human-interface-guidelines/macos/indicators/progress-indicators/)

![Progress Indicator Example](https://developer.apple.com/design/human-interface-guidelines/macos/images/ProgressIndicators_Lead.png)

### ProgressCircle

A `ProgressCircle` can be either determinate or indeterminate.

| Determinate Progress Circle                | Indeterminate Progress Circle              |
| ------------------------------------------ | ------------------------------------------ |
| <img src="https://imgur.com/hr3dHn9.jpg"/> | <img src="https://imgur.com/NSbKqLK.gif"/> |

Here's an example of how to create an indeterminate progress circle:

```dart
ProgressCircle(
  value: null,
),
```

You can provide a non-null value to `value` to make the progress circle determinate.

### ProgressBar

A `ProgressBar` can only be determinate.

<img src="https://imgur.com/tdYgJmB.jpg" width="50%" height="50%"/>

Here's an example of how to create a determinate progress bar:

```dart
ProgressBar(
  value: 30,
)
```

## Level Indicators

A level indicator graphically represents of a specific value within a range of numeric values. It’s similar to a 
[slider](#slider) in purpose, but more visual and doesn’t contain a distinct control for selecting a value—clicking and 
dragging across the level indicator itself to select a value is supported, however. A level indicator can also include 
tick marks, making it easy for the user to pinpoint a specific value in the range. There are three different level 
indicator styles, each with a different appearance, for communicating capacity, rating, and relevance.

### CapacityIndicator

A capacity indicator illustrates the current level in relation to a finite capacity. Capacity indicators are often used 
when communicating factors like disk and battery usage. [Learn more](https://developer.apple.com/design/human-interface-guidelines/macos/indicators/level-indicators#capacity-indicators)

| Continuous                                                                                                                                     | Discrete                                                                                                                                                                                                         |
| ---------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ![Continuous CapacityIndicator Example](https://developer.apple.com/design/human-interface-guidelines/macos/images/indicators-continous.png)   | ![Discrete CapacityIndicator Example](https://developer.apple.com/design/human-interface-guidelines/macos/images/indicators-discrete.png)                                                                        |
| A horizontal translucent track that fills with a colored bar to indicate the current value. Tick marks are often displayed to provide context. | A horizontal row of separate, equally sized, rectangular segments. The number of segments matches the total capacity, and the segments fill completely—never partially—with color to indicate the current value. |

Here's an example of how to create an interactive continuous capacity indicator:

```dart
double value = 30;

CapacityIndicator(
  value: value,
  discrete: false,
  onChanged: (v) {
    setState(() => value = v);
  },
),
```

You can set `discrete` to `true` to make it a discrete capacity indicator.

### RatingIndicator

A rating indicator uses a series of horizontally arranged graphical symbols to communicate a ranking level. The default 
symbol is a star.

![RatingIndicator Example](https://developer.apple.com/design/human-interface-guidelines/macos/images/indicator-rating.png)

A rating indicator doesn’t display partial symbols—its value is rounded in order to display complete symbols only. 
Within a rating indicator, symbols are always the same distance apart and don't expand or shrink to fit the control. 
[Learn more](https://developer.apple.com/design/human-interface-guidelines/macos/indicators/level-indicators#rating-indicators)

Here's an example of how to create an interactive rating indicator:

```dart
double value = 3;

RatingIndicator(
  amount: 5,
  value: value,
  onChanged: (v) {
    setState(() => value = v);
  }
)
```

### RelevanceIndicator

A relevance indicator communicates relevancy using a series of vertical bars. It often appears in a list of search 
results for reference when sorting and comparing multiple items. [Learn more](https://developer.apple.com/design/human-interface-guidelines/macos/indicators/level-indicators#relevance-indicators)

![RelevanceIndicator Example](https://developer.apple.com/design/human-interface-guidelines/macos/images/indicator-relevance.png)

Here's an example of how to create a relevance indicator:

```dart
RelevanceIndicator(
  value: 15,
  amount: 20,
)
```

# Selectors

## MacosDatePicker

<img src="https://imgur.com/sprmep1.png" width="75%"/>

Lets the user choose a date.

There are three styles of `MacosDatePickers`:
* `textual`: a text-only date picker where the user must select the day,
  month, or year and use the caret-control buttons to change the value.
  This is useful when space in your app is constrained.
* `graphical`: a visual date picker where the user can navigate through a
  calendar-like interface to select a date.
* `combined`: provides both `textual` and `graphical` interfaces.

## MacosTimePicker

<img src="https://imgur.com/RtPbRo2.png" width="50%"/>

Lets the user choose a time.

There are three styles of `MacosTimePickers`:
* `textual`: a text-only time picker where the user must select the hour
  or minute and use the caret-control buttons to change the value.
  This is useful when space in your app is constrained.
* `graphical`: a visual time picker where the user can move the hands of a
  clock-like interface to select a time.
* `combined`: provides both `textual` and `graphical` interfaces.