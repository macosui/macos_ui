import 'package:intl/intl.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/macos_colors.dart';

class MacosDateField extends StatefulWidget {
  const MacosDateField({
    Key? key,
    required this.format,
    this.monthYearOnly = false,
  }) : super(key: key);

  final DateFormat format;
  final bool monthYearOnly;

  @override
  State<MacosDateField> createState() => _MacosDateFieldState();
}

class _MacosDateFieldState extends State<MacosDateField> {
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
    _selectedMonth = int.parse(formattedDate.split('/')[1]);
    if (!widget.monthYearOnly) {
      _selectedDay = int.parse(formattedDate.split('/').first);
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.format.pattern);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: MacosColors.systemGrayColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedDay != null) ...[
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
