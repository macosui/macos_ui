import FlutterMacOS

class ColorPanelProvider: NSObject, FlutterStreamHandler {
  var eventSink: FlutterEventSink?
  let colorPanel = NSColorPanel.shared

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }

  func openPanel(pickerMode: String) {
    setPickerMode(panelMode: pickerMode.components(separatedBy: ".").last!)
    colorPanel.setTarget(self)
    colorPanel.setAction(#selector(startStream(colorPanel:)))
    colorPanel.makeKeyAndOrderFront(self)
    colorPanel.isContinuous = true
    colorPanel.isReleasedWhenClosed = true
  }
  
  func setPickerMode(panelMode: String) {
    switch (panelMode) {
    case "gray":
      NSColorPanel.setPickerMode(NSColorPanel.Mode.gray)
    case "RBG":
      NSColorPanel.setPickerMode(NSColorPanel.Mode.RGB)
    case "CMYK":
      NSColorPanel.setPickerMode(NSColorPanel.Mode.CMYK)
    case "HSB":
      NSColorPanel.setPickerMode(NSColorPanel.Mode.HSB)
    case "customPalette":
      NSColorPanel.setPickerMode(NSColorPanel.Mode.customPalette)
    case "colorList":
      NSColorPanel.setPickerMode(NSColorPanel.Mode.colorList)
    case "wheel":
      NSColorPanel.setPickerMode(NSColorPanel.Mode.wheel)
    case "crayon":
      NSColorPanel.setPickerMode(NSColorPanel.Mode.crayon)
    default:
      NSColorPanel.setPickerMode(NSColorPanel.Mode.none)
    }
  }

  @objc private func currentColor() -> String {
    return colorPanel.color.asFlutterHexString
  }

  @objc public func startStream(colorPanel: NSColorPanel) {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(currentColor),
      name: NSColorPanel.colorDidChangeNotification,
      object: colorPanel)
    
    eventSink?(currentColor())
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
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
