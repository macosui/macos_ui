/// The predefined visual styles and interactions that a button can have.
///
/// Reference:
/// * https://developer.apple.com/documentation/swiftui/primitivebuttonstyle
enum ButtonStyle {
  bordered, // a standard button
  borderedProminent, // a primary button (system accent color)
  borderless,
  link, // no background color, text styled with link-color
  plain,
}
