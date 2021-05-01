# macos_ui

Implements Apple's macOS Design System in Flutter. Based on the official documentation.

## Content

- [macos_ui](#macos_ui)
  - [Content](#content)
  - [Contributing](#contributing)
  - [Resources](#resources)
- [Layout](#layout)
  - [Scaffold](#scaffold)
- [Buttons](#buttons)
  - [Checkbox](#checkbox)
  - [RadioButton](#radiobutton)
  - [PushButton](#pushbutton)
  - [Switch](#switch)
- [Indicators](#indicators)
  - [ProgressCircle](#progresscircle)
  - [ProgressBar](#progressbar)

## Contributing

macOS welcomes contributions. Please see CONTRIBUTING.md for more information.

## Resources

- [macOS Design Resources](https://developer.apple.com/design/resources/)
- [macOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos)
- [macOS Big Sur Figma kit](https://www.figma.com/file/M6K5L3GK0WJh6pnsASyVeE/macOS-Big-Sur-UI-Kit?node-id=1%3A2)

# Layout

## Scaffold

`Scaffold` provides a basic structure for laying out widgets in a way you would expect on macOS.
You must specify a `body` as the main content area, and you can optionally provide a `sidebar`
that will show to the left of `body`. The `sidebar` can be resized by grabbing the split and
dragging left or right. See the documentation for all customization options.

<img src="https://imgur.com/e41j2aT.jpg" width="75%"/>

<img src="https://imgur.com/jTPXGuq.gif" width="75%"/>

# Buttons

## Checkbox

A checkbox is a type of button that lets the user choose between two opposite states, actions, or values. A selected checkbox is considered on when it contains a checkmark and off when it's empty. A checkbox is almost always followed by a title unless it appears in a checklist. [Learn more](https://developer.apple.com/design/human-interface-guidelines/macos/buttons/checkboxes/)

| Off                                                                                                                   | On                                                                                                                 | Mixed                                                                                                              |
| --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------ |
| ![Off Checkbox](https://developer.apple.com/design/human-interface-guidelines/macos/images/CheckBoxes_Deselected.svg) | ![On Checkbox](https://developer.apple.com/design/human-interface-guidelines/macos/images/CheckBoxes_Selected.svg) | ![Mixed Checkbox](https://developer.apple.com/design/human-interface-guidelines/macos/images/CheckBoxes_Mixed.svg) |

Here's an example of how to create a basic checkbox:

```dart
bool selected = false;

Checkbox(
  value: selected,
  onChanged: (value) {
    setState(() => selected = value);
  },
)
```

To make a checkbox in the `mixed` state, set `value` to `null`.

## RadioButton

A radio button is a small, circular button followed by a title. Typically presented in groups of two to five, radio buttons provide the user a set of related but mutually exclusive choices. A radio button’s state is either on (a filled circle) or off (an empty circle). [Learn more](https://developer.apple.com/design/human-interface-guidelines/macos/buttons/radio-buttons/)

![RadioButton Preview](https://developer.apple.com/design/human-interface-guidelines/macos/images/radioButtons.png)

Here's an example of how to create a basic radio button:

```dart
bool selected = false;

RadioButton(
  value: selected,
  onChanged: (value) {
    setState(() => selected = value);
  },
),
```

## PushButton

A push button appears within a view and initiates an instantaneous app-specific action, such as printing a document or deleting a file. Push buttons contain text—not icons—and often open a separate window, dialog, or app so the user can complete a task. [Learn more](https://developer.apple.com/design/human-interface-guidelines/macos/buttons/push-buttons/)

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

## Switch

<img src="https://imgur.com/IBh5jkz.jpg" width="50%" height="50%"/>

<img src="https://imgur.com/qK1VCVr.jpg" width="50%" height="50%"/>

# Indicators

## ProgressCircle

A `ProgressCircle` can be either determinate or indeterminate. If indeterminate, Flutter's
`CupertinoActivityIndicator` will be shown.

<img src="https://imgur.com/hr3dHn9.jpg" width="50%" height="50%"/>

<img src="https://imgur.com/NSbKqLK.gif" width="50%" height="50%"/>

## ProgressBar

<img src="https://imgur.com/tdYgJmB.jpg" width="50%" height="50%"/>
