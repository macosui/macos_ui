import Cocoa
import FlutterMacOS
{{#use_translucency}}
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

class MainFlutterWindow: NSWindow, NSWindowDelegate {
  override func awakeFromNib() {
    delegate = self
    let blurryContainerViewController = BlurryContainerViewController()
    let windowFrame = self.frame
    self.contentViewController = blurryContainerViewController
    self.setFrame(windowFrame, display: true)

    if #available(macOS 10.13, *) {
      let customToolbar = NSToolbar()
      customToolbar.showsBaselineSeparator = false
      self.toolbar = customToolbar
    }

    {{#hide_native_title_bar}}self.titleVisibility = .hidden{{/hide_native_title_bar}}
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

  func windowWillEnterFullScreen(_ notification: Notification) {
      self.toolbar?.isVisible = false
  }
  
  func windowDidExitFullScreen(_ notification: Notification) {
      self.toolbar?.isVisible = true
  }
}
{{/use_translucency}}{{^use_translucency}}
class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    {{#hide_native_title_bar}}self.titleVisibility = .hidden
    self.titlebarAppearsTransparent = true
    self.isMovableByWindowBackground = true
    self.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
    {{/hide_native_title_bar}}
    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
{{/use_translucency}}
