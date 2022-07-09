import 'package:flutter/widgets.dart';

/// {@template macosTabController}
/// Coordinates tab selection for [MacosSegmentedControl] and [MacosTabView].
///
/// The [index] property is the index of the selected tab.
///
/// A stateful widget that builds a [MacosSegmentedControl] and a
/// [MacosTabView] can create a MacosTabController and share it between them.
/// {@endtemplate}
class MacosTabController extends ChangeNotifier {
  /// {@macro macosTabController}
  MacosTabController({
    int initialIndex = 0,
    required this.length,
  })  : assert(length >= 0),
        assert(initialIndex >= 0 && (length == 0 || initialIndex < length)),
        _index = initialIndex,
        _previousIndex = initialIndex;

  /// The total number of tabs.
  ///
  /// Typically greater than one. Must match [MacosTabView.tabs]'s and
  /// [MacosTabView.children]'s length.
  final int length;

  void _changeIndex(int value) {
    assert(value >= 0 && (value < length || length == 0));
    if (value == _index || length < 2) {
      return;
    }
    _previousIndex = index;
    _index = value;
    notifyListeners();
  }

  /// The index of the currently selected tab.
  ///
  /// Changing the index also updates [previousIndex] and notifies listeners.
  int get index => _index;
  int _index;
  set index(int value) {
    _changeIndex(value);
  }

  /// The index of the previously selected tab.
  ///
  /// Initially the same as index.`
  int get previousIndex => _previousIndex;
  int _previousIndex;
}
