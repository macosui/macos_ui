# Contributing to macos_ui

Thanks for checking out `macos_ui`! We appreciate your interest in contributing! Here are some 
basic things you'll need to know to get started.

## Branch structure

The default branch for this project is `dev`. Your work should take place in a branch checked out
from here. `stable` is reserved for releases to pub.dev. All pull requests should therefore
target `dev`.

`dev`, `stable`, and `customer_testing` are protected branches.

### The `stable` Branch
This branch is solely for pub releases. Only authorized maintainers may make pull requests to this branch.

### The `customer_testing` branch
This branch is the ***only*** branch in this repository based on Flutter's `master` channel; every other branch is based on Flutter's `stable` channel. This is so that `macos_ui` can be included in Flutter's [tests](https://github.com/flutter/tests) repo. It is beneficial for `macos_ui` to be included there so that if any changes are introduced to Flutter that break `macos_ui`, we will be informed and can make the appropriate changes.

Only authorized maintainers may make pull requests to this branch.

## Commit style
This repository uses [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/). Please ensure that you use them!

## Pull Requests
As mentioned above, all pull requests should target `dev`.

Before opening your pull request, please ensure that the following requirements are met:
* You have run `flutter pub get` at the package level
* You have incremented the version number in `pubspec.yaml` properly
* You have updated the `CHANGELOG.md` file accordingly
* All code is properly formatted
* There are no Dart analysis warnings
* All tests pass

A note for authorized maintainers: Pull requests should **always** be merged via GitHub and not via command-line.

### Versioning

`macos_ui` uses semantic versioning. Please ensure your updates follow this method accordingly.  
