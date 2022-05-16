# macosui_starter

![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)

A starter Flutter application for macOS that uses [`macos_ui`](https://pub.dev/packages/macos_ui).

<img src='https://imgur.com/rG4uDKs.png' />

## 🚧 Prerequisites
* Your Flutter version should be at least 3.0
* You should have `mason_cli` installed

## Usage 🚀
```sh
mason make macosui_starter
```

You'll be prompted for the following information:
* The name of your app
* Your app's description
* The name of your organization
* Whether to use window transclucency
* Whether to show or hide the native titlebar

⚠️ **Please note**: if you opt to use window transclucency you will not be asked if you want to show or hide the native 
titlebar, as it will be hidden by default.

## Variables ✨

| Variable                 | Description                                   | Default                                                 | Type      |
|--------------------------|-----------------------------------------------|---------------------------------------------------------|-----------|
| `app_name`               | The name of your app                          | `macosui_starter`                                       | `string`  |
| `app_description`        | The description of your application           | `A starter Flutter application for macOS with macos_ui` | `string`  |
| `org_name`               | The name of your organization                 | `com.example`                                           | `string`  |
| `use_translucency`       | Whether to use window transclucency           | `false`                                                 | `boolean` |
| `debug_label_on`         | Whether to show the debug label by default    | `false`                                                 | `boolean` |
| `custom_system_menu_bar` | Whether to add a basic custom system menu bar | `false`                                                 | `boolean` |

Setting `custom_system_menu_bar` to `true` will add a basic custom system menu bar to your application, which looks 
like this:

<img src='https://imgur.com/yV7RR2E.png' />

## Output 📦

A Flutter application that:
* Targets macOS (support for other platforms can be added manually)
* Has `macos_ui` pre-installed
* Builds basic UI based on the latest version of `macos_ui` 