import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    if #available(macOS 10.13, *) {
      let customToolbar = NSToolbar()
      customToolbar.showsBaselineSeparator = false
      self.toolbar = customToolbar
    }
    self.titleVisibility = .hidden
    self.titlebarAppearsTransparent = true
    if #available(macOS 11.0, *) {
      self.toolbarStyle = .unified
    }

    self.isMovableByWindowBackground = true
    self.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
