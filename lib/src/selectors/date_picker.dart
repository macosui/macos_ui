import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/selectors/painters.dart';

/// Defines the possibles [MacosDatePicker] styles.
enum DatePickerStyle {
  textual,
  graphical,
  combined,
}

/// {template onDateChanged}
/// The action to perform when a new date is selected.
/// {endtemplate}
typedef OnDateChanged = Function(DateTime date);

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
    Key? key,
    this.style = DatePickerStyle.combined,
    required this.onDateChanged,
  }) : super(key: key);

  /// The [DatePickerStyle] to use.
  ///
  /// Defaults to [DatePickerStyle.combined].
  final DatePickerStyle style;

  /// {macro onDateChanged}
  final OnDateChanged onDateChanged;

  @override
  State<MacosDatePicker> createState() => _MacosDatePickerState();
}

class _MacosDatePickerState extends State<MacosDatePicker> {
  final _initialDate = DateTime.now();
  late int _selectedDay;
  late int _selectedMonth;
  late int _selectedYear;
  bool _isDaySelected = false;
  bool _isMonthSelected = false;
  bool _isYearSelected = false;

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

  // Use this to get the weekday abbreviations instead of
  // localizations.narrowWeekdays() in order to match Apple's spec
  static const List<String> _narrowWeekdays = <String>[
    'Su',
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
  ];

  // Creates the day headers - Su, Mo, Tu, We, Th, Fr, Sa
  List<Widget> _dayHeaders(
    TextStyle? headerStyle,
    MaterialLocalizations localizations,
  ) {
    final result = <Widget>[];
    for (int i = localizations.firstDayOfWeekIndex; true; i = (i + 1) % 7) {
      final weekday = _narrowWeekdays[i];
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
      if (i == (localizations.firstDayOfWeekIndex - 1) % 7) break;
    }
    return result;
  }

  Widget buildTextualPicker(MacosDatePickerThemeData datePickerTheme) {
    return Row(
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
                children: [
                  DatePickerFieldElement(
                    isSelected: _isMonthSelected,
                    element: '$_selectedMonth',
                    onSelected: () {
                      setState(() {
                        _isMonthSelected = !_isMonthSelected;
                        _isDaySelected = false;
                        _isYearSelected = false;
                      });
                    },
                  ),
                  const Text('/'),
                  DatePickerFieldElement(
                    isSelected: _isDaySelected,
                    element: '$_selectedDay',
                    onSelected: () {
                      setState(() {
                        _isDaySelected = !_isDaySelected;
                        _isMonthSelected = false;
                        _isYearSelected = false;
                      });
                    },
                  ),
                  const Text('/'),
                  DatePickerFieldElement(
                    isSelected: _isYearSelected,
                    element: '$_selectedYear',
                    onSelected: () {
                      setState(() {
                        _isYearSelected = !_isYearSelected;
                        _isDaySelected = false;
                        _isMonthSelected = false;
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
    );
  }

  Widget buildGraphicalPicker(
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
                padding: const EdgeInsets.fromLTRB(2.0, 2.0, 0.0, 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${intToMonthAbbr(_selectedMonth)} $_selectedYear',
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
                              });
                            } else {
                              setState(() => _selectedMonth--);
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
                              });
                            } else {
                              setState(() => _selectedMonth++);
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
                padding: const EdgeInsets.fromLTRB(6.0, 0.0, 5.0, 0.0),
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
    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
    int day = -dayOffset;

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
        final isToday = DateUtils.isSameDay(_initialDate, dayToBuild);

        BoxDecoration? decoration;
        Widget? dayText;

        if (isToday && isSelectedDay) {
          dayText = Text(
            localizations.formatDecimal(day),
            style: dayStyle,
          );
          decoration = BoxDecoration(
            color: datePickerTheme.monthViewCurrentDateColor,
            borderRadius: BorderRadius.circular(3.0),
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
            borderRadius: BorderRadius.circular(3.0),
          );
        }

        Widget dayWidget = GestureDetector(
          onTap: () {
            setState(() {
              _isDaySelected = true;
              _selectedDay = dayToBuild.day;
            });
            widget.onDateChanged.call(_formatAsDateTime());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Container(
              decoration: decoration,
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
        return buildTextualPicker(datePickerTheme);
      case DatePickerStyle.graphical:
        return buildGraphicalPicker(datePickerTheme, dayHeaders, dayItems);
      case DatePickerStyle.combined:
        return Column(
          children: [
            buildTextualPicker(datePickerTheme),
            const SizedBox(height: 16),
            buildGraphicalPicker(datePickerTheme, dayHeaders, dayItems),
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
    Key? key,
    required this.element,
    required this.onSelected,
    required this.isSelected,
  }) : super(key: key);

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
