class ButtonStates {
  const ButtonStates._(this.id);

  final String id;

  static const ButtonStates disabled = ButtonStates._('disabled');
  static const ButtonStates hovering = ButtonStates._('hovering');
  static const ButtonStates pressing = ButtonStates._('pressing');
  static const ButtonStates focused = ButtonStates._('focused');
  static const ButtonStates none = ButtonStates._('none');

  bool get isDisabled => this == disabled;
  bool get isHovering => this == hovering;
  bool get isPressing => this == pressing;
  bool get isFocused => this == focused;
  bool get isNone => this == none;
}

typedef ButtonState<T> = T Function(ButtonStates);