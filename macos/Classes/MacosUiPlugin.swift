import Cocoa
import FlutterMacOS
import AppKit

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
    case "accent_color":
    if #available(macOS 10.13, *) {
      let accentColor = getSystemAccentColor()
      let hexColor = accentColor.usingColorSpace(NSColorSpace.deviceRGB) ?? accentColor
      result(hexColor.asFlutterHexString)
    } else {
      result(FlutterError())
    }
    case "color_panel":
      if let arguments = call.arguments as? Dictionary<String, Any> {
        let mode = arguments["mode"] as? String
        colorPanelProvider.openPanel(pickerMode: mode!)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
  
  @available(macOS 10.13, *)
  public func getSystemAccentColor() -> NSColor {
//    var colorName: String = ""
//    var colorNumber: String = ""
//
//    // This runs if the Mac is an M1 iMac and the user is using the "This Mac" option.
//    if UserDefaults.standard.bool(forKey: "NSColorSimulateHardwareAccent") && UserDefaults.standard.object(forKey: "AppleAccentColor") == nil {
//      colorNumber = "M1 iMac: \(UserDefaults.standard.string(forKey: "NSColorSimulatedHardwareEnclosureNumber") ?? "no color returned")"
//
//      switch UserDefaults.standard.string(forKey: "NSColorSimulatedHardwareEnclosureNumber") ?? "No iMac color returned" {
//        case "3":
//            colorName = "iMac Yellow"
//        case "4":
//            colorName = "iMac Green"
//        case "5":
//            colorName = "iMac Blue"
//        case "6":
//            colorName = "iMac Pink"
//        case "7":
//            colorName = "iMac Purple"
//        case "8":
//            colorName = "iMac Orange"
//        default:
//            colorName = "No iMac color returned"
//            colorNumber = "No iMac color returned"
//        }
//    } else {
//      // This runs if the Mac is not an M1 iMac or an M1 iMac is using the standard color options.
//      colorNumber = "Regular: \(UserDefaults.standard.string(forKey: "AppleAccentColor") ?? "no color returned")"
//
//      switch UserDefaults.standard.string(forKey: "AppleAccentColor") ?? "No color returned" {
//        case "4":
//            colorName = "Blue"
//        case "5":
//            colorName = "Purple"
//        case "6":
//            colorName = "Pink"
//        case "0":
//            colorName = "Red"
//        case "1":
//            colorName = "Orange"
//        case "2":
//            colorName = "Yellow"
//        case "3":
//            colorName = "Green"
//        case "-1":
//            colorName = "Graphite"
//        case "-2":
//            colorName = "Multicolor"
//        default:
//            colorName = "No regular color returned"
//        }
//    }
//
//    if determineIfMulticolor() {
//      colorName = "Multicolor"
//    }
            
    let MacAccentColor = (NSColor.value(forKey: "controlAccentColor") as? NSColor ?? NSColor(named: "AccentColor")!)
    
    return MacAccentColor
  }
  
//  func determineIfMulticolor() -> Bool {
//    var toReturn = false
//    if UserDefaults.standard.bool(forKey: "NSColorSimulateHardwareAccent") {
//      if UserDefaults.standard.string(forKey: "AppleAccentColor") ?? "No color returned" == "-2" {
//          toReturn = true
//      }
//    } else if UserDefaults.standard.object(forKey: "AppleAccentColor") == nil {
//      toReturn = true
//    }
//    return toReturn
//  }
}
