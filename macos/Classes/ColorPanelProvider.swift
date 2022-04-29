import FlutterMacOS

class ColorPanelProvider: NSObject, FlutterStreamHandler {
  var eventSink: FlutterEventSink?
  let colorPanel = NSColorPanel.shared

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    print("listening to ColorPanelProvider events")
//    events(colorPanel.color.asFlutterHexString)
//    events(FlutterError(code: "ERROR_CODE", message: "Could not send color", details: nil))
//    events(FlutterEndOfEventStream)
    eventSink = events
    return nil
  }

  func openPanel() {
    colorPanel.mode = NSColorPanel.Mode.RGB
    colorPanel.colorSpace = NSColorSpace.sRGB
    colorPanel.setTarget(self)
    colorPanel.setAction(#selector(startStream(colorPanel:)))
    colorPanel.makeKeyAndOrderFront(self)
    colorPanel.isContinuous = true
  }

  @objc private func currentColor() -> String {
    print("currentColor: \(colorPanel.color.asFlutterHexString)")
    return colorPanel.color.asFlutterHexString
  }

  @objc public func startStream(colorPanel: NSColorPanel) {
    print("starting ColorPanelProvider stream")
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(currentColor),
      name: NSColorPanel.colorDidChangeNotification,
      object: colorPanel)
    
    eventSink?(currentColor())
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    print("cancelling ColorPanelProvider stream")
    eventSink = nil
    return nil
  }
}

extension NSColor {
  var asFlutterHexString: String {
    let red = Int(round(self.redComponent * 0xFF))
    let green = Int(round(self.greenComponent * 0xFF))
    let blue = Int(round(self.blueComponent * 0xFF))
    let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
    return hexString.replacingOccurrences(of: "#", with: "0xFF") as String
  }
}
