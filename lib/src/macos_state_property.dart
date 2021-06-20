enum MacosState { disabled, hovered, pressed, focused, none }

/// Signature for the function that returns a value of type `T` based on a given
/// set of states.
typedef MacosStatePropertyResolver<T> = T Function(Set<MacosState> states);

abstract class MacosStateProperty<T> {
  T resolve(Set<MacosState> states);

  static MacosStateProperty<T> all<T>(T value) => _AllMacosStateProperty(value);

  static MacosStateProperty<T> resolveWith<T>(
      MacosStatePropertyResolver<T> callback) {
    return _MacosStateProperty(callback);
  }

  static MacosStateProperty<T?>? lerp<T>(
    MacosStateProperty<T?>? a,
    MacosStateProperty<T?>? b,
    double t,
    T? Function(T?, T?, double) lerpFunction,
  ) {
    if (a == null && b == null) return null;
    return _LerpProperties<T>(a, b, t, lerpFunction);
  }
}

class _MacosStateProperty<T> extends MacosStateProperty<T> {
  _MacosStateProperty(this._resolve);

  final MacosStatePropertyResolver<T> _resolve;

  @override
  T resolve(Set<MacosState> states) => _resolve(states);
}

class _AllMacosStateProperty<T> extends MacosStateProperty<T> {
  _AllMacosStateProperty(this._value);

  final T _value;

  @override
  T resolve(states) => _value;
}

class _LerpProperties<T> implements MacosStateProperty<T?> {
  const _LerpProperties(this.a, this.b, this.t, this.lerpFunction);

  final MacosStateProperty<T?>? a;
  final MacosStateProperty<T?>? b;
  final double t;
  final T? Function(T?, T?, double) lerpFunction;

  @override
  T? resolve(Set<MacosState> states) {
    final T? resolvedA = a?.resolve(states);
    final T? resolvedB = b?.resolve(states);
    return lerpFunction(resolvedA, resolvedB, t);
  }
}

extension MacosStateExtension on Set<MacosState> {
  bool get isFocused => contains(MacosState.focused);
  bool get isDisabled => contains(MacosState.disabled);
  bool get isPressed => contains(MacosState.pressed);
  bool get isHovered => contains(MacosState.hovered);
  bool get isNone => isEmpty;
}
