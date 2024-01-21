import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/selectors/caret_painters.dart';
import 'package:macos_ui/src/selectors/keyboard_shortcut_runner.dart';

/// Defines the possibles [MacosDatePicker] styles.
enum DatePickerStyle {
  /// A text-only date picker.
  textual,

  /// A graphical-only date picker.
  graphical,

  /// A text-and-graphical date picker.
  combined,
}

/// {template onDateChanged}
/// The action to perform when a new date is selected.
/// {endtemplate}
typedef OnDateChanged = void Function(DateTime date);

/// {template macosDatePicker}
/// A [MacosDatePicker] lets the user choose a date.
///
/// There are three types of [MacosDatePicker]s:
/// * `textual`: a text-only date picker where the user must select the day,
///   month, or year and use the caret-control buttons to change the value.
///   This is useful when space in your app is constrained.
/// * `graphical`: a visual date picker where the user can navigate through a
///   calendar-like interface to select a date.
/// * `combined`: provides both `textual` and `graphical` interfaces.
///
/// The [onDateChanged] callback passes through the user's selected date, and
/// must be provided.
/// {endtemplate}
class MacosDatePicker extends StatefulWidget {
  /// {macro macosDatePicker}
  const MacosDatePicker({
    super.key,
    this.style = DatePickerStyle.combined,
    required this.onDateChanged,
    this.initialDate,
    // Use this to get the weekday abbreviations instead of
    // localizations.narrowWeekdays() in order to match Apple's spec
    this.weekdayAbbreviations = const [
      'Su',
      'Mo',
      'Tu',
      'We',
      'Th',
      'Fr',
      'Sa',
    ],
    this.monthAbbreviations = const [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ],
    this.dateFormat,
    this.startWeekOnMonday,
  });

  /// The [DatePickerStyle] to use.
  ///
  /// Defaults to [DatePickerStyle.combined].
  final DatePickerStyle style;

  /// {macro onDateChanged}
  final OnDateChanged onDateChanged;

  /// Set an initial date for the picker.
  ///
  /// Defaults to `DateTime.now()`.
  final DateTime? initialDate;

  /// A list of 7 strings, one for each day of the week, starting with Sunday.
  final List<String> weekdayAbbreviations;

  /// A list of 12 strings, one for each month of the year, starting with January.
  final List<String> monthAbbreviations;

  /// Changes the way dates are displayed in the textual interface.
  ///
  /// The following tokens are supported (case-insensitive):
  /// * `D`: day of the month (1-31)
  /// * `DD`: day of the month (01-31)
  /// * `M`: month of the year (1-12)
  /// * `MM`: month of the year (01-12)
  /// * `YYYY`: year (0000-9999)
  /// * Any separator between tokens is preserved (e.g. `/`, `-`, `.`)
  ///
  /// Defaults to `M/D/YYYY`.
  final String? dateFormat;

  /// Allows for changing the order of day headers in the graphical Date Picker
  /// to Mo, Tu, We, Th, Fr, Sa, Su.
  ///
  /// This is useful for internationalization purposes, as many countries begin their weeks on Mondays.
  ///
  /// Defaults to `false`.
  final bool? startWeekOnMonday;

  @override
  State<MacosDatePicker> createState() => _MacosDatePickerState();
}

class _MacosDatePickerState extends State<MacosDatePicker> {
  final _today = DateTime.now();
  late final _initialDate = widget.initialDate ?? _today;

  late int _selectedDay;
  late int _selectedMonth;
  late int _selectedYear;
  bool _isDaySelected = false;
  bool _isMonthSelected = false;
  bool _isYearSelected = false;
  late final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _parseInitialDate();
  }

  // Splits each part of the formatted initial date by "/" and stores the
  // results
  void _parseInitialDate() {
    _selectedDay = _initialDate.day;
    _selectedMonth = _initialDate.month;
    _selectedYear = _initialDate.year;
  }

  // Formats the currently selected date as a DateTime object
  DateTime _formatAsDateTime() {
    return DateTime(_selectedYear, _selectedMonth, _selectedDay);
  }

  // Increments the currently selected element - day, month, or year
  void _incrementElement() {
    if (_isDaySelected) {
      int daysInMonth = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);
      if (_selectedDay + 1 <= daysInMonth) {
        setState(() => _selectedDay = (_selectedDay + 1));
      } else {
        setState(() => _selectedDay = 1);
      }
    }
    if (_isMonthSelected) {
      if (_selectedMonth + 1 <= 12) {
        setState(() => _selectedMonth++);
      } else {
        setState(() => _selectedMonth = 1);
      }
    }
    if (_isYearSelected) {
      setState(() => _selectedYear++);
    }
    widget.onDateChanged.call(_formatAsDateTime());
  }

  // Decrements the currently selected element - day, month, or year
  void _decrementElement() {
    if (_isDaySelected) {
      int daysInMonth = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);
      if (_selectedDay - 1 >= 1) {
        setState(() => _selectedDay = (_selectedDay - 1));
      } else {
        setState(() => _selectedDay = daysInMonth);
      }
    }
    if (_isMonthSelected) {
      if (_selectedMonth - 1 >= 1) {
        setState(() => _selectedMonth--);
      } else {
        setState(() => _selectedMonth = 12);
      }
    }
    if (_isYearSelected) {
      setState(() => _selectedYear--);
    }
    widget.onDateChanged.call(_formatAsDateTime());
  }

  // Creates the day headers - Su, Mo, Tu, We, Th, Fr, Sa
  // or Mo, Tu, We, Th, Fr, Sa, Su depending on the value of [startWeekOnMonday]
  List<Widget> _dayHeaders(
    TextStyle? headerStyle,
    MaterialLocalizations localizations,
  ) {
    final result = <Widget>[];

    // Hack due to invalid "firstDayOfWeekIndex" implementation in MaterialLocalizations
    // issue: https://github.com/flutter/flutter/issues/122274
    // TODO: remove this workaround once the issue is fixed.
    //  Then, "firstDayOfWeekIndex" can be controlled by passing "localizationsDelegates" and "supportedLocales" to MacosApp
    int firstDayOfWeekIndex = localizations.firstDayOfWeekIndex;
    if (widget.startWeekOnMonday == true) {
      firstDayOfWeekIndex = 1;
    }

    for (int i = firstDayOfWeekIndex; result.length < 7; i = (i + 1) % 7) {
      final weekday = widget.weekdayAbbreviations[i];
      result.add(
        ExcludeSemantics(
          child: Center(
            child: Text(
              weekday,
              style: headerStyle,
            ),
          ),
        ),
      );
    }
    return result;
  }

  // Creates textual date presentation based on "dateFormat" property
  List<Widget> _textualDateElements() {
    final separator = widget.dateFormat != null
        ? widget.dateFormat!.toLowerCase().replaceAll(RegExp(r'[dmy]'), '')[0]
        : '/';

    final List<String> dateElements = widget.dateFormat != null
        ? widget.dateFormat!.toLowerCase().split(RegExp(r'[^dmy]'))
        : ['m', 'd', 'y'];

    final List<Widget> dateFields = <Widget>[];
    for (var dateElement in dateElements) {
      if (dateElement.startsWith('d')) {
        String value = dateElement == 'dd' && _selectedDay < 10
            // Add a leading zero
            ? '0$_selectedDay'
            : '$_selectedDay';

        dateFields.add(
          DatePickerFieldElement(
            isSelected: _isDaySelected,
            element: value,
            onSelected: () {
              setState(() {
                _focusNode.requestFocus();
                _isDaySelected = !_isDaySelected;
                _isMonthSelected = false;
                _isYearSelected = false;
              });
            },
          ),
        );
      } else if (dateElement.startsWith('m')) {
        String value = dateElement == 'mm' && _selectedMonth < 10
            // Add a leading zero
            ? '0$_selectedMonth'
            : '$_selectedMonth';

        dateFields.add(
          DatePickerFieldElement(
            isSelected: _isMonthSelected,
            element: value,
            onSelected: () {
              setState(() {
                _focusNode.requestFocus();
                _isMonthSelected = !_isMonthSelected;
                _isDaySelected = false;
                _isYearSelected = false;
              });
            },
          ),
        );
      } else if (dateElement.startsWith('y')) {
        dateFields.add(
          DatePickerFieldElement(
            isSelected: _isYearSelected,
            element: '$_selectedYear',
            onSelected: () {
              setState(() {
                _focusNode.requestFocus();
                _isYearSelected = !_isYearSelected;
                _isDaySelected = false;
                _isMonthSelected = false;
              });
            },
          ),
        );
      }
      dateFields.add(
        Text(separator),
      );
    }

    dateFields.removeLast();

    return dateFields;
  }

  Widget _buildTextualPicker(MacosDatePickerThemeData datePickerTheme) {
    return KeyboardShortcutRunner(
      onUpArrowKeypress: _incrementElement,
      onDownArrowKeypress: _decrementElement,
      focusNode: _focusNode,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhysicalModel(
            color: datePickerTheme.shadowColor!,
            elevation: 1,
            child: ColoredBox(
              color: datePickerTheme.backgroundColor!,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 3.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _textualDateElements(),
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
                  ignoring:
                      !_isMonthSelected && !_isDaySelected && !_isYearSelected,
                  child: GestureDetector(
                    onTap: _incrementElement,
                    child: PhysicalModel(
                      color: datePickerTheme.shadowColor!,
                      elevation: 1,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(5.0),
                      ),
                      child: CustomPaint(
                        painter: UpCaretPainter(
                          color: datePickerTheme.caretColor!,
                          backgroundColor:
                              datePickerTheme.caretControlsBackgroundColor!,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1.0,
                child: ColoredBox(
                  color: datePickerTheme.caretControlsSeparatorColor!,
                ),
              ),
              SizedBox(
                height: 10.0,
                width: 12.0,
                child: IgnorePointer(
                  ignoring:
                      !_isMonthSelected && !_isDaySelected && !_isYearSelected,
                  child: GestureDetector(
                    onTap: _decrementElement,
                    child: PhysicalModel(
                      color: datePickerTheme.shadowColor!,
                      elevation: 1,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(5.0),
                      ),
                      child: CustomPaint(
                        painter: DownCaretPainter(
                          color: datePickerTheme.caretColor!,
                          backgroundColor:
                              datePickerTheme.caretControlsBackgroundColor!,
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

  Widget _buildGraphicalPicker(
    MacosDatePickerThemeData datePickerTheme,
    List<Widget> dayHeaders,
    List<Widget> dayItems,
  ) {
    return PhysicalModel(
      color: datePickerTheme.shadowColor!,
      child: SizedBox(
        width: 138.0,
        child: ColoredBox(
          color: datePickerTheme.backgroundColor!,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 2.0, top: 2.0, bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.monthAbbreviations[_selectedMonth - 1]} $_selectedYear',
                        style: const TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.08,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MacosIconButton(
                          icon: MacosIcon(
                            CupertinoIcons.arrowtriangle_left_fill,
                            size: 10.0,
                            color: datePickerTheme.monthViewControlsColor,
                          ),
                          backgroundColor: MacosColors.transparent,
                          borderRadius: BorderRadius.zero,
                          padding: EdgeInsets.zero,
                          boxConstraints: const BoxConstraints(
                            maxWidth: 12.0,
                          ),
                          onPressed: () {
                            if (_selectedMonth - 1 < 1) {
                              setState(() {
                                _selectedYear--;
                                _selectedMonth = 12;
                                _selectedDay = 1;
                              });
                            } else {
                              setState(() {
                                _selectedMonth--;
                                _selectedDay = 1;
                              });
                            }
                            widget.onDateChanged.call(_formatAsDateTime());
                          },
                        ),
                        const SizedBox(width: 6.0),
                        MacosIconButton(
                          icon: MacosIcon(
                            CupertinoIcons.circle_fill,
                            size: 8.0,
                            color: datePickerTheme.monthViewControlsColor,
                          ),
                          backgroundColor: MacosColors.transparent,
                          borderRadius: BorderRadius.zero,
                          padding: EdgeInsets.zero,
                          boxConstraints: const BoxConstraints(
                            maxWidth: 12.0,
                          ),
                          onPressed: () {
                            setState(() => _parseInitialDate());
                            widget.onDateChanged.call(_formatAsDateTime());
                          },
                        ),
                        const SizedBox(width: 6.0),
                        MacosIconButton(
                          icon: MacosIcon(
                            CupertinoIcons.arrowtriangle_right_fill,
                            size: 10.0,
                            color: datePickerTheme.monthViewControlsColor,
                          ),
                          backgroundColor: MacosColors.transparent,
                          borderRadius: BorderRadius.zero,
                          padding: EdgeInsets.zero,
                          boxConstraints: const BoxConstraints(
                            maxWidth: 12.0,
                          ),
                          onPressed: () {
                            if (_selectedMonth + 1 > 12) {
                              setState(() {
                                _selectedYear++;
                                _selectedMonth = 1;
                                _selectedDay = 1;
                              });
                            } else {
                              setState(() {
                                _selectedMonth++;
                                _selectedDay = 1;
                              });
                            }

                            widget.onDateChanged.call(_formatAsDateTime());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0, right: 5.0),
                child: Column(
                  children: [
                    GridView.custom(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      gridDelegate: _dayPickerGridDelegate,
                      childrenDelegate: SliverChildListDelegate(
                        dayHeaders,
                        addRepaintBoundaries: false,
                      ),
                    ),
                    Divider(
                      color: datePickerTheme.monthViewHeaderDividerColor,
                      height: 0,
                    ),
                    GridView.custom(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      gridDelegate: _dayPickerGridDelegate,
                      childrenDelegate: SliverChildListDelegate(
                        dayItems,
                        addRepaintBoundaries: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final datePickerTheme = MacosDatePickerTheme.of(context);
    const dayStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 10.0,
      letterSpacing: 0.12,
    );
    final localizations = MaterialLocalizations.of(context);
    final daysInMonth = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);
    final dayOffset =
        DateUtils.firstDayOffset(_selectedYear, _selectedMonth, localizations);
    final dayHeaders = _dayHeaders(
      MacosTheme.of(context).typography.caption1.copyWith(
            color: datePickerTheme.monthViewWeekdayHeaderColor,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.12,
          ),
      localizations,
    );

    // Hack due to invalid "firstDayOfWeekIndex" implementation in MaterialLocalizations
    // issue: https://github.com/flutter/flutter/issues/122274
    // TODO: remove this workaround once the issue is fixed.
    //  Then, DateUtils.getDaysInMonth will work as expected when proper "localizationsDelegates" and "supportedLocales" are provided to MacosApp
    int fixedDayOffset = dayOffset;
    if (widget.startWeekOnMonday == true) {
      fixedDayOffset = dayOffset - 1;
    }

    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
    int day = -fixedDayOffset;

    final dayItems = <Widget>[];

    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(const SizedBox.shrink());
      } else {
        final dayToBuild = DateTime(_selectedYear, _selectedMonth, day);
        final isDisabled = dayToBuild.day < 1 && dayToBuild.day > daysInMonth;
        final isSelectedDay = DateUtils.isSameDay(
          DateTime(_selectedYear, _selectedMonth, _selectedDay),
          dayToBuild,
        );
        final isToday = DateUtils.isSameDay(_today, dayToBuild);

        BoxDecoration? decoration;
        Widget? dayText;

        if (isToday && isSelectedDay) {
          dayText = Text(
            localizations.formatDecimal(day),
            style: dayStyle.apply(
              color: textLuminance(datePickerTheme.monthViewCurrentDateColor!),
            ),
          );
          decoration = BoxDecoration(
            color: datePickerTheme.monthViewCurrentDateColor,
            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
          );
        } else if (isToday) {
          dayText = Text(
            localizations.formatDecimal(day),
            style: dayStyle.apply(
              color: datePickerTheme.monthViewCurrentDateColor,
            ),
          );
        } else if (isSelectedDay) {
          dayText = Text(
            localizations.formatDecimal(day),
            style: dayStyle,
          );
          decoration = BoxDecoration(
            color: datePickerTheme.monthViewSelectedDateColor,
            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
          );
        }

        Widget dayWidget = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _isDaySelected = true;
              _selectedDay = dayToBuild.day;
            });
            widget.onDateChanged.call(_formatAsDateTime());
          },
          child: Container(
            decoration: decoration,
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: dayText ??
                    Text(
                      localizations.formatDecimal(day),
                      style: dayStyle,
                    ),
              ),
            ),
          ),
        );

        if (isDisabled) {
          dayWidget = ExcludeSemantics(
            child: dayWidget,
          );
        }

        dayItems.add(dayWidget);
      }
    }

    switch (widget.style) {
      case DatePickerStyle.textual:
        return _buildTextualPicker(datePickerTheme);
      case DatePickerStyle.graphical:
        return _buildGraphicalPicker(datePickerTheme, dayHeaders, dayItems);
      case DatePickerStyle.combined:
        return Column(
          children: [
            _buildTextualPicker(datePickerTheme),
            const SizedBox(height: 16),
            _buildGraphicalPicker(datePickerTheme, dayHeaders, dayItems),
          ],
        );
    }
  }
}

class _DayPickerGridDelegate extends SliverGridDelegate {
  const _DayPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const int columnCount = DateTime.daysPerWeek;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    final double tileHeight = math.min(
      20.0,
      constraints.viewportMainAxisExtent / (6 + 1),
    );
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: tileHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_DayPickerGridDelegate oldDelegate) => false;
}

const _DayPickerGridDelegate _dayPickerGridDelegate = _DayPickerGridDelegate();

class DatePickerFieldElement extends StatelessWidget {
  const DatePickerFieldElement({
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
    final datePickerTheme = MacosDatePickerTheme.of(context);
    Color backgroundColor = isSelected
        ? datePickerTheme.selectedElementColor!
        : MacosColors.transparent;
    Color textColor = isSelected
        ? datePickerTheme.selectedElementTextColor!
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
