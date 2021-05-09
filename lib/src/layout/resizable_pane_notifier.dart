import 'package:flutter/foundation.dart';

class ResizablePaneNotifier extends ValueNotifier<Map<Key, double>> {
  /// Creates a [ValueNotifier] that wraps this [value] for a [ResizablePane]
  ResizablePaneNotifier(Map<Key, double> value) : super(value);

  /// Clears all entries from the [value] map.
  ///
  /// [notify] is set to true by default. It specifies whether
  /// [notifyListeners] will be called at the end of the method.
  void reset({bool notify = true}) {
    value.clear();
    if (notify) notifyListeners();
  }

  /// Removes [key] and its associated [width], if present, from [value].
  ///
  /// [notify] is set to true by default. It specifies whether
  /// [notifyListeners] will be called at the end of the method.
  void remove(Key key, {bool notify = true}) {
    value.remove(key);
    if (notify) notifyListeners();
  }

  /// Updates the [value] map with the provided [key] and [width] pair.
  ///
  /// [notify] is set to true by default. It specifies whether
  /// [notifyListeners] will be called at the end of the method.
  void update(Key key, double width, {bool notify = true}) {
    value[key] = width;
    if (notify) notifyListeners();
  }

  /// Calls [notifyListeners] to update the listeners of the [ValueNotifier]
  void notify() => notifyListeners();
}
