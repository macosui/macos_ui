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

    self.isOpaque = false
    self.backgroundColor = .clear
    let contentView = contentViewController!.view;
    let superView = contentView.superview!;
    let blurView = NSVisualEffectView()
    blurView.frame = superView.bounds
    blurView.autoresizingMask = [.width, .height]
    blurView.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
    if #available(macOS 10.14, *) {
      blurView.material = .underWindowBackground
    }
    superView.replaceSubview(contentView, with: blurView)
    blurView.addSubview(contentView)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
