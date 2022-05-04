# Contributing to macos_ui

Thanks for checking out `macos_ui`! We appreciate your interest in contributing! Here are some 
basic things you'll need to know to get started.

### Branch structure

The default branch for this project is `dev`. Your work should take place in a branch checked out
from here. `stable` is reserved for releases to pub.dev. All pull requests should therefore
target `dev`.

`dev` and `stable` are protected branches.

### Commit style
This repository uses [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/). Please ensure that you use them!

### Pull Requests
As mentioned above, all pull requests should target `dev`.

#### Pre-launch script
Before opening your pull request, run the `pr_prelaunch_tasks.sh` script to ensure that your changes meet the 
following requirements:
* All code is properly formatted
* There are no Dart analysis warnings
* All tests pass

If the format step of the script results in changes, the script will make those change, commit them, and prompt you to push the commit.

If the `dart fix` step results in changes, the script will make those changes, commit them, and prompt you to push the commit.

Pull requests should **always** be merged via GitHub and not via command-line.

### Versioning

`macos_ui` uses semantic versioning. Please ensure your updates follow this method accordingly.  