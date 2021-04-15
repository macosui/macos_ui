# macos_ui

Implements Apple's macOS Design System in Flutter. Based on the official documentation.

## Content
- [macos_ui](#macos_ui)
  - [Content](#content)
  - [Resources](#resources)
- [Layout](#layout)
  - [Scaffold](#scaffold)
- [Buttons](#buttons)
  - [Switch](#switch)
- [Indicators](#indicators)
  - [ProgressCircle](#progress_circle)
  - [ProgressBar](#progress_bar)

## Resources

* [macOS Design Resources](https://developer.apple.com/design/resources/)
* [macOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos)

# Layout
## Scaffold
`Scaffold` provides a basic structure for laying out widgets in a way you would expect on macOS. 
You must specify a `body` as the main content area, and you can optionally provide a `sidebar` 
that will show to the left of `body`. The `sidebar` can be resized by grabbing the split and 
dragging left or right. See the documentation for all customization options.

<img src="https://imgur.com/e41j2aT.jpg" width="75%"/>

<img src="https://imgur.com/jTPXGuq.gif" width="75%"/>

# Buttons
## Switch
<img src="https://imgur.com/IBh5jkz.jpg" />

<img src="https://imgur.com/qK1VCVr.jpg" />

# Indicators
## ProgressCircle
A `ProgressCircle` can be either determinate or indeterminate. If indeterminate, Flutter's
`CupertinoActivityIndicator` will be shown.

<img src="https://imgur.com/hr3dHn9.jpg" />

<img src="https://imgur.com/LOO9GEj.gif" />

## ProgressBar

<img src="https://imgur.com/tdYgJmB.jpg" />
