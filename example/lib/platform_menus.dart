import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' as io;

import 'package:flutter/widgets.dart'
    show
        PlatformMenu,
        PlatformMenuItem,
        PlatformProvidedMenuItem,
        PlatformProvidedMenuItemType;

List<PlatformMenuItem> menuBarItems() {
  if (kIsWeb) {
    return [];
  } else {
    if (io.Platform.isMacOS) {
      return const [
        PlatformMenu(
          label: 'macos_ui Widget Gallery',
          menus: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.about,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.quit,
            ),
          ],
        ),
        PlatformMenu(
          label: 'View',
          menus: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.toggleFullScreen,
            ),
          ],
        ),
        PlatformMenu(
          label: 'Window',
          menus: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.minimizeWindow,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.zoomWindow,
            ),
          ],
        ),
      ];
    } else {
      return [];
    }
  }
}
