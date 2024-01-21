import 'dart:async';

import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/selectors/caret_painters.dart';
import 'package:macos_ui/src/selectors/graphical_time_picker_painter.dart';
import 'package:macos_ui/src/selectors/keyboard_shortcut_runner.dart';

/// Defines the possibles [MacosTimePicker] styles.
enum TimePickerStyle {
  /// A text-only variant of the time picker.
  textual,

  /// A graphical variant of the time picker.
  graphical,

  /// Combines both the [textual] and [graphical] styles.
  combined,
}

/// {template onTimeChanged}
/// The action to perform when a new time is selected.
/// {end-template}
typedef OnTimeChanged = void Function(TimeOfDay time);

/// {template macosTimePicker}
/// A [MacosTimePicker] lets the user choose a time.
///
/// There are three types of [MacosTimePicker]s:
/// * `textual`: a text-only time picker where the user must select the hour,
///   or minute and use the caret-control buttons to change the value.
///   This is useful when space in your app is constrained.
/// * `graphical`: a visual time picker where the user can move the hands of a
///   clock-like interface to select a time.
/// * `combined`: provides both `textual` and `graphical` interfaces.
///
/// The [onTimeChanged] callback passes through the user's selected time, and
/// must be provided.
/// {end-template}
class MacosTimePicker extends StatefulWidget {
  /// {@macro macosTimePicker}
  const MacosTimePicker({
    super.key,
    required this.onTimeChanged,
    this.initialTime,
    this.style = TimePickerStyle.combined,
  });

  /// Set an initial date for the picker.
  ///
  /// Defaults to `TimeOfDay.now()`.
  final TimeOfDay? initialTime;

  /// The [TimePickerStyle] to use.
  ///
  /// Defaults to [TimePickerStyle.combined].
  final TimePickerStyle style;

  /// {@macro onTimeChanged}
  final OnTimeChanged onTimeChanged;

  @override
  State<MacosTimePicker> createState() => _MacosTimePickerState();
}

class _MacosTimePickerState extends State<MacosTimePicker> {
  late final _initialTime = widget.initialTime ?? TimeOfDay.now();
  late int _selectedHour;
  late int _selectedMinute;
  late DayPeriod _selectedPeriod;
  bool _isHourSelected = false;
  bool _isMinuteSelected = false;
  bool _isPeriodSelected = false;
  late MaterialLocalizations localizations = MaterialLocalizations.of(context);
  late var time = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    _selectedHour,
    _selectedMinute,
    DateTime.now().second,
  );
  late final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _parseInitialTime();
    if (widget.style == TimePickerStyle.graphical ||
        widget.style == TimePickerStyle.combined) {
      Timer.periodic(const Duration(seconds: 1), update);
    }
  }

  void update(Timer timer) {
    if (mounted) {
      time = time.add(const Duration(seconds: 1) * timer.tick);
      setState(() {});
    }
  }

  void _parseInitialTime() {
    _selectedHour = _initialTime.hour;
    _selectedMinute = _initialTime.minute;
    _selectedPeriod = _initialTime.period;
  }

  TimeOfDay _formatAsTimeOfDay() {
    return TimeOfDay(hour: _selectedHour, minute: _selectedMinute);
  }

  void _incrementElement() {
    if (_isHourSelected) {
      if (_selectedHour + 1 >= 24) {
        setState(() {
          _selectedHour = 0;
          _selectedPeriod = DayPeriod.am;
        });
      } else {
        if (_selectedHour + 1 >= 12) {
          setState(() {
            _selectedHour++;
            _selectedPeriod = DayPeriod.pm;
          });
        } else {
          setState(() => _selectedHour++);
        }
      }
    } else if (_isMinuteSelected) {
      if (_selectedMinute + 1 > 59) {
        setState(() => _selectedMinute = 0);
      } else {
        setState(() => _selectedMinute++);
      }
    } else {
      if (_selectedPeriod == DayPeriod.am) {
        setState(() {
          _selectedHour = _selectedHour + 12;
          _selectedPeriod = DayPeriod.pm;
        });
      } else {
        setState(() {
          _selectedHour = _selectedHour - 12;
          _selectedPeriod = DayPeriod.am;
        });
      }
    }
    widget.onTimeChanged.call(_formatAsTimeOfDay());
  }

  void _decrementElement() {
    if (_isHourSelected) {
      if (_selectedHour - 1 < 0) {
        setState(() {
          _selectedHour = 23;
          _selectedPeriod = DayPeriod.pm;
        });
      } else {
        if (_selectedHour - 1 < 12) {
          setState(() {
            _selectedHour--;
            _selectedPeriod = DayPeriod.am;
          });
        } else {
          setState(() => _selectedHour--);
        }
      }
    } else if (_isMinuteSelected) {
      if (_selectedMinute - 1 < 0) {
        setState(() => _selectedMinute = 59);
      } else {
        setState(() => _selectedMinute--);
      }
    } else {
      if (_selectedPeriod == DayPeriod.pm) {
        setState(() {
          _selectedHour = _selectedHour - 12;
          _selectedPeriod = DayPeriod.am;
        });
      } else {
        setState(() {
          _selectedHour = _selectedHour + 12;
          _selectedPeriod = DayPeriod.pm;
        });
      }
    }
    widget.onTimeChanged.call(_formatAsTimeOfDay());
  }

  Widget _buildTextualTimePicker(
    MacosTimePickerThemeData timePickerTheme,
    MaterialLocalizations localizations,
  ) {
    return KeyboardShortcutRunner(
      onUpArrowKeypress: _incrementElement,
      onDownArrowKeypress: _decrementElement,
      focusNode: _focusNode,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhysicalModel(
            color: timePickerTheme.shadowColor!,
            elevation: 1,
            child: ColoredBox(
              color: timePickerTheme.backgroundColor!,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 3.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TimePickerFieldElement(
                      isSelected: _isHourSelected,
                      element: localizations.formatHour(
                        TimeOfDay(
                          hour: _selectedHour,
                          minute: _selectedMinute,
                        ),
                      ),
                      onSelected: () {
                        setState(() {
                          _focusNode.requestFocus();
                          _isHourSelected = !_isHourSelected;
                          _isMinuteSelected = false;
                          _isPeriodSelected = false;
                        });
                      },
                    ),
                    const Text(':'),
                    TimePickerFieldElement(
                      isSelected: _isMinuteSelected,
                      element: localizations.formatMinute(
                        TimeOfDay(
                          hour: _selectedHour,
                          minute: _selectedMinute,
                        ),
                      ),
                      onSelected: () {
                        setState(() {
                          _focusNode.requestFocus();
                          _isMinuteSelected = !_isMinuteSelected;
                          _isHourSelected = false;
                          _isPeriodSelected = false;
                        });
                      },
                    ),
                    const Text(' '),
                    TimePickerFieldElement(
                      isSelected: _isPeriodSelected,
                      element: _selectedPeriod == DayPeriod.am ? 'AM' : 'PM',
                      onSelected: () {
                        setState(() {
                          _focusNode.requestFocus();
                          _isPeriodSelected = !_isPeriodSelected;
                          _isHourSelected = false;
                          _isMinuteSelected = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 4.0),
          Column(
            children: [
              SizedBox(
                height: 10.0,
                width: 12.0,
                child: IgnorePointer(
                  ignoring: !_isHourSelected &&
                      !_isMinuteSelected &&
                      !_isPeriodSelected,
                  child: GestureDetector(
                    onTap: _incrementElement,
                    child: PhysicalModel(
                      color: timePickerTheme.shadowColor!,
                      elevation: 1,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(5.0),
                      ),
                      child: CustomPaint(
                        painter: UpCaretPainter(
                          color: timePickerTheme.caretColor!,
                          backgroundColor:
                              timePickerTheme.caretControlsBackgroundColor!,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1.0,
                child: ColoredBox(
                  color: timePickerTheme.caretControlsSeparatorColor!,
                ),
              ),
              SizedBox(
                height: 10.0,
                width: 12.0,
                child: IgnorePointer(
                  ignoring: !_isHourSelected &&
                      !_isMinuteSelected &&
                      !_isPeriodSelected,
                  child: GestureDetector(
                    onTap: _decrementElement,
                    child: PhysicalModel(
                      color: timePickerTheme.shadowColor!,
                      elevation: 1,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(5.0),
                      ),
                      child: CustomPaint(
                        painter: DownCaretPainter(
                          color: timePickerTheme.caretColor!,
                          backgroundColor:
                              timePickerTheme.caretControlsBackgroundColor!,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGraphicalTimePicker(MacosTimePickerThemeData timePickerTheme) {
    const clockHeight = 116.0;
    const clockWidth = 115.0;
    return SizedBox(
      height: clockHeight,
      width: clockWidth,
      child: CustomPaint(
        painter: GraphicalTimePickerPainter(
          clockHeight: clockHeight,
          time: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            _selectedHour,
            _selectedMinute,
            DateTime.now().second,
          ),
          dayPeriod: _selectedPeriod == DayPeriod.am ? 'AM' : 'PM',
          theme: timePickerTheme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timePickerTheme = MacosTimePickerTheme.of(context);
    final localizations = MaterialLocalizations.of(context);

    switch (widget.style) {
      case TimePickerStyle.textual:
        return _buildTextualTimePicker(timePickerTheme, localizations);
      case TimePickerStyle.graphical:
        return _buildGraphicalTimePicker(timePickerTheme);
      case TimePickerStyle.combined:
        return Column(
          children: [
            _buildTextualTimePicker(timePickerTheme, localizations),
            const SizedBox(height: 16),
            _buildGraphicalTimePicker(timePickerTheme),
          ],
        );
    }
  }
}

class TimePickerFieldElement extends StatelessWidget {
  const TimePickerFieldElement({
    super.key,
    required this.element,
    required this.onSelected,
    required this.isSelected,
  });

  final String element;
  final VoidCallback onSelected;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final timePickerTheme = MacosTimePickerTheme.of(context);
    Color backgroundColor = isSelected
        ? timePickerTheme.selectedElementColor!
        : MacosColors.transparent;
    Color textColor = isSelected
        ? timePickerTheme.selectedElementTextColor!
        : MacosTheme.of(context).typography.body.color!;
    return GestureDetector(
      onTap: onSelected,
      child: ColoredBox(
        color: backgroundColor,
        child: Text(
          element,
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.08,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
