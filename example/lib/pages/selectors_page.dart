import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:macos_ui/macos_ui.dart';

class SelectorsPage extends StatefulWidget {
  const SelectorsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectorsPage> createState() => _SelectorsPageState();
}

class _SelectorsPageState extends State<SelectorsPage> {
  final format = DateFormat.yMd();
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      titleBar: const TitleBar(
        title: Text('macOS UI Selectors'),
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  MacosDatePicker(
                    onDateChanged: (date) => debugPrint('$date'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
