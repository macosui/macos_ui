import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/selectors/painters.dart';

typedef OnDateChanged = Function(DateTime date);

class MacosDatePicker extends StatefulWidget {
  const MacosDatePicker({
    Key? key,
    required this.format,
    required this.onDateChanged,
  }) : super(key: key);

  final DateFormat format;
  final OnDateChanged onDateChanged;

  @override
  State<MacosDatePicker> createState() => _MacosDatePickerState();
}

class _MacosDatePickerState extends State<MacosDatePicker> {
  final _initialDate = DateTime.now();
  late String formattedDate;
  late int _selectedDay;
  late int _selectedMonth;
  late int _selectedYear;
  bool _isDaySelected = false;
  bool _isMonthSelected = false;
  bool _isYearSelected = false;

  @override
  void initState() {
    super.initState();
    formattedDate = widget.format.format(_initialDate);
    _parseInitialDate();
  }

  void _parseInitialDate() {
    _selectedYear = int.parse(formattedDate.split('/').last);
    _selectedMonth = int.parse(formattedDate.split('/').first);
    _selectedDay = int.parse(formattedDate.split('/')[1]);
  }

  DateTime _formatAsDateTime() {
    return DateTime(_selectedYear, _selectedMonth, _selectedDay);
  }

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

  List<Widget> _dayHeaders(
    TextStyle? headerStyle,
    MaterialLocalizations localizations,
  ) {
    final List<Widget> result = <Widget>[];
    for (int i = localizations.firstDayOfWeekIndex; true; i = (i + 1) % 7) {
      final String weekday = localizations.narrowWeekdays[i];
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

  @override
  Widget build(BuildContext context) {
    final TextStyle dayStyle = MacosTheme.of(context).typography.caption1;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    int daysInMonth = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);
    final int dayOffset =
        DateUtils.firstDayOffset(_selectedYear, _selectedMonth, localizations);
    final List<Widget> dayHeaders = _dayHeaders(
      MacosTheme.of(context).typography.caption1.copyWith(
            color: const MacosColor(0xFFA3A2A3),
            fontWeight: FontWeight.bold,
          ),
      localizations,
    );
    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
    int day = -dayOffset;

    final List<Widget> dayItems = [];

    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(const SizedBox.shrink());
      } else {
        final DateTime dayToBuild =
            DateTime(_selectedYear, _selectedMonth, day);
        final bool isDisabled =
            dayToBuild.day < 1 && dayToBuild.day > daysInMonth;
        final bool isSelectedDay = DateUtils.isSameDay(
          DateTime(_selectedYear, _selectedMonth, _selectedDay),
          dayToBuild,
        );
        final bool isToday = DateUtils.isSameDay(_initialDate, dayToBuild);

        BoxDecoration? decoration;
        Widget? dayText;

        if (isSelectedDay) {
          dayText = Text(
            localizations.formatDecimal(day),
            style: dayStyle,
          );
          decoration = const BoxDecoration(
            color: MacosColors.systemGrayColor,
          );
        }

        if (isToday && isSelectedDay) {
          dayText = Text(
            localizations.formatDecimal(day),
            style: dayStyle,
          );
          decoration = BoxDecoration(
            border: Border.all(color: MacosColors.systemBlueColor, width: 1),
            color: MacosColors.systemBlueColor,
          );
        } else if (isToday) {
          dayText = Text(
            localizations.formatDecimal(day),
            style: dayStyle.apply(color: MacosColors.systemBlueColor),
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
          child: Container(
            decoration: decoration,
            child: Center(
              child: dayText ??
                  Text(
                    localizations.formatDecimal(day),
                    style: dayStyle,
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

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhysicalModel(
              color: const MacosColor(0xFF333333),
              elevation: 1,
              child: ColoredBox(
                color: const MacosColor(0xFF333333), //TODO: light theme color,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 3.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FieldElement(
                        element: '$_selectedMonth',
                        backgroundColor: _isMonthSelected
                            ? MacosColors.systemBlueColor
                            : MacosColors.transparent,
                        onSelected: () {
                          setState(() {
                            _isMonthSelected = !_isMonthSelected;
                            _isDaySelected = false;
                            _isYearSelected = false;
                          });
                        },
                      ),
                      const Text('/'),
                      FieldElement(
                        element: '$_selectedDay',
                        backgroundColor: _isDaySelected
                            ? MacosColors.systemBlueColor
                            : MacosColors.transparent,
                        onSelected: () {
                          setState(() {
                            _isDaySelected = !_isDaySelected;
                            _isMonthSelected = false;
                            _isYearSelected = false;
                          });
                        },
                      ),
                      const Text('/'),
                      FieldElement(
                        element: '$_selectedYear',
                        backgroundColor: _isYearSelected
                            ? MacosColors.systemBlueColor
                            : MacosColors.transparent,
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
                  child: GestureDetector(
                    onTap: _incrementElement,
                    child: const PhysicalModel(
                      color: MacosColor(0xFF333333),
                      elevation: 1,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(5.0),
                      ),
                      child: CustomPaint(
                        painter: UpCaretPainter(
                          color: MacosColors.white,
                          backgroundColor: MacosColor(
                            0xFF333333,
                          ), //todo: correct light theme color
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 1.0,
                  child: ColoredBox(
                    color: const MacosColor(0xFF333333),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                  width: 12.0,
                  child: GestureDetector(
                    onTap: _decrementElement,
                    child: const PhysicalModel(
                      color: MacosColor(0xFF333333),
                      elevation: 1,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(5.0),
                      ),
                      child: CustomPaint(
                        painter: DownCaretPainter(
                          color: MacosColors.white,
                          backgroundColor: MacosColor(
                            0xFF333333,
                          ), //todo: correct light theme color
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: 138.0,
          child: ColoredBox(
            color: const MacosColor(0xFF333333),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(2.0, 2.0, 0.0, 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${intToMonthAbbr(_selectedMonth)} $_selectedYear',
                        style: const TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MacosIconButton(
                            icon: const MacosIcon(
                              CupertinoIcons.arrowtriangle_left_fill,
                              size: 10.0,
                              color: MacosColor(0xFFA3A2A3),
                            ),
                            backgroundColor: MacosColors.transparent,
                            borderRadius: BorderRadius.zero,
                            padding: EdgeInsets.zero,
                            boxConstraints: const BoxConstraints(
                              maxWidth: 12.0,
                            ),
                            onPressed: () {
                              setState(() => _selectedMonth--);
                              widget.onDateChanged.call(_formatAsDateTime());
                            },
                          ),
                          const SizedBox(width: 6.0),
                          MacosIconButton(
                            icon: const MacosIcon(
                              CupertinoIcons.circle_fill,
                              size: 8.0,
                              color: MacosColor(0xFFA3A2A3),
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
                            icon: const MacosIcon(
                              CupertinoIcons.arrowtriangle_right_fill,
                              size: 10.0,
                              color: MacosColor(0xFFA3A2A3),
                            ),
                            backgroundColor: MacosColors.transparent,
                            borderRadius: BorderRadius.zero,
                            padding: EdgeInsets.zero,
                            boxConstraints: const BoxConstraints(
                              maxWidth: 12.0,
                            ),
                            onPressed: () {
                              setState(() => _selectedMonth++);
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
                      const Divider(
                        color: MacosColor(0xFF464646),
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
      ],
    );
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

class FieldElement extends StatelessWidget {
  const FieldElement({
    Key? key,
    required this.element,
    required this.backgroundColor,
    required this.onSelected,
  }) : super(key: key);

  final String element;
  final Color backgroundColor;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: ColoredBox(
        color: backgroundColor,
        child: Text(element),
      ),
    );
  }
}
