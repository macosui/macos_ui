import Cocoa
import FlutterMacOS

public class MacOSUiPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private let colorPanelProvider: ColorPanelProvider
  private var eventSink: FlutterEventSink?

  init(colorPanelProvider: ColorPanelProvider) {
    self.colorPanelProvider = colorPanelProvider
    super.init()
  }
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "dev.groovinchip.macos_ui",
      binaryMessenger: registrar.messenger)

    let colorSelectionChannel = FlutterEventChannel(
      name: "dev.groovinchip.macos_ui/color_panel",
      binaryMessenger: registrar.messenger)
  
    let colorPanelProvider = ColorPanelProvider()
      
    let instance = MacOSUiPlugin(colorPanelProvider: colorPanelProvider)
    colorSelectionChannel.setStreamHandler(colorPanelProvider)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "color_panel":
      colorPanelProvider.openPanel()
      //result(eventSink)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    print("listening to MacosUIPluginEvents")
    eventSink = events
    //colorPanelProvider.startStream()
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}

extension NSColor {
  var hexString: String {
    let red = Int(round(self.redComponent * 0xFF))
    let green = Int(round(self.greenComponent * 0xFF))
    let blue = Int(round(self.blueComponent * 0xFF))
    let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
    return hexString as String
  }
}
