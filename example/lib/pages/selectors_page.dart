import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class SelectorsPage extends StatefulWidget {
  const SelectorsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectorsPage> createState() => _SelectorsPageState();
}

class _SelectorsPageState extends State<SelectorsPage> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
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