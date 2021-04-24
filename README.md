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

* [macOS Design Resources](https://developer.apple.com/design/resources/)
* [macOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos)
* [macOS Big Sur Figma kit](https://www.figma.com/file/M6K5L3GK0WJh6pnsASyVeE/macOS-Big-Sur-UI-Kit?node-id=1%3A2)

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

| off | on | mixed |
| --- | -- | ----- |
| ![](https://developer.apple.com/design/human-interface-guidelines/macos/images/CheckBoxes_Deselected.svg) | ![](https://developer.apple.com/design/human-interface-guidelines/macos/images/CheckBoxes_Selected.svg) | ![](https://developer.apple.com/design/human-interface-guidelines/macos/images/CheckBoxes_Mixed.svg) |

## RadioButton

![](https://developer.apple.com/design/human-interface-guidelines/macos/images/radioButtons.png)

## PushButton

<img src="https://imgur.com/v99ekWA.jpg"/>
<img src="https://imgur.com/GsShoF6.jpg"/>
<img src="https://imgur.com/TgfjJdQ.jpg"/>
<img src="https://imgur.com/wt0K6u4.jpg"/>
<img src="https://imgur.com/hj6uGhI.jpg"/>
<img src="https://imgur.com/klWHTAX.jpg"/>
<img src="https://imgur.com/83cEMeP.jpg"/>
<img src="https://imgur.com/7khWnwt.jpg"/>

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
