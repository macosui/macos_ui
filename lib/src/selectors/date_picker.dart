import 'package:intl/intl.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/selectors/painters.dart';
import 'package:macos_ui/src/theme/macos_colors.dart';

typedef OnDateChanged = Function(DateTime date);

class MacosDatePicker extends StatefulWidget {
  const MacosDatePicker({
    Key? key,
    required this.format,
    required this.onDateChanged,
    this.monthYearOnly = false,
  }) : super(key: key);

  final DateFormat format;
  final OnDateChanged onDateChanged;
  final bool monthYearOnly;

  @override
  State<MacosDatePicker> createState() => _MacosDatePickerState();
}

class _MacosDatePickerState extends State<MacosDatePicker> {
  final _initialDate = DateTime.now();
  late String formattedDate;
  late int? _selectedDay;
  late int _selectedMonth;
  late int _selectedYear;
  bool _isDaySelected = false;
  bool _isMonthSelected = false;
  bool _isYearSelected = false;

  @override
  void initState() {
    super.initState();
    formattedDate = widget.format.format(_initialDate);
    _selectedYear = int.parse(formattedDate.split('/').last);
    _selectedMonth = int.parse(formattedDate.split('/').first);
    if (!widget.monthYearOnly) {
      _selectedDay = int.parse(formattedDate.split('/')[1]);
    }
  }

  DateTime _formatAsDateTime() {
    return DateTime(_selectedYear, _selectedMonth, _selectedDay ?? 0);
  }

  void _incrementElement() {
    if (_selectedDay != null && _isDaySelected) {
      int daysInMonth = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);
      if (_selectedDay! + 1 <= daysInMonth) {
        setState(() => _selectedDay = (_selectedDay! + 1));
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
    if (_selectedDay != null && _isDaySelected) {
      int daysInMonth = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);
      if (_selectedDay! - 1 >= 1) {
        setState(() => _selectedDay = (_selectedDay! - 1));
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PhysicalModel(
          color: const MacosColor(0xFF333333),
          elevation: 1,
          child: ColoredBox(
            color: const MacosColor(0xFF333333), //TODO: light theme color,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_selectedDay != null) ...[
                    PickerElement(
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
                    PickerElement(
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
                    PickerElement(
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
                  ] else ...[
                    PickerElement(
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
                    PickerElement(
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
                          0xFF333333), //todo: correct light theme color
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
                          0xFF333333), //todo: correct light theme color
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
}

class PickerElement extends StatelessWidget {
  const PickerElement({
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
