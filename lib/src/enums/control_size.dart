/// The out-of-the-box sizes that certain "control" widgets can be.
///
/// <img src="https://docs-assets.developer.apple.com/published/accf80df231061eac66e07e5377e0d31/SwiftUI-View-controlSize@2x.png" width="680.5" height="256"/>
///
/// Not all controls support all sizes. For example, a [PushButton] can be any
/// size, but a [MacosSwitch] can be all but large. In cases where a control
/// doesn't support a certain size, the control will automatically fall back to
/// the nearest supported size.
///
/// Reference:
/// * https://developer.apple.com/documentation/swiftui/controlsize
/// * https://developer.apple.com/documentation/swiftui/view/controlsize(_:)
enum ControlSize {
  /// A control that is minimally sized.
  mini,

  /// A control that is proportionally smaller size for space-constrained views.
  small,

  /// A control that is the default size.
  regular,

  /// A control that is prominently sized.
  large,
}
